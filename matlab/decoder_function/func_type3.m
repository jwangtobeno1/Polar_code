function type3res = func_type3(llr_arr)

    llr = bit_reversed(llr_arr);
    t = reshape(llr,[2,4]);
    res1 = func_spc(t(1,:),0);
    res2 = func_spc(t(2,:),0);
    res = [res1;res2];
    type3res = reshape(res,[1,8]);