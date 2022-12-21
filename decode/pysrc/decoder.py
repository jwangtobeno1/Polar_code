#!/usr/bin/env python
# coding=utf-8
#!/usr/bin/env python
# coding=utf-8
import numpy as np

base_dir = "/hdd/Projects/Polar_code/decode/pysrc/"
load_file = base_dir + "u.txt"
source_file = base_dir + "u_source.txt"


def kronecker(mix_data):
    """x = u*G=u*F ： u - 信源，G - 生成矩阵"""
    F=np.matrix([[1,0],[1,1]])
    n = int(np.log2(mix_data.size))
    n_i=1
    G=F
    while n_i < n:
        G=np.kron(G,F)
        n_i+=1
    kron_result = mix_data@G # matrix multiplication
    return np.array(kron_result%2)

def bit_reversed(s):
    result = []
    N = len(s)
    for i in range(N):
        i_bin = format(i,'b').zfill(int(np.log2(N)))[::-1]
        result.append(s[int(i_bin,2)]) #list append array element
    return np.array(result)

def get_infopos(K,N):
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
    good_channel = sorted(pw_id[N-K:N])
    return np.array(good_channel)


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

def g_func(llr,b_arr):
    """
    g function: (1-2b)llr_a+llr_b
    input : 16 llr and 8 bits
    output: 8  llr
    """
    dout = []
    b = bit_reversed(b_arr)
    for i in range(0,len(llr),2):
        j = int(i/2)
        temp = llr[i+1]+(1-2*b[j])*llr[i]
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
    length=b_l.size
    temp=np.array([(b_l+b_r)%2,b_r])
    temp.resize((1,2*length))
    return temp[0]

def bit_combine_0r(b_r):
    l = b_r.size
    b_l = np.zeros(l)
    return bit_combine(b_l,b_r)

def func_rate1(llr_arr):
    """
    function rate1: all bits are information bit
    input : 16 llr array
    output: 16 bit array
    """
    llr = bit_reversed(llr_arr)
    bit = []
    for i in range(len(llr)):
        if llr[i] >= 0:
            bit.append(0)
        else:
            bit.append(1)
    return np.array(bit)

def func_type1(llr_arr):
    """
    function type1: U_N-1 and U_n are information bit
    input : 16 llr array
    output: 16 bit array
    """
    llr = bit_reversed(llr_arr)
    t = np.reshape(llr,(2,4),order = 'F')
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
    return np.array(dout)

def func_type3(llr_arr):
    """
    function type3 : U_0 and U_1 are frozen bit, others are information bit
    input : 16 llr array
    output: 16 bit array
    """
    llr = bit_reversed(llr_arr)
    t = np.reshape(llr,(2,4),order = 'F')
    res1 = func_spc(t[0],0)
    res2 = func_spc(t[1],0)
    res = np.vstack((res1,res2))
    dout = np.reshape(res,(1,8),order = 'F')
    return dout[0]

def extract_u(u_d,info_pos):
    l = info_pos.size
    u = np.zeros((l),dtype=np.int8)
    for i in range(l):
        u[i] = u_d[info_pos[i]]
    return u

