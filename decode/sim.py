#!/usr/bin/env python
# coding=utf-8
from random import randint
import numpy as np
llr_file = "./csrc/simfile/llr.txt"
f_file = "./csrc/simfile/f_res.txt"

# llr = []
# for i in range(9):
#     tmp = randint(0,2**32-1)
#     llr.append(tmp)
llr_str = ''
llr = []
f_str = ''
f = []
for i in range(800):    #8*3 per 8 can generate 96bit
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

