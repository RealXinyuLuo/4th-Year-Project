function cost_vector = cost4forDL(diff,LoD,LoR,T)
cost_vector = zeros(8,1);
diff = diff';
L1 = LoD(1); L2 = LoD(2); L3 = LoD(3); L4 = LoD(4);
Lr1 = LoR(1); Lr2 = LoR(2); Lr3 = LoR(3); Lr4 = LoR(4);

    for k = 1 : length(diff)  
        if rem(k,4) == 1  
            I1 = T(k); I2 = T(k+1); I3 = T(k+2); I4 = T(k+3);
            
            A1 = L4*I2 + L3*I1 + L2*I1 + L1*I2;
            A2 = L4*I1 + L3*I2 + L2*I3 + L1*I4;
            A3 = L4*I3 + L3*I4 + L2*I4 + L1*I3;
            D1 = Lr4*I2 + -Lr3*I1 + Lr2*I1 + -Lr1*I2;
            D2 = Lr4*I1 + -Lr3*I2 + Lr2*I3 + -Lr1*I4;
            D3 = Lr4*I3 + -Lr3*I4 + Lr2*I4 + -Lr1*I3;
            
            cost_vector(1) = cost_vector(1) + (--Lr3*I2 - -Lr1*I4 + D2) * diff(k);
            cost_vector(2) = cost_vector(2) + (--Lr3*I1 - -Lr1*I3) * diff(k);
            cost_vector(3) = cost_vector(3) + (--Lr3*I1 - -Lr1*I2 + D1) * diff(k);
            cost_vector(4) = cost_vector(4) + (--Lr3*I2 - -Lr1*I1) * diff(k);
            cost_vector(5) = cost_vector(5) + (L3*I2 + L1*I4 - A2) * diff(k);
            cost_vector(6) = cost_vector(6) + (L3*I1 + L1*I3) * diff(k);
            cost_vector(7) = cost_vector(7) + (L3*I1 + L1*I2 - A1) * diff(k);
            cost_vector(8) = cost_vector(8) + (L3*I2 + L1*I1) * diff(k);   
        end
            
        if rem(k,4) == 2     
            %I1 = images(k-1,i); I2 = images(k,i); I3 = images(k+1,i); I4 = images(k+2,i);
            cost_vector(1) = cost_vector(1) + (Lr4*I2 + Lr2*I4) * diff(k);
            cost_vector(2) = cost_vector(2) + (Lr4*I1 + -Lr1*I3 - D2) * diff(k);
            cost_vector(3) = cost_vector(3) + (Lr4*I1 + Lr2*I2) * diff(k);
            cost_vector(4) = cost_vector(4) + (Lr4*I2 + Lr2*I1 - D1) * diff(k);
            cost_vector(5) = cost_vector(5) + (-L4*I2 - L2*I4) * diff(k);
            cost_vector(6) = cost_vector(6) + (-L4*I1 - L2*I3 + A2) * diff(k);
            cost_vector(7) = cost_vector(7) + (-L4*I1 - L2*I2) * diff(k);
            cost_vector(8) = cost_vector(8) + (-L4*I2 - L2*I1 + A1) * diff(k);        
        end
        
        if rem(k,4) == 3 
            %I1 = images(k-2,i); I2 = images(k-1,i); I3 = images(k,i); I4 = images(k+1,i);            
            cost_vector(1) = cost_vector(1) + (--Lr3*I4 - -Lr1*I3 + D3) * diff(k);
            cost_vector(2) = cost_vector(2) + (--Lr3*I3 - -Lr1*I4) * diff(k);
            cost_vector(3) = cost_vector(3) + (--Lr3*I2 - -Lr1*I4 + D2) * diff(k);
            cost_vector(4) = cost_vector(4) + (--Lr3*I1 - -Lr1*I3) * diff(k);
            cost_vector(5) = cost_vector(5) + (L3*I4 + L1*I4 - A3) * diff(k);
            cost_vector(6) = cost_vector(6) + (L3*I3 + L1*I4) * diff(k);
            cost_vector(7) = cost_vector(7) + (L3*I2 + L1*I4 - A2) * diff(k);
            cost_vector(8) = cost_vector(8) + (L3*I1 + L1*I3) * diff(k);
            
        end
        
        if rem(k,4) == 0          
            %I1 = images(k-3,i); I2 = images(k-2,i); I3 = images(k-1,i); I4 = images(k,i);    
            cost_vector(1) = cost_vector(1) + (Lr4*I4 + Lr2*I3) * diff(k);
            cost_vector(2) = cost_vector(2) + (Lr4*I3 + Lr2*I4 - D3) * diff(k);
            cost_vector(3) = cost_vector(3) + (Lr4*I2 + Lr2*I4) * diff(k);
            cost_vector(4) = cost_vector(4) + (Lr4*I1 + Lr2*I3 - D2) * diff(k);
            cost_vector(5) = cost_vector(5) + (-L4*I4 - L2*I3) * diff(k);
            cost_vector(6) = cost_vector(6) + (-L4*I3 - L2*I4 + A3) * diff(k);
            cost_vector(7) = cost_vector(7) + (-L4*I2 - L2*I4) * diff(k);
            cost_vector(8) = cost_vector(8) + (-L4*I1 - L2*I3 + A2) * diff(k);
            
        end
    end
    