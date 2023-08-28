function spcres = func_spc(llr_arr, bitrev_flag)

    if (nargin == 1)
        bitrev_flag = 1;
    end
    
    len = length(llr_arr);
    spcres = zeros(1,len);
    if(bitrev_flag == 1)
        llr = bit_reversed(llr_arr); 
    else
        llr = llr_arr;
    end
    temp = 0;
    index = 0;
    for i = 1 : 1 : len
       if(llr(i) >= 0)
           spcres(i) = 0;
           temp = xor(temp,0);
       else
           spcres(i) = 1;
           temp = xor(temp,1);
       end
       
       if(i == 1)
           min_llr = abs(llr(i));
           index = 1;
       else
           if(min_llr > abs(llr(i)))
               index = i;
               min_llr = abs(llr(i));
           end
       end
    end
    
    if(temp ~= 0)
        spcres(index) = xor(spcres(index),1);
    end

    