function repres = func_rep(llr)

    len = length(llr);
    sum = 0;
    for i = 1 : 1 : len
        sum = sum + llr(i);
    end
    
    if(sum >= 0)
        repres = zeros(1,len);
    else
        repres = ones(1,len);
    end