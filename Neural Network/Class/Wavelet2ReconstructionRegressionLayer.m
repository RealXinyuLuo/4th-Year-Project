classdef Wavelet2ReconstructionRegressionLayer < nnet.layer.RegressionLayer
    properties 

    end

    methods
        function layer = TestRegressionLayer(name)
            % layer = maeRegressionLayer(name) creates a
            % mean-absolute-error regression layer and specifies the layer
            % name.
			
            % Set layer name.
            layer.Name = name;

            % Set layer description.
            layer.Description = 'Output layer for 2 coefficient wavelet reconstruction learning';

            layer.T = getGlobalImage;
        end
        
        function loss = forwardLoss(layer, Y, T)
            % Y: read doc 
            % T: ground truth image 
      %T updates with a new column after each sample in the minibatch,
      %So we need to make sure we are using the latest column
            T = double(T);
            Y = double(Y);     % 4*k
            

            Yrow = size(Y,1);
            Ycol = size(Y,2);

            minibatch_size = Ycol; 
            
            loss = 0;  % loss_val storage
            
            for k = 1 : minibatch_size

                [LoD,LoR,HiD,HiR] = make2coeffwavelet(Y(:,k));
                
                T = getGlobalImage;  %Accessing input image X 
                
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

            T = double(T);
            Y = double(Y);
            
            Yrow = size(Y,1);
            Ycol = size(Y,2);

            minibatch_size = Ycol;
            
            dLdY = zeros(Yrow,Ycol);
            
            for k = 1 : minibatch_size   % for each minibatch 

                [LoD,LoR,HiD,HiR] = make2coeffwavelet(Y(:,k));
                
                T = getGlobalImage;  
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
