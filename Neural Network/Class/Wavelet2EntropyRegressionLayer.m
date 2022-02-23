classdef Wavelet2EntropyRegressionLayer < nnet.layer.RegressionLayer
    properties
        T
        bits
    end
    
    methods
        function layer = Wavelet2EntropyRegressionLayer(target,bits)

            layer.Name = 'Wavelet2EntropyRegressionLayer';
            layer.Description = 'Output layer for 2 coefficient wavelet entropy reduction learning';
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

                [LoD,LoR,HiD,HiR] = make2coeffwavelet(Y(:,k));
                T_k = cell2mat(T(k,:));

                [cA,cD] = dwt(T_k,LoD,HiD);

                cA_rescaled = rescale(cA,0,1);
                T_k_downscaled = imresize(T_k,0.5);

                cA_diff = T_k_downscaled - cA_rescaled; 

                cD_diff = 0 - cD;

                loss_individual = norm(cA_diff)+ norm(cD_diff);
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
                
                
                [LoD,LoR,HiD,HiR] = make2coeffwavelet(Y(:,k));

                T_k = cell2mat(T(k,:));
                [cA,cD] = dwt(T_k,LoD,HiD);
                
                cA_rescaled = rescale(cA,0,1);
                T_k_downscaled = imresize(T_k,0.5);

                
                cA_diff = T_k_downscaled - cA_rescaled; 
                cD_diff = 0 - cD;

                
                dLdY(1:4,k) = cost2forDLentropy(cA_diff,cD_diff,LoD,LoR,T_k);
                
            end
                    
            dLdY = dLdY./minibatch_size;            
            dLdY = single(dLdY);         
        end
          
    end
end
