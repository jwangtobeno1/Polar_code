function fres = func_f(llr)
    
    len = length(llr);
    fres = zeros(1,len/2);
    q = 0;
    for i =1 : 2 : len
        q = q + 1;
        fres(q) = sign(llr(i))*sign(llr(i+1))*min(abs(llr(i)),abs(llr(i+1)));
    end