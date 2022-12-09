#!/usr/bin/env python
# coding=utf-8
from random import randint
import numpy as np
llr_file = "./csrc/simfile/llr.txt"
f_file = "./csrc/simfile/f_res.txt"
g_file = "./csrc/simfile/g_res.txt"
g_bit_file = "./csrc/simfile/g_bit.txt"

# llr = []
# for i in range(9):
#     tmp = randint(0,2**32-1)
#     llr.append(tmp)

def f():
    llr_str = ''
    llr = []
    f_str = ''
    f = []
    N = 80
    for i in range(N):    #8*3 per 8 can generate 96bit
        llr_up = randint(0,2**6-1)
        llr_down = randint(0,2**6-1)
        llr_up_str = '{:0>6b}'.format(llr_up)
        llr_down_str = '{:0>6b}'.format(llr_down)
        if llr_up >= 32:
            llr_up = llr_up - 64
        if llr_down >= 32:
            llr_down = llr_down -64
        min_abs = min(abs(llr_up),abs(llr_down))
        if (llr_up *llr_down)>=0:
            min_llr = min_abs
            f_res = '{:0>6b}'.format(min_llr)
        else:
            min_llr = -min_abs
            f_res = bin(min_llr % (1<<6))[2:]
        print(f"llr_up is {llr_up_str}\nllr_down is {llr_down_str}\nf_res is {f_res}")

        f_str = f_str + f_res
        if len(f_str) >= 48:
            f.append(int(f_str[0:48],base=2))
            f_str = f_str[48:]
        llr_str = llr_str + llr_up_str + llr_down_str
        if len(llr_str) >= 32:
            llr.append(int(llr_str[0:32],base=2))
            llr_str = llr_str[32:]

    llr_arr = np.array(llr)
    f_arr = np.array(f)
    print(llr_arr)
    print(f_arr)
    np.savetxt(llr_file,llr_arr,fmt="%d")
    np.savetxt(f_file,f_arr,fmt="%d")

def g():
    g_str = ''
    g = []
    llr_str = ''
    llr = []
    bit_list = []
    N = 80 #8 * i = N; i
    bit = 0
    for i in range(N):    # per 8 can generate 96bit
        bit_tmp = randint(0,1)
        llr_up = randint(0,2**6-1)
        llr_down = randint(0,2**6-1)
        llr_up_str = '{:0>6b}'.format(llr_up)
        llr_down_str = '{:0>6b}'.format(llr_down)
        if llr_up >= 32:
            llr_up = llr_up - 64
        if llr_down >= 32:
            llr_down = llr_down -64
        if bit_tmp == 0:
            g_res = llr_down + llr_up
        else:
            g_res = llr_down - llr_up

        if g_res >= 32:
             g_res = 31 #01_1111
        elif g_res <= -32:
             g_res = 32 #10_0000 
        if g_res >= 0:
            g_res_str = '{:0>6b}'.format(g_res)
        else:
            g_res_str = bin(g_res % (1<<7))[3:]

        # print(f"llr_up is {llr_up_str}\tllr_down is {llr_down_str}\nbit is {bit_tmp}\tg_res is {g_res_str}\n")

        bit = bit*2+bit_tmp;
        if (i+1)%8 == 0:
            bit_list.append(bit)
            bit = 0
        g_str = g_str + g_res_str
        if len(g_str) >= 48:
            g.append(int(g_str[0:48],base=2))
            g_str = g_str[48:]
        llr_str = llr_str + llr_up_str + llr_down_str
        if len(llr_str) >= 32:
            llr.append(int(llr_str[0:32],base=2))
            llr_str = llr_str[32:]

    llr_arr = np.array(llr)
    g_arr = np.array(g)
    bit_arr = np.array(bit_list)
    # print(f"bit_arr is\t{bit_arr}")
    # print(f"llr_arr is\t{llr_arr}")
    # print(f"g_arr is\t{g_arr}")
    np.savetxt(llr_file,llr_arr,fmt="%d")
    np.savetxt(g_bit_file,bit_arr,fmt="%1d")
    np.savetxt(g_file,g_arr,fmt="%d")

if __name__ == "__main__":
    f()
