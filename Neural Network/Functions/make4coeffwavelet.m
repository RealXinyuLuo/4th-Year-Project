function  [LoD,LoR,HiD,HiR] = make4coeffwavelet(act)



        LoD = act(1:4); % First half of output vector is decomp filter
        LoR = act(5:8); % Second half is synthesis filter
        HiD = LoR;
        HiD(1) = - HiD(1);
        HiD(3) = - HiD(3);
        HiR = LoD;
        HiR(2) = -HiR(2);
        HiR(4) = -HiR(4);
end