def decode_256(llr):
    l128l = f_func(llr)
    l64l = f_func(l128l)
    l32r = g_0r(l64l)
    l16r = g_0r(l32r)
    l8l = f_func(l16r)
    b8l = func_rep(l8l)
    l8r = g_func(l16r,b8l)
    l4l = f_func(l8r)
    b4l = func_rep(l4l)
    l4r = g_func(l8r,b4l) #10
    b4r = func_spc(l4r)
    b8r = bit_combine(b4l,b4r)
    b16r = bit_combine(b8l,b8r)
    b32r = bit_combine_0r(b16r)
    b64l = bit_combine_0r(b32r)
    # print(f"b8l:\t{b8l}\nb4r:\t{b4r}\nb8r:\t{b8r}\nb16r:\t{b16r}\nb32r:\t{b32r}\nb64l:\t{b64l}\n")
    l64r = g_func(l128l,b64l)#16
    l32l = f_func(l64r)
    l16l = f_func(l32l)
    b16l = func_rep(l16l)
    l16r = g_func(l32l,b16l)
    l8l = f_func(l16r)
    b8l = func_rep(l8l)
    l8r = g_func(l16r,b8l) #23
    l4l = f_func(l8r)
    b4l = func_rep(l4l)
    l4r = g_func(l8r,b4l)
    b4r = func_spc(l4r)
    b8r = bit_combine(b4l,b4r)
    b16r= bit_combine(b8l,b8r)
    b32l= bit_combine(b16l,b16r)
    # print(f"b16l:\t{b16l}\nb8l:\t{b8l}\nb4l:\t{b4l}\nb4r:\t{b4r}\nb8r:\t{b8r}\nb16r:\t{b16r}\nb32l:\t{b32l}\n")
    l32r = g_func(l64r,b32l)
    l16l = f_func(l32r) #32
    l8l = f_func(l16l)
    b8l = func_rep(l8l)
    l8r = g_func(l16l,b8l)
    b8r = func_type3(l8r)
    b16l = bit_combine(b8l,b8r)
    l16r = g_func(l32r,b16l)
    b16r = func_spc(l16r)
    b32r = bit_combine(b16l,b16r)
    b64r = bit_combine(b32l,b32r)
    b128l = bit_combine(b64l,b64r)#42
    # print(f"b8l:\t{b8l}\nb8r:\t{b8r}\nb16l:\t{b16l}\nb16r:\t{b16r}\nb32r:\t{b32r}\nb64r:\t{b64r}\n")
    
    l128r = g_func(llr,b128l)
    l64l = f_func(l128r)
    l32l = f_func(l64l)
    l16l = f_func(l32l)
    b16l = func_rep(l16l)
    l16r = g_func(l32l,b16l)
    l8l = f_func(l16r)
    b8l = func_type1(l8l)
    l8r = g_func(l16r,b8l)
    b8r = func_spc(l8r)
    b16r = bit_combine(b8l,b8r)
    b32l = bit_combine(b16l,b16r)#54
    # print(f"b16l:\t{b16l}\nb8l:\t{b8l}\nb8r:\t{b8r}\nb16r:\t{b16r}\nb32l:\t{b32l}\n")
    l32r = g_func(l64l,b32l)
    l16l = f_func(l32r)
    l8l = f_func(l16l)
    l4l = f_func(l8l)
    b4l = func_rep(l4l)
    l4r = g_func(l8l,b4l)
    b4r = func_spc(l4r)
    b8l = bit_combine(b4l,b4r)
    l8r = g_func(l16l,b8l)
    b8r = func_spc(l8r)
    b16l = bit_combine(b8l,b8r)
    l16r = g_func(l32r,b16l)
    b16r = func_spc(l16r)
    b32r = bit_combine(b16l,b16r)
    b64l = bit_combine(b32l,b32r)#69
    # print(f"b4l:\t{b4l}\nb4r:\t{b4r}\nb8l:\t{b8l}\nb8r:\t{b8r}\nb16l:\t{b16l}\nb16r:\t{b16r}\nb32r:\t{b32r}\nb64l:\t{b64l}\n")
    l64r = g_func(l128r,b64l)
    l32l = f_func(l64r)
    l16l = f_func(l32l)
    l8l = f_func(l16l)
    l4l = f_func(l8l)
    b4l = func_rep(l4l)
    l4r = g_func(l8l,b4l)
    b4r = func_spc(l4r)
    b8l = bit_combine(b4l,b4r)
    l8r = g_func(l16l,b8l)
    b8r = func_spc(l8r)
    b16l = bit_combine(b8l,b8r)
    l16r = g_func(l32l,b16l)
    b16r = func_rate1(l16r)
    b32l = bit_combine(b16l,b16r)
    # print(f"b4l:\t{b4l}\nb4r:\t{b4r}\nb8l:\t{b8l}\nb8r:\t{b8r}\nb16l:\t{b16l}\nb16r:\t{b16r}\nb32l:\t{b32l}\n")
    l32r = g_func(l64r,b32l)
    b32r = func_rate1(l32r)
    b64r = bit_combine(b32l,b32r)
    b128r = bit_combine(b64l,b64r)
    b256 = bit_combine(b128l,b128r)
    b256_int = list(map(int,b256))
    b256_str = list(map(str,b256_int))
    b256_hex = hex(int(''.join(b256_str),base = 2))
    print(b256_hex)
    # print(f"b32r:\t{b32r}\nb64r:\t{b64r}\nb128r:\t{b128r}\nb256:\t{b256}\n")
    return b256


if __name__ == "__main__":

    K = 128
    N = 256

    llr_arr = np.loadtxt("/hdd/Projects/Polar_code/decode/pysrc/llr.txt")#("/hdd/sambaFiles/llr.txt")
    llr = bit_reversed(llr_arr)
    b256 = decode_256(llr)
    u_d = kronecker(b256)
    info_pos = get_infopos(K,N)
    u = extract_u(u_d[0],info_pos)
    u_load = np.loadtxt(load_file)
    u_source = np.loadtxt(source_file)
    error_num = int(np.sum((u_load + u) % 2))
    real_error_num = int(np.sum((u+u_source) %2))
    # print(f"u_load is {u_load}")
    # print(f"u_d:{u_d}\nu  :{u}\nerror : {error_num}\nreal_error: {real_error_num}")
    print(f"My : error_compare_his : {error_num}, error_my_func : {real_error_num}")
    with open(base_dir + "test_result.txt",'a') as file_obj:
        if real_error_num != 0:
            file_obj.write(f"Failed!! error num is:{error_num}  real error num is {real_error_num}\nllr is {llr}\nu is \t{u}\nu_load is \t{u_load}\nu_realsource is \t{u_source}\n")
        else:
            file_obj.write(f"error num is:{error_num}\treal error num is {real_error_num}\n")

