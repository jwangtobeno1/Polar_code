#!/usr/bin/env python
# coding=utf-8
from random import randint
import numpy as np
polar_file = "/hdd/Projects/Polar_code/"
llr_file = polar_file + "decode/csrc/simfile/llr.txt"
# f_file = polar_file + "decode/csrc/simfile/f_res.txt"
# g_file = polar_file + "decode/csrc/simfile/g_res.txt"
bit_file = polar_file + "decode/csrc/simfile/bitout.txt"

def genllr(N):
    llr_str = ''
    llr_str_list = []
    llr_str_tmp_list = []
    llr_num_list = []
    for i in range(N):
        llr_tmp = randint(0,2**6-1)
        if llr_tmp >= 0 and llr_tmp < 32:
            llr_str_tmp = '{:0>6b}'.format(llr_tmp)
        else:
            llr_tmp = llr_tmp - 64
            llr_str_tmp = bin(llr_tmp % (1 << 7))[3:]
        llr_str_tmp_list.append(llr_str_tmp)
        llr_str = llr_str + llr_str_tmp
        if len(llr_str) >= 32:
            llr_str_list.append(int(llr_str[0:32],base=2))
            llr_str = llr_str[32:]
        llr_num_list.append(llr_tmp)
    llr_arr = np.array(llr_str_list)
    np.savetxt(llr_file,llr_arr,fmt="%d")
    llr = [llr_num_list,llr_str_tmp_list]
    return llr

def rep():
    N = 16*100
    llr = genllr(N)
    llr_arr = np.array(llr[0])
    result = []
    for i in range(0,N,16):
        llr_sum = np.sum(llr_arr[i:i+16])
        if llr_sum >= 0:
            tmp = 0;
            result.append(tmp);
        else:
            tmp = 65535
            result.append(tmp);#2**16-1
        # print(f"llr_str is {llr[1][i:i+16]}\nllr_num is {llr[0][i:i+16]}\nllr_sum is {llr_sum}\nresult is {tmp}")

    res_arr = np.array(result)
    np.savetxt(bit_file,res_arr,fmt="%d")



if __name__ == "__main__":
    rep()
