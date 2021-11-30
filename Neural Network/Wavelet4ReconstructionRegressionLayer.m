classdef Wavelet4ReconstructionRegressionLayer < nnet.layer.RegressionLayer
    % Example custom regression layer with mean-absolute-error loss.
    
    methods
        function layer = TestRegressionLayer(name)
            % layer = maeRegressionLayer(name) creates a
            % mean-absolute-error regression layer and specifies the layer
            % name.
			
            % Set layer name.
            layer.Name = name;

            % Set layer description.
            layer.Description = 'Output layer for 4 coefficient wavelet reconstruction learning';
        end
        
        function loss = forwardLoss(layer, Y, T)
%             isYsingle = fi(Y);
%             isYsingle = issingle(isYsingle);
            
      %T updates with a new column after each sample in the minibatch,
                                % So we need to make sure we are using the
                                % latest column
            T = double(T);
            Y = double(Y);
            
            s = size(Y);
            minibatch_size = s(2);
            
            loss = 0;
            
            for k = 1 : minibatch_size
                

                LoD = Y(1:4,k); % First half of output vector is decomp filter
                LoR = Y(5:8,k); % Second half is synthesis filter
                HiD = LoR;
                HiD(1) = - HiD(1);
                HiD(3) = - HiD(3);
                HiR = LoD;
                HiR(2) = -HiR(2);
                HiR(4) = -HiR(4);

                T = getGlobalImage;
                
                T_k = T(k,:);
                T_k = cell2mat(T_k);
                [cA,cD] = dwt(T_k,LoD,HiD);
                rec = idwt(cA,cD,LoR,HiR); %Inverse DW transform
                 
                rec = double(rec);

                loss_individual = immse(rec,T_k);
                loss = loss + loss_individual;   %Adding up loss for the minibatch


                
            end
            
            
            
            loss = loss / minibatch_size;
%             if isYsingle == 1
            loss = single(loss);
%             end
            %loss = single(loss);

        end
        function dLdY = backwardLoss(layer, Y, T)

            T = double(T);
            Y = double(Y);
            
            s = size(Y);
            minibatch_size = s(2);
            
%             isYsingle = fi(Y);
%             isYsingle = issingle(isYsingle);
            
            dLdY = zeros(s(1),s(2));
            
            for k = 1 : minibatch_size
                
                LoD = Y(1:4,k); % First half of output vector is decomp filter
                LoR = Y(5:8,k); % Second half is synthesis filter
                
                HiD = LoR;
                HiD(1) = - HiD(1);
                HiD(3) = - HiD(3);
                HiR = LoD;
                HiR(2) = -HiR(2);
                HiR(4) = -HiR(4);

                T = getGlobalImage;
                
                T_k = T(k,:);
                T_k = cell2mat(T_k);
                [cA,cD] = dwt(T_k,LoD,HiD);
                rec = idwt(cA,cD,LoR,HiR);
                rec = double(rec);

                diff = rec - T_k; % Element wise difference between reconstructed signal and original signal
        
                dLdY(1:8,k) = cost4forDL(diff,LoD,LoR,T_k);

            end         
            dLdY = dLdY./minibatch_size;
             
%             if isYsingle == 1
            dLdY = single(dLdY);
%             end
%             dLdY = single(dLdY);

            
        end
    
            
        end
end