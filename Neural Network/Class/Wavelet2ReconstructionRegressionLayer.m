classdef Wavelet2ReconstructionRegressionLayer < nnet.layer.RegressionLayer
    properties
        T = getGlobalImage; 
    end

    methods
    %% Constructor
        function layer = Wavelet2ReconstructionRegressionLayer(name)
            % layer = Wavelet2ReconstructionRegressionLayer(name) creates an
            % output layer for 2-coefficient wavelet reconstruction learning
		    
            % Set layer name.
            layer.Name = name;
    
            % Set layer description.
            layer.Description = 'Output layer for 2 coefficient wavelet reconstruction learning';
        end
    %% Forward Loss    
        function loss = forwardLoss(layer,Y,T)            
            % Return the loss between the predictions Y and the training
            % targets T.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %        loss  - Loss between Y and T 
      %T updates with a new column after each sample in the minibatch,
      %So we need to make sure we are using the latest column
    
            Y = double(Y);
            T = getGlobalImage;  % Accessing input image X 
            minibatch_size = size(Y,2);  %column            
            loss = 0;  % loss_val storage
            
            for k = 1 : minibatch_size
                LoD = Y(1:2,k); % First half of output vector is decomp filter
                LoR = Y(3:4,k); % Second half is synthesis filter
    
                HiD = LoR;
                HiD(1) = -HiD(1);
                HiR = LoD;
                HiR(2) = -HiR(2);
                
                T_k = T(k,:);
                T_k = cell2mat(T_k);
    
                [cA,cD] = dwt(T_k,LoD,HiD);
                rec = idwt(cA,cD,LoR,HiR);
                rec = double(rec);
                 
                loss_individual = immse(rec,T_k); % Image Mean-Square error
                                                  % read forward-loss in
                                                  % deep learning
                        
                loss = loss + loss_individual;   % Adding up loss for the minibatch           
            end
                  
            loss = loss / minibatch_size;  % Taking average wrt batch size
            loss = single(loss);           % Convert to single precision array
    
        end
    %% Backpropagation
        function dLdY = backwardLoss(layer, Y, T)
            % (Optional) Backward propagate the derivative of the loss 
            % function.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         dLdY  - Derivative of the loss with respect to the 
            %                 predictions Y        
    
            T = double(T);
            Y = double(Y);
            
            Yrow = size(Y,2);
            Ycol = size(Y,1);
    
            minibatch_size = Yrow;
               
            dLdY = zeros(Ycol,Yrow);
            
            for k = 1 : minibatch_size
                
                LoD = Y(1:2,k); % First quarter of output vector is LoD
                LoR = Y(3:4,k); % Second quarter is LoR etc
    
                HiD = LoR;
                HiD(1) = -HiD(1);
                HiR = LoD;
                HiR(2) = -HiR(2);
                
                T = getGlobalImage;
    
                T_k = T(k,:);
                T_k = cell2mat(T_k);
                [cA,cD] = dwt(T_k,LoD,HiD);
                rec = idwt(cA,cD,LoR,HiR);
                rec = double(rec);
    
                diff = rec - T_k; % Element wise difference between reconstructed signal and original signal             
                dLdY(1:4,k) = cost2forDL(diff,LoD,LoR,T_k);
               
            end
        
            dLdY = dLdY./minibatch_size;   
            dLdY = single(dLdY);           
        end             
    end

end
