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

def type1():
    N = 16*100
    llr = genllr(N)
    llr_arr = np.array(llr[0])
    result = []
    tmp_str = ''
    for i in range(0,N,16):
        t = np.reshape(llr_arr[i:i+8],(2,4),order = 'F')
        sum1 = np.sum(t[0])
        sum2 = np.sum(t[1])
        if sum1 >= 0:
            b1 = 0
        else:
            b1 = 1
        if sum2 >= 0:
            b2 = 0
        else:
            b2 = 1
        dout = [b1,b2]*4
        dout_num = int(dout[0])*128+int(dout[1])*64+int(dout[2])*32+int(dout[3])*16+int(dout[4])*8+int(dout[5])*4+int(dout[6])*2+int(dout[7])
        result.append(dout_num)
        tmp_str = '{:0>8b}'.format(dout_num)

        print(f"llr_str is {llr[1][i:i+16]}\nllr_num is {llr[0][i:i+16]}\nresult is {tmp_str}")
        print(f"sum1 is {sum1}\tsum2 is {sum2}")

    res_arr = np.array(result)
    np.savetxt(bit_file,res_arr,fmt="%d")


if __name__ == "__main__":
    type1()
