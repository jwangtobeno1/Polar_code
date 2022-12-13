#!/usr/bin/env python
# coding=utf-8
import numpy as np
from sim_func_fg import f,g
from sim_func_rate1 import rate1
from sim_func_rep import rep
from sim_func_spc import spc
from sim_func_type1 import type1
from sim_func_type3 import type3
from sim_bit_combine import bit_combine

polar_file = "/hdd/Projects/Polar_code/"
PUdin_file = polar_file+"decode/csrc/simfile/pfile_din.txt"
PUdout_file = polar_file+"decode/csrc/simfile/pfile_dout.txt"

result = []
# din = np.zeros(14)
# din = [llr(3),flag_fg(1),bit_in(1),inst(1),bit_comb_l(4),bit_comb_r(4)] 14 uint32
# dout = [llr_out(1),bit_out(1),bit_comb_out(4)] 6 uint64
din = np.array([],dtype='u4')
dout = np.array([],dtype='u8')
funcf = 0
funcg = 1
funcrep = 2
funcspc = 3
funcrate0 = 4
funcrate1 = 5
functype1 = 6
functype3 = 7
funcg0r = 9
funccomb = 10

N = 100
for i in range(N):
    tmp = f()
    din = np.hstack((din,tmp[0],0,funcf*16,  0,0,0,0,0,0,0,0))
    dout = np.hstack((dout,tmp[1],0, 0,0,0,0, 0,0,0,0))
    # print(f"din is {din}\ndout is {dout}")
    tmp = g()
    din = np.hstack((din,tmp[0],tmp[1],funcg*16,  0,0,0,0,0,0,0,0))
    dout = np.hstack((dout,tmp[2],0, 0,0,0,0, 0,0,0,0))
    print(tmp)
    # print(f"din is {din}\ndout is {dout}")
    tmp = rate1()
    din = np.hstack((din,tmp[0],0,funcrate1*16,  0,0,0,0,0,0,0,0))
    dout = np.hstack((dout,0,tmp[1], 0,0,0,0, 0,0,0,0))
    # print(f"din is {din}\ndout is {dout}")
    tmp = rep()
    din = np.hstack((din,tmp[0],0,funcrep*16,  0,0,0,0,0,0,0,0))
    dout = np.hstack((dout,0,tmp[1], 0,0,0,0, 0,0,0,0))
    # print(f"din is {din}\ndout is {dout}")
    tmp = spc()
    din = np.hstack((din,tmp[0],0,funcspc*16,  0,0,0,0,0,0,0,0))
    dout = np.hstack((dout,0,tmp[1], 0,0,0,0, 0,0,0,0))
    # print(f"din is {din}\ndout is {dout}")
    tmp = type1()
    din = np.hstack((din,tmp[0],0,functype1*16,  0,0,0,0,0,0,0,0))
    dout = np.hstack((dout,0,tmp[1], 0,0,0,0, 0,0,0,0))
    # print(f"din is {din}\ndout is {dout}")
    tmp = type3()
    din = np.hstack((din,tmp[0],0,functype3*16,  0,0,0,0,0,0,0,0))
    dout = np.hstack((dout,0,tmp[1], 0,0,0,0, 0,0,0,0))
    # print(f"din is {din}\ndout is {dout}")
    tmp = bit_combine()
    din = np.hstack((din,0,0,0,0,(funccomb*16+tmp[1]*2),tmp[0]))
    dout = np.hstack((dout,0,0,tmp[2]))
    print(tmp[1])

np.savetxt(PUdin_file,din,fmt="%d")
np.savetxt(PUdout_file,dout,fmt="%d")

