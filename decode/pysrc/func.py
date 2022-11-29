#!/usr/bin/env python
# coding=utf-8
import numpy as np

def f_func(llr):
    """
    f function:
    input : 16 LLR array
    output: 8  LLR array
    """
    dout = []
    for i in range(0,len(llr),2):
        temp = np.sign(llr[i])*np.sign(llr[i+1])*np.min([np.abs(llr[i]),np.abs(llr[i+1])])
        dout.append(temp)
    dout_arr = np.array(dout)
    return dout_arr

def g_func(llr,b):
    """
    g function: (1-2b)llr_a+llr_b
    input : 16 llr and 8 bits
    output: 8  llr
    """
    dout = []
    for i in range(0,len(llr),2):
        temp = llr[i+1]+(1-2*b[int(i/2)])*llr[i]
        dout.append(temp)
    dout_arr = np.array(dout)
    return dout_arr

def g_0r(llr):
    """
    g_0r: left is Rate-0 and right g function
    input : 16 llr
    output: 8  llr
    """
    return g_func(llr,[0]*int(len(llr)/2))

def func_rep(llr):
    """
    REP function: only U_N is frozen bit
    input : 16 llr
    output: 16 bit
    """
    temp = 0
    l = len(llr)
    for i in range(l):
        temp = temp + llr[i]
    if temp >= 0:
        dout = [0]*l
    else:
        dout = [1]*l
    return np.array(dout)

def func_spc(llr):
    """
    SPC function: only U_1 is frozen bit
    input : 16 llr or 8 llr
    output: 16 bit or 8 bit
    """
    bit = []
    temp = 0
    j = 0
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

def bit_combine(b_l,b_r,stage=0):
    """
    bit combine :
    input : 
        b_l max 128-bit array left child; 
        b_r max 128-bit array right child;
        stage :
            8 => 128 and 128 combine
            7 => 64  and 64 combine
            ...
            1 => 2 and 2 combine
    """
    arr_up = np.bitwise_xor(b_l,b_r)
    arr_down = b_r
    res = np.vstack((arr_up,arr_down))
    dout = np.reshape(res,(1,2*len(b_l)),order = 'F')
    return dout[0]

def func_rate1(llr):
    """
    function rate1: all bits are information bit
    input : 16 llr array
    output: 16 bit array
    """
    bit = []
    for i in range(len(llr)):
        if llr[i] >= 0:
            bit.append(0)
        else:
            bit.append(1)
    return np.array(bit)

def func_type1(llr):
    """
    function type1: U_N-1 and U_n are information bit
    input : 16 llr array
    output: 16 bit array
    """
    t = np.reshape(llr,(2,8),order = 'F')
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
    dout = [0]*14+[b2,b1]
    return np.array(dout)

def func_type3(llr):
    """
    function type3 : U_0 and U_1 are frozen bit, others are information bit
    input : 16 llr array
    output: 16 bit array
    """
    t = np.reshape(llr,(2,8),order = 'F')
    res1 = func_spc(t[0])
    res2 = func_spc(t[1])
    res = np.vstack((res1,res2))
    dout = np.reshape(res,(1,16),order = 'F')
    return dout[0]

def bit_reversed(s):
    result = []
    N = len(s)
    for i in range(N):
        i_bin = format(i,'b').zfill(int(np.log2(N)))[::-1]
        result.append(s[int(i_bin,2)]) #list append array element
    return np.array(result)


if __name__ == "__main__":
    llr_arr = np.loadtxt("/hdd/sambaFiles/llr.txt")
    # llr = bit_reversed(llr_arr)
    print(llr_arr)
    res1 = f_func(llr_arr)
    res2 = g_0r(res1)
    res3 = f_func(res2)
    b4l = func_rep(res3)
    res5 = g_func(res2,b4l)
    b4r = func_spc(res5)
    b8r = bit_combine(b4l,b4r)
    b16l = bit_combine([0]*8,b8r)
    res1 = g_func(llr_arr,b16l)
    res2 = f_func(res1)
    res3 = f_func(res2)
    b4l = func_rep(res3)
    res4 = g_func(res2,b4l)
    b4r = func_spc(res4)
    b8l = bit_combine(b4l,b4r)
    res5 = g_func(res1,b8l)
    b8r = func_rate1(res5)
    b16r = bit_combine(b8l,b8r)
    b32 = bit_combine(b16l,b16r)
    dout = bit_reversed(b32)
    # b1 = [0,1,1,1]
    # b2 = [1,1,0,0]
    # b1_arr = np.array(b1)
    # b2_arr = np.array(b2)
    # dout =bit_combine(b1,b2,0)
    print(b32)
    print(dout)

