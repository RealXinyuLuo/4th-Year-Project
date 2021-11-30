function cost_vector = cost2forDLentropy(diff,T)
cost_vector = zeros(4,1);
diff = diff';
    for k = 1 : length(diff) -1
        if rem(k,2) == 1
            cost_vector(1) = cost_vector(1) + T(k) * diff(k);
            cost_vector(2) = cost_vector(2) + T(k+1) * diff(k);
            cost_vector(3) = cost_vector(3) + T(k) * diff(k);
            cost_vector(4) = cost_vector(4) + T(k+1) * diff(k);
        else
            cost_vector(1) = cost_vector(1) + T(k-1) * diff(k);
            cost_vector(2) = cost_vector(2) + T(k) * diff(k);
            cost_vector(3) = cost_vector(3) + T(k-1) * diff(k);
            cost_vector(4) = cost_vector(4) + T(k) * diff(k);
        end
    end
        