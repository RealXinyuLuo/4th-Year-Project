

classdef Wavelet2ReconstructionRegressionLayer < nnet.layer.RegressionLayer
    properties
        T
        bits
    end

    methods
        function layer = Wavelet2ReconstructionRegressionLayer(target,bits)
            % constructor
            % layer = Wavelet2ReconstructionRegressionLayer(name,bits) 
            % creates a regression layer and specifies the layer name and 
            % pass in bits
			
            layer.Name = 'Wavelet2ReconstructionRegressionLayer';
            layer.Description = 'Output layer for 2 coefficient wavelet reconstruction learning';
            layer.T = target;
            layer.bits = bits;
        end
        
        function loss = forwardLoss(layer,Y,T)
            % Y: Neural Network prediction 
            % T: ground truth image 
            % Y updates a column after each sample in the minibatch,
            % So we need to make sure we are using the latest column         
      
            T = layer.T;
            Y = double(Y);     % 4*k
            

            Yrow = size(Y,1);
            Ycol = size(Y,2);

            minibatch_size = Ycol; 
            
            loss = 0;  % loss_val storage
            
            for k = 1 : minibatch_size

                [LoD,LoR,HiD,HiR] = make2coeffwavelet(Y(:,k));
                
                
                T_k = cell2mat(T(k,:));

                [cA,cD] = dwt(T_k,LoD,HiD);

                rec = idwt(cA,cD,LoR,HiR);
                rec = double(rec);
                 
                loss_individual = immse(rec,T_k); %Image Mean-Square error
                                                  % read forward-loss in
                                                  % deep learning

                
                        
                loss = loss + loss_individual;   %Adding up loss for the minibatch           
            end
            
            
            
            loss = loss / minibatch_size;

            loss = single(loss);

        end

        function dLdY = backwardLoss(layer, Y, T)  
            
            T = layer.T;
            Y = double(Y);
            
            Yrow = size(Y,1);
            Ycol = size(Y,2);

            minibatch_size = Ycol;     
            dLdY = zeros(Yrow,Ycol);
            
            for k = 1 : minibatch_size   % for each minibatch 

                [LoD,LoR,HiD,HiR] = make2coeffwavelet(Y(:,k));
                
                T_k = cell2mat(T(k,:));

                [cA,cD] = dwt(T_k,LoD,HiD); % cA and cD latent space elements
                
                rec = idwt(cA,cD,LoR,HiR);
                rec = double(rec);

                diff = rec - T_k; % Element wise difference between reconstructed signal and original signal             
                
                dLdY(1:4,k) = cost2forDL(diff,LoD,LoR,T_k);
               
            end
                     
            dLdY = dLdY./minibatch_size;  % might not be needed 
            dLdY = single(dLdY);

            
        end  
            
    end
end
