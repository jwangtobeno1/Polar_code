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
    '''
    generate N 6bit llr
    '''
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
    # np.savetxt(llr_file,llr_arr,fmt="%d")
    llr = [llr_num_list,llr_str_tmp_list]
    return [llr,llr_arr]

def func_spc(llr_arr,flag = 1):
    """
    SPC function: only U_1 is frozen bit
    input : 16 llr or 8 llr
    output: 16 bit or 8 bit
    """
    bit = []
    temp = 0
    j = 0
    if flag == 1:
        llr = bit_reversed(llr_arr)
    else:
        llr = llr_arr
    for i in range(len(llr)):
        if llr[i] >= 0:
            bit.append(0)
            temp = temp^0
        else:
            bit.append(1)
            temp = temp^1
        if i == 0:
            min_llr = np.abs(llr[i])
        else:
            if min_llr > np.abs(llr[i]):
                j = i
                min_llr = np.abs(llr[i])
    if temp != 0:
        if bit[j] == 0:
            bit[j] = 1
        else:
            bit[j] = 0
    return np.array(bit)

def type3(N=16):
    llr = genllr(N)
    llr_arr = np.array(llr[0][0])
    result = []
    tmp_str = ''
    for i in range(0,N,16):
        t = np.reshape(llr_arr[i:i+8],(2,4),order = 'F')
        res1 = func_spc(t[0],0)
        res2 = func_spc(t[1],0)
        res = np.vstack((res1,res2))
        dout_tmp = np.reshape(res,(1,8),order = 'F')
        dout = dout_tmp[0]
        dout_num = int(dout[0])*128+int(dout[1])*64+int(dout[2])*32+int(dout[3])*16+int(dout[4])*8+int(dout[5])*4+int(dout[6])*2+int(dout[7])
        result.append(dout_num)
        tmp_str = '{:0>8b}'.format(dout_num)

        # print(f"llr_str is {llr[1][i:i+16]}\nllr_num is {llr[0][i:i+16]}")
        # print(f"res1 is {res1}\tres2 is {res2}\tresult is {tmp_str}")

    res_arr = np.array(result)
    print(f"type3 result is {res_arr}")
    return [llr[1],res_arr]
    # np.savetxt(process_file,res_arr,fmt="%d")


if __name__ == "__main__":
    N = 16*100
    type3(N)
