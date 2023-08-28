function rate1res = func_rate1(llr_arr)

    llr = bit_reversed(llr_arr);
    len = length(llr_arr);
    rate1res = zeros(1,len);
    for i = 1 : 1 : len
        if(llr(i) < 0)
            rate1res(i) = 1;
        end
    end