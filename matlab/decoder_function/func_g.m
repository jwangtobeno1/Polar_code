function gres = func_g(llr,b_arr)
    
    b = bit_reversed(b_arr);
    len = length(llr);
    gres = zeros(1,len/2);
    for i = 1 : 2 : len
       j = ceil(i/2);
       gres(j) = llr(i+1) + (1-2*b(j)) * llr(i);
    end