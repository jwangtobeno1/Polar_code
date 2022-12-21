#!/usr/bin/env python
# coding=utf-8
import numpy as np

inst = np.loadtxt("./inst.txt",dtype='str')
instnum = []
for i in range(len(inst)):
    tmp = int(inst[i],base = 2)
    instnum.append(tmp)
inst_arr = np.array(instnum)
np.savetxt("./inst2cpp.txt",inst_arr,fmt="%d")
