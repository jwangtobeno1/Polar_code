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

def spc():
    N = 16*100
    llr = genllr(N)
    llr_arr = np.array(llr[0])
    result = []
    tmp = 0
    tmp_str = ''
    for i in range(0,N,16):
        j = i
        tmp = 0
        min_llr = 32
        llr_abs = 0
        num_1 = 0
        for k in range(16):
            if llr_arr[j+k] >= 0:
                llr_abs = llr_arr[j+k]
                if llr_abs < min_llr:
                    min_llr = llr_abs
                    index = k
                tmp = tmp*2+0
            else:
                num_1 = num_1 + 1
                llr_abs = -llr_arr[j+k]
                if llr_abs < min_llr:
                    min_llr = llr_abs
                    index = k
                tmp = tmp*2+1
        tmp_str = '{:0>16b}'.format(tmp)
        if num_1%2 == 0:
            result.append(int(tmp_str,base=2))
        else:
            if index == 0:
                if tmp_str[0] == '0':
                    tmp_str = '1'+tmp_str[1:]
                else:
                    tmp_str = '0'+tmp_str[1:]
            else:
                if tmp_str[index] == '0':
                    tmp_str = tmp_str[0:index]+'1'+tmp_str[index+1:]
                else:
                    tmp_str = tmp_str[0:index]+'0'+tmp_str[index+1:]
            result.append(int(tmp_str,base=2))

        # print(f"llr_str is {llr[1][i:i+16]}\nllr_num is {llr[0][i:i+16]}\nresult is {tmp_str}")
        # print(f"num_1 is {num_1}\tmin_llr is {min_llr}\tindex is {index}\n")

    res_arr = np.array(result)
    np.savetxt(bit_file,res_arr,fmt="%d")


if __name__ == "__main__":
    spc()
