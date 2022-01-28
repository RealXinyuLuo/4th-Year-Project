

function cost_vector = cost2forDL(diff,LoD,LoR,T)
    % Cost function for 2-coefficient filter - Deep Leaning 
    % Inputs:
    %       diff: element-wise difference between input 1d signal and reconstructed signal 
    %       LoD: low-pass decomposition filter 
    %       LoR: low-pass reconstruction filter 
    %       T: Truth, actual input image 

    cost_vector = zeros(4,1);
    diff = diff';   %matlab transpose pg21 ish
    
    for k = 1 : length(diff) -1
        if rem(k,2) == 1  % if k is an odd number 
            % maths in report
            % weird maths in report 
            cost_vector(1) = cost_vector(1) + T(k) * LoR(1) * diff(k); % Need to swap 2 and 1 because indices from Df and LoD seems to swap
            cost_vector(2) = cost_vector(2) + T(k+1) * LoR(1) * diff(k);
            cost_vector(3) = cost_vector(3) + (T(k)*LoD(1) + T(k+1)*LoD(2) - T(k)*LoR(2)) * diff(k);
            cost_vector(4) = cost_vector(4) + (-T(k)*LoR(1) + 2*T(k+1)*LoR(2)) * diff(k);
        else % if k is an even number 
            cost_vector(1) = cost_vector(1) + (T(k-1) + T(k-1)*LoD(1) + T(k-1)*LoD(2)) * diff(k);
            cost_vector(2) = cost_vector(2) + (T(k)*LoD(1) + T(k-1)*LoR(1) - T(k)*LoR(2)) * diff(k);
            cost_vector(3) = cost_vector(3) + (T(k-1)*LoD(2)) * diff(k);
            cost_vector(4) = cost_vector(4) + (-T(k)*LoD(2)) * diff(k);
        end
    end
        
