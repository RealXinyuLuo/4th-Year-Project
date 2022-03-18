classdef Wavelet4ReconstructionRegressionLayer < nnet.layer.RegressionLayer
    properties
        T
        bits
    end
    
    methods
        function layer = Wavelet4ReconstructionRegressionLayer(target,bits,name)

            layer.Name = name;
            layer.Description = 'Output layer for 4 coefficient wavelet reconstruction learning';
            layer.T = target;
            layer.bits = bits;
        end
        
        function loss = forwardLoss(layer, Y, T)

            T = layer.T;
            Y = double(Y);

            Ycol = size(Y,2);
            minibatch_size = Ycol;
            loss = 0;
            
            for k = 1 : minibatch_size
                T_k = cell2mat(T(k,:));
                [LoD,LoR,HiD,HiR] = make4coeffwavelet(Y(:,k));            

                [cA,cD] = dwt(T_k,LoD,HiD);

                % quantization
                quantized_cA = uniformquantization(cA,layer.bits)';
                quantized_cD = uniformquantization(cD,layer.bits)';

                rec = idwt(quantized_cA,quantized_cD,LoR,HiR);       

                %rec = idwt(cA,cD,LoR,HiR);         
                rec = double(rec);

                loss_individual = immse(rec,T_k);
                loss = loss + loss_individual; 

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
            
            for k = 1 : minibatch_size
                T_k = cell2mat(T(k,:));             
                [LoD,LoR,HiD,HiR] = make4coeffwavelet(Y(:,k));     
                

                [cA,cD] = dwt(T_k,LoD,HiD);

                % quantization
                quantized_cA = uniformquantization(cA,layer.bits)';
                quantized_cD = uniformquantization(cD,layer.bits)';

                %rec = idwt(quantized_cA,quantized_cD,LoR,HiR);   


                rec = idwt(cA,cD,LoR,HiR);
                rec = double(rec);

                diff = rec - T_k; % Element wise difference between reconstructed signal and original signal
        
                dLdY(1:8,k) = cost4forDL(diff,LoD,LoR,T_k);

            end         
            dLdY = dLdY./minibatch_size;

            dLdY = single(dLdY);


            
        end
             
    end
end
