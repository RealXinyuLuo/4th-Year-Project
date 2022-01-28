% this code works but maths for Cost2forDL not working so,.... 

classdef Wavelet2EntropyRegressionLayer < nnet.layer.RegressionLayer
    % Example custom regression layer with mean-absolute-error loss.
    
    methods
        function layer = TestRegressionLayer(name)
            % layer = maeRegressionLayer(name) creates a
            % mean-absolute-error regression layer and specifies the layer
            % name.
			
            % Set layer name.
            layer.Name = name;

            % Set layer description.
            layer.Description = 'Output layer for 2 coefficient wavelet entropy reduction learning';
        end
        
        function loss = forwardLoss(layer, Y, T)         
            isYsingle = fi(Y);
            isYsingle = issingle(isYsingle);
            
      %T updates with a new column after each sample in the minibatch,
                                % So we need to make sure we are using the
                                % latest column
            T = double(T);
            Y = double(Y);
            
            s = size(Y);
            minibatch_size = s(2);
            
            loss = 0;
            
            for k = 1 : minibatch_size
                
                LoD = Y(1:2,k); % First half of output vector is decomp filter
                LoR = Y(3:4,k); % Second half is synthesis filter
                HiD = LoR;
                HiD(1) = - HiD(1);
                
                HiR = LoD;
                HiR(2) = -HiR(2);
                
                T = getGlobalImage;

                T_k = T(k,:);
                T_k = cell2mat(T_k);
                [cA,cD] = dwt(T_k,LoD,HiD);
%                 cA = normalise(cA, 'range'); cD = normalise(cD, 'range');
                cA_norm = normalize(cA,'range');
                cD_norm = normalize(cD,'range');
                loss_individual = entropy(cD_norm)+ entropy(cA_norm);
                loss = loss + loss_individual;   %Adding up loss for the minibatch

            end
            
            
            
            loss = loss / minibatch_size;
            if isYsingle == 1
            loss = single(loss);
            end
            %loss = single(loss);
            
            % Take mean over mini-batch.
%             N = size(Y,4);
%             loss = sum(meanAbsoluteError)/N;
        end
        
        
        function dLdY = backwardLoss(layer, Y, T)

            T = double(T);
            Y = double(Y);
            
            s = size(Y);
            minibatch_size = s(2);
            
            isYsingle = fi(Y);
            isYsingle = issingle(isYsingle);
            
            dLdY = zeros(s(1),s(2));
            
            for k = 1 : minibatch_size
                
                LoD = Y(1:2,k); % First half of output vector is decomp filter
                LoR = Y(3:4,k); % Second half is synthesis filter
                HiD = LoR;
                HiD(1) = - HiD(1);
                
                HiR = LoD;
                HiR(2) = -HiR(2);
                
                
                T = getGlobalImage;

                T_k = T(k,:);
                T_k = cell2mat(T_k);
                [cA,cD] = dwt(T_k,LoD,HiD);
                %cA = normalise(cA, 'range'); cD = normalise(cD, 'range');
                median_cA = median(cA);
                median_cD = median(cD);
                sizeT_k = size(T_k);
                sizeT_k = sizeT_k(1);
                rec = zeros(sizeT_k,1);
                
%                 for j = 1:sizeT_k(1)
%                     if rem(j,2) == 1
%                         rec(j) = median_cA;
%                     else
%                         rec(j) = median_cD;
%                     end
%                 end
                
                transform = zeros(size(T_k));

                for n = 1:sizeT_k(1)/2
                    transform(2*n-1) = cA(n);
                    transform(2*n)=cD(n);
                end
                
                diff = rec - transform; % Element wise difference between reconstructed signal and original signal
%                 diff = diff ./ (abs(diff).*abs(diff));
%                 diff = diff ./ abs(diff);
                
                
                dLdY(1:4,k) = cost2forDLentropy(diff,T_k);
                
%                 wavemngr('del','test'); %Delete current wavelet so new one can be added in the next loop
%                 delete('test.mat')
            end
            

            
            dLdY = dLdY./minibatch_size;
            
%             YL2norm = norm(Y);
%             YL2norm = YL2norm / (minibatch_size*s(1));             
%             dLdY = dLdY+YL2norm;
%             
            if isYsingle == 1
            dLdY = single(dLdY);
            end
            dLdY = single(dLdY);

            
        end
        
        end
end
