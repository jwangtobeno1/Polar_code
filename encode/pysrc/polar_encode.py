#!/usr/bin/env python
# coding=utf-8
from random import randint
import numpy as np

source_file = 'source_arr.txt'
encoude_result_file = 'polar_encode_result_arr.txt'
filename = 'encode_example.txt'

#s = [] #source
source_arr = np.array([])
K = 128 #信源长度
R = 0.5 #码率
N = int(K/R) #码长256

def load_source():
    """load source from source_file"""
    # with open(source_file,'r') as f_obj:
    #     source = f_obj.read()
    #     source = list(map(int,source[:-1]))
    s_arr = np.loadtxt(source_file)
    return s_arr

    

def gen_source(s_arr,K = 128):
    """随机生成长度为N的信源，并将其16进制输出"""
    if(len(s_arr) == 0):
        u = [randint(0,1) for i in range(K)]  #信源
        u_arr = np.array(u)
        s_arr = u_arr
    else:
        u_arr = s_arr
    np.savetxt(source_file,u_arr,fmt = '%d')
    u_str = list(map(str,u_arr))
    u_hex = []
    for i in range(0,K,4):
        h = hex(int((''.join(u_str[i:i+4])),2))
        u_hex.append(h[-1])
    u_hex = ''.join(u_hex)
    with open(filename,'a') as file_obj:
        file_obj.write(f"\nsource: {''.join(u_str)}\nhex: {str(u_hex)}\n")
   
def construction_polar_code():
    """极化权重进行可靠性检测"""
    pw = []
    beta = 2**0.25
    for i in range(0,N):#码长为N
        num = format(i,'b')
        length = len(num)
        value = 0
        for i in range(0,length):
            value = value+int(num[i-(2*i+1)])*(beta**(i))
        pw.append(value)

    pw_id  = sorted(range(len(pw)),key=lambda k:pw[k])
    return pw_id

def bit_mix(s,good_channels):
    """比特混合，将信源插入到可靠信道，其余信道为冻结bit 0"""
    mix_data = [0 for i in range(N)]
    j = 0
    for i in range(K):
        mix_data[good_channels[i]] = 1
    
    for i in range(N):
        if(mix_data[i] == 1):
            mix_data[i] = s[j]
            j = j + 1
    return mix_data

def kronecker(mix_data):
    """x = u*G=u*F ： u - 信源，G - 生成矩阵"""
    mix_data = np.array(mix_data)
    F = np.array([(1,0),(1,1)])
    result = np.kron(F,F)
    for i in range(int(np.log2(K))-1):
        result = np.kron(result,F)

    kron_result = mix_data@result  # matrix multiplication
    return kron_result%2
        
def bit_reversed(s):
    result = []
    for i in range(N):
        i_bin = format(i,'b').zfill(int(np.log2(N)))[::-1]
        result.append(s[int(i_bin,2)]) #list append array element
    return result

def polar_encode(s_arr,K,N):
    pw_id = construction_polar_code()
    mix_data = bit_mix(s_arr,pw_id[K:N])
    kron_result_arr = kronecker(mix_data[:])
    bit_reverse_result = bit_reversed(kron_result_arr)
    polar_int = list(map(int,bit_reverse_result))
    polar_arr = np.array(polar_int)
    np.savetxt(encoude_result_file,polar_arr,fmt = '%d')
    polar_str = list(map(str,polar_int))
    polar_hex = []
    for i in range(0,N,4):
        h = hex(int((''.join(polar_str[i:i+4])),2))
        polar_hex.append(h[-1])
    polar_hex = ''.join(polar_hex)
    polar_encode_result = ''.join(polar_str)

    with open(filename,'a') as file_obj:
        file_obj.write(f"polar_encode: {polar_encode_result}\npolar_encode_hex: {polar_hex}\n")
    
if __name__ == '__main__':
    source_arr = load_source()
    print(f"len is:{len(source_arr)}")
    if len(source_arr) == 0:
        gen_source(source_arr,K)
    polar_encode(source_arr,K,N)

