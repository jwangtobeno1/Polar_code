function type1res = func_type1(llr_arr)

    llr = bit_reversed(llr_arr);
    t = reshape(llr,[2,4]);
    sum1 = sum(t(1,:));
    sum2 = sum(t(2,:));
    if(sum1 >= 0)
        b1 = 0;
    else
        b1 = 1;
    end
    
    if(sum2 >= 0)
        b2 = 0;
    else
        b2 = 1;
    end
    type1res = repmat([b1,b2], [1,4]);
    