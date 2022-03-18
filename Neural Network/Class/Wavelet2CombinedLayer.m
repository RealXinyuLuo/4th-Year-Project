classdef Wavelet2CombinedLayer < nnet.layer.RegressionLayer
    properties
        T
        bits
    end

    methods
        function layer = Wavelet2CombinedLayer(target,nn_bits,name)
            % constructor
            % layer = Wavelet2ReconstructionRegressionLayer(name,bits) 
            % creates a regression layer and specifies the layer name and 
            % pass in bits
			
            layer.Name = name;
            layer.Description = 'Output layer for 2 coefficient wavelet reconstruction learning';
            layer.T = target;
            layer.bits = nn_bits;
        end
        
        function loss = forwardLoss(layer,Y,T)
            % Y: Neural Network prediction 
            % T: ground truth image 
            % Y updates a column after each sample in the minibatch,
            % So we need to make sure we are using the latest column         
      
            T = layer.T;
            Y = double(Y);     % 4*k
            
            Ycol = size(Y,2);

            minibatch_size = Ycol; 
            
            loss = 0;  % loss_val storage
            
            for k = 1 : minibatch_size
                T_k = cell2mat(T(k,:));
                
                [LoD,LoR,HiD,HiR] = make2coeffwavelet(Y(:,k));

                [cA,cD] = dwt(T_k,LoD,HiD);

                % Quantization
                quantized_cA = uniformquantization(cA,layer.bits)';
                quantized_cD = uniformquantization(cD,layer.bits)';

                rec = idwt(quantized_cA,quantized_cD,LoR,HiR);                

                %rec = idwt(cA,cD,LoR,HiR);
                rec = double(rec);
                 
                loss_individual = immse(rec,T_k); %Image Mean-Square error
                                                  % read forward-loss in
                                                  % deep learning

                
                        
                loss = loss + loss_individual;   %Adding up loss for the minibatch           
            end
            
            
            
            loss = loss./ minibatch_size;

            loss = single(loss);

        end

        function dLdY = backwardLoss(layer, Y, T)
            % dLdY = backwardLoss(layer, Y, T) returns the derivatives of
            % the loss with respect to the predictions Y.
            
            T = layer.T;
            Y = double(Y);
            
            Yrow = size(Y,1);
            Ycol = size(Y,2);
            minibatch_size = Ycol;  
            dLdY = zeros(Yrow,Ycol);
            dLdY_reg = zeros(Yrow,Ycol);
            dLdY_entropy = zeros(Yrow,Ycol);

             % for each minibatch 
            for k = 1 : minibatch_size  
                T_k = cell2mat(T(k,:));
                [LoD,LoR,HiD,HiR] = make2coeffwavelet(Y(:,k));
                [cA,cD] = dwt(T_k,LoD,HiD); % cA and cD latent space elements


                % Rescaling the latent space and the 
                cA_rescaled = rescale(cA,0,1);
                T_k_downscaled = imresize(T_k,0.5);
                
                
                % Quantization 
                quantized_cA = uniformquantization(cA,layer.bits)';
                quantized_cD = uniformquantization(cD,layer.bits)';
                
                cA_quant_rescaled = rescale(quantized_cA ,0,1);

                cA_quant_diff = T_k_downscaled - cA_quant_rescaled; 
                cD_quant_diff = 0 - quantized_cD;

                rec = idwt(quantized_cA,quantized_cD,LoR,HiR);

                %rec = idwt(cA,cD,LoR,HiR);
                rec = double(rec);
                diff = rec - T_k; % Element wise difference between reconstructed signal and original signal                       
               
                
                dLdY_reg(1:4,k) = cost2forDL(diff,LoD,LoR,T_k);
                dLdY_entropy(1:4,k) = cost2forDLentropy(cA_quant_diff,cD_quant_diff,LoD,LoR,T_k);

                dLdY(1:4,k) = dLdY_reg(1:4,k) + dLdY_entropy(1:4,k);
            end
                     
            dLdY = dLdY./minibatch_size;  % might not be needed 
            dLdY = single(dLdY);

            
        end  
            
    end
end
