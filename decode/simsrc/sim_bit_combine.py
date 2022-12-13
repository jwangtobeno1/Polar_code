#!/usr/bin/env python
# coding=utf-8
import numpy as np
from random import randint
polar_file = "/hdd/Projects/Polar_code/"
bit_file = polar_file + "decode/csrc/simfile/bitout.txt"

def bit_combine(N=1):
    result = []
    for i in range(N):
        key = randint(2,7)
        K = 2**key
        w = 2**K
        stage = key-2
        lval = np.zeros(4)
        rval = np.zeros(4)
        leftvalue = randint(0,w-1)
        rightvalue = randint(0,w-1)
        # print(f'left valus is {leftvalue}\tright is {rightvalue}')

        lval[0] = (leftvalue>>96)#first 32 bit
        lval[1] = (leftvalue>>64) & (2**32-1)
        lval[2] = (leftvalue>>32) & (2**32-1)
        lval[3] = leftvalue & (2**32-1)#last 32-bit

        rval[0] = (rightvalue>>96)
        rval[1] = (rightvalue>>64) & (2**32-1)
        rval[2] = (rightvalue>>32) & (2**32-1)
        rval[3] = rightvalue & (2**32-1)

        result.append(lval[0])
        result.append(lval[1])
        result.append(lval[2])
        result.append(lval[3])
        result.append(rval[0])
        result.append(rval[1])
        result.append(rval[2])
        result.append(rval[3])

        leftbit = np.binary_repr(leftvalue,width = K)
        rightbit = np.binary_repr(rightvalue,width = K)
        l_list = list(map(int,list(leftbit)))
        r_list = list(map(int,list(rightbit)))
        b_l = np.array(l_list)
        b_r = np.array(r_list)
        # print(b_l)
        # print(b_r)
        tmp=np.array([(b_l+b_r)%2,b_r])
        tmp.resize((1,2*K))

        tmplist = tmp[0].tolist()

        tval = int("".join(str(x) for x in tmplist), 2)

        tval_arr = np.zeros(8,dtype='u4')
        tval_arr[0] = (tval>>224) & (2**32-1)
        tval_arr[1] = (tval>>192) & (2**32-1)
        tval_arr[2] = (tval>>160) & (2**32-1)
        tval_arr[3] = (tval>>128) & (2**32-1)
        tval_arr[4] = (tval>>96) & (2**32-1)
        tval_arr[5] = (tval>>64) & (2**32-1)
        tval_arr[6] = (tval>>32) & (2**32-1)
        tval_arr[7] = (tval) & (2**32-1)
        # print(tval_arr)
        # result.append(tval)
        # print(f"l is {lval}\nr is {rval}\nstage is {stage}\n tval is {'{:x}'.format(tval)}\n")
        print(f"tval is {'{:x}'.format(tval)}")

        res_arr = np.array(result,dtype='u4')

        return [res_arr,stage,tval_arr]


# np.savetxt(bit_file,res_arr,fmt="%u")


