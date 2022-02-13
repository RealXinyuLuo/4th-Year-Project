function [LoD,LoR,HiD,HiR] = make2coeffwavelet(act)
%Calculate the decompoition filters and recontruction filters
    LoD = act(1:2); % First half of output vector is decomp filter
    LoR = act(3:4); % Second half is synthesis filter

    HiD = LoR;   
    HiD(1) = - HiD(1);    % LoR = [a b]', HiD = [-a, b]' 
    HiR = LoD;
    HiR(2) = -HiR(2);    % LoD = [a b]', HiR = [a, -b]'   
end
