function cost_vector = cost2forDLentropy(cA_diff,cD_diff,LoD,LoR,T)
    cost_vector = zeros(4,1);
    cA_diff = cA_diff';
    cD_diff = cD_diff';
    
    for k = 1 : length(cA_diff)
        if rem(k,2) == 1
%             cost_vector(1) = cost_vector(1) + T(k) * cA_diff(k);
            cost_vector(2) = cost_vector(2);
            cost_vector(3) = cost_vector(3) + T(k) * cD_diff(k);
            cost_vector(4) = cost_vector(4);
        else
            cost_vector(1) = cost_vector(1);
%             cost_vector(2) = cost_vector(2) + T(k) * cA_diff(k-1);
            cost_vector(3) = cost_vector(3);
            cost_vector(4) = cost_vector(4) - T(k) * cD_diff(k-1);
        end
    end
        
