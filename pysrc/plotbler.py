import matplotlib.pyplot as plt

def plotfig(SNR_list,BER_list,BLER_list):
    plt.semilogy(SNR_list,BER_list, linewidth=1,label='BER', linestyle='-',c='b')
    plt.semilogy(SNR_list,BLER_list, linewidth=1,label='BLER', linestyle='--',c='b')
    plt.legend()
    plt.grid()
    
    plt.title('BER', fontsize=15)
    plt.xlabel('SNR(dB)', fontsize=14)
    plt.ylabel('BER/BLER', fontsize=14)
    plt.tick_params(axis='x', labelsize=10)
    plt.tick_params(axis='y', labelsize=10, width=2)
    plt.show()
    # x = range(0, 10, 1)
    # y = range(0, 12, 1)
    # plt.xticks(x)
    # plt.yticks(y)

def plotfig2(SNR_list,BER_list1,BER_list2,BLER_list1,BLER_list2):
    plt.semilogy(SNR_list,BER_list1, linewidth=1,label='BER_FSC_Regular', linestyle='-',marker='o',c='b')
    plt.semilogy(SNR_list,BLER_list1, linewidth=1,label='BLER_FSC_Regular', linestyle='--',marker='*',c='b')
    plt.semilogy(SNR_list,BER_list2, linewidth=1,label='Fast-SSC-Type', linestyle='-',marker='D',c='r')
    plt.semilogy(SNR_list,BLER_list2, linewidth=1,label='Fast-SSC-Type', linestyle='--',marker='p',c='r')
    plt.legend()
    plt.grid()
    
    # plt.title('BER', fontsize=15)
    plt.xlabel('SNR(dB)', fontsize=14)
    plt.ylabel('BER/BLER', fontsize=14)
    plt.tick_params(axis='x', labelsize=10)
    plt.tick_params(axis='y', labelsize=10, width=2)
    plt.show()

def plotfig3(SNR_list,BER_list1,BER_list2,BER_list3,BLER_list1,BLER_list2,BLER_list3):
    plt.semilogy(SNR_list,BER_list2, linewidth=1,label='BER_SC', linestyle='-',c='r')
    plt.semilogy(SNR_list,BLER_list2, linewidth=1,label='BLER_SC', linestyle='--',marker='p',c='r')
    plt.semilogy(SNR_list,BER_list1, linewidth=1,label='BER_FSC_Regular', linestyle='-',c='b')
    plt.semilogy(SNR_list,BLER_list1, linewidth=1,label='BLER_FSC_Regular', linestyle='--',marker='*',c='b')
    plt.semilogy(SNR_list,BER_list3, linewidth=1,label='BER_FSC_Type', linestyle='-',c='g')
    plt.semilogy(SNR_list,BLER_list3, linewidth=1,label='BLER_FSC_Type', linestyle='--',marker='D',c='g')
    plt.legend()
    plt.grid()
    
    # plt.title('BER', fontsize=15)
    plt.xlabel('SNR(dB)', fontsize=14)
    plt.ylabel('BER/BLER', fontsize=14)
    plt.tick_params(axis='x', labelsize=10)
    plt.tick_params(axis='y', labelsize=10, width=2)
    plt.show()

if __name__ == "__main__":
    # SNR = [0.5,1,1.5,2,2.5,3,3.5,4,4.5,5]
    # # CA-SCL list = 8, CRC = 8
    # # BER2 = [0.311264,0.118332,0.025444,0.003435,0.000696,0.00008,0.00001,0.0000002,0.00000001,0.0000000001]
    # # BLER2 = [0.7648,0.3272,0.069,0.0082,0.0016,0.0002,0.00005,0.000008,0.000001,0.00000005]
    # # Fast-SSC-regular
    # BER1 = [0.387944,0.237732,0.081531,0.015852,0.001992,0.000227,0.000012,0.00000021,0.00000002,0.0000000001]
    # BLER1 = [0.9524,0.719,0.3194,0.079,0.0146,0.0024,0.0002,0.00001,0.000001,0.00000005]
    # # Fast-SSC-Type
    # BER3 = [0.381695,0.234774,0.083861,0.016553,0.002439,0.000156,0.000011,0.00000021,0.00000002,0.0000000001]
    # BLER3 = [0.944,0.7138,0.3292,0.0808,0.0152,0.0022,0.0004,0.00001,0.000001,0.00000005]
    # plotfig2(SNR,BER1,BER3,BLER1,BLER3)

    # SNR = [0.5,1,1.5,2,2.5,3,3.5]
    # # CA-SCL list = 8, CRC = 8
    # BER2 = [0.311264,0.118332,0.025444,0.003435,0.000696,0.00008,0.000001]
    # BLER2 = [0.7648,0.3272,0.069,0.0082,0.0016,0.0002,0.0001]
    # # Fast-SSC-regular
    # BER1 = [0.387944,0.237732,0.081531,0.015852,0.001992,0.000227,0.000003]
    # BLER1 = [0.9524,0.719,0.3194,0.079,0.0146,0.0024,0.0002]
    # # Fast-SSC-Type
    # BER3 = [0.381695,0.234774,0.083861,0.016553,0.002439,0.000156,0.000031]
    # BLER3 = [0.944,0.7138,0.3292,0.0808,0.0152,0.0022,0.0004]
    # plotfig3(SNR,BER1,BER2,BER3,BLER1,BLER2,BLER3)

    # SNR = [0.5,1,1.5,2,2.5,3,3.5]
    # # CA-SCL list = 8, CRC = 8
    # BER2 = [0.311264,0.118332,0.025444,0.003435,0.000696,0.00008,0.000001]
    # BLER2 = [0.7648,0.5696,0.3415,0.166,0.00742,0.00365,0.00234]
    # # Fast-SSC-regular
    # BER1 = [0.387944,0.237732,0.081531,0.015852,0.001992,0.000227,0.000003]
    # BLER1 = [0.9524,0.719,0.3194,0.079,0.0146,0.0024,0.0002]
    # # Fast-SSC-Type
    # BER3 = [0.381695,0.234774,0.083861,0.016553,0.002439,0.000156,0.000031]
    # BLER3 = [0.944,0.7138,0.3292,0.0808,0.0152,0.0022,0.0004]
    # plotfig3(SNR,BER1,BER2,BER3,BLER1,BLER2,BLER3)

    
    # SNR = [0.5,1,1.5,2,2.5,3,3.5,4,4.5]
    # # Fast-SSC-regular
    # BER1 = [0.260079,0.167201,0.086439,0.035812,0.010223,0.002382,0.000262,0.000153,0.000025]
    # BLER1 = [0.7456,0.5262,0.295,0.1342,0.0464,0.0114,0.0022,0.001,0.0002]
    # # Fast-SSC-Type
    # BER3 = [0.260965,0.169426,0.088857,0.033742,0.011182,0.002217,0.000715,0.000239,0.00000625]
    # BLER3 = [0.7448,0.5262,0.2972,0.1324,0.0456,0.0013,0.0004,0.0012,0.0002]
    # plotfig2(SNR,BER1,BER3,BLER1,BLER3)

    """(256,128), 5000次 Fast-SSC对比"""
    # SNR = [2,2.12,2.25,2.38,2.5,2.62,2.75,2.88,3,3.12,3.25,3.38,3.5,3.62,3.75,3.88,4]
    # # Fast-SSC-regular
    # BER1 = [0.033403125,0.026515625,0.019895313,0.015232813,0.009885938,0.007292188,0.004798438, 0.004128125,0.003760938, \
    # 0.001678125,0.00096875,0.00033125,0.00048125,0.000392188,0.000245313,7.19E-05,0.00024375]
    # BLER1 = [0.1298,0.1032,0.0776,0.0608,0.042,0.0336,0.0216,0.0186,0.0158,0.0084,0.0052,0.003, \
    # 0.0026,0.002,0.0022,0.0012,0.0008]
    # # Fast-SSC-Type
    # BER3 = [0.0357875,0.026784375,0.019454688,0.013757813,0.0112375,0.007945313,0.005123438,0.00355625, \
    # 0.00303125,0.001795313,0.001107813,0.000565625,0.000396875,0.0001125,0.000165625,0.00019375,2.81E-05]
    # BLER3 = [0.1342,0.1058,0.0792,0.0578,0.0492,0.0354,0.0244,0.015,0.0164,0.0082,0.0062,0.004, \
    # 0.0028,0.0012,0.0012,0.0008,0.0004]
    # plotfig2(SNR,BER1,BER3,BLER1,BLER3)

    """(1024,512),10000次Fast-SSC 常规与type节点对比"""
#     SNR = [2,2.12,2.25,2.38,2.5,2.62,2.75,2.88,3,3.12,3.25,3.38,3.5]
#     # Fast-SSC-regular
#     BER1 = [0.01600332,0.010937891,0.005714453,0.003467383,0.001920508,0.001050586,0.000519336, \
# 0.000382617,0.000182813,0.000107422,5.90E-05,3.40E-05,1.88E-05]
#     BLER1 = [0.0803,0.0586,0.0362,0.0227,0.0129,0.0089,0.0058, \
# 0.0033,0.0014,0.0011,0.0009,0.0007,0.0002]
#     # Fast-SSC-Type
#     BER3 = [0.016758203,0.010254102,0.005519727,0.003415234,0.002271484, \
# 0.001283984,0.00048457,0.000358203,0.0002375,8.71E-05,5.21E-05,2.23E-05,6.64E-06]
#     BLER3 = [0.0851,0.0572,0.0343,0.0213,0.0147,0.0098,0.0044, \
# 0.0027,0.0012,0.001,0.0006,0.0005,0.0002]
#     plotfig2(SNR,BER1,BER3,BLER1,BLER3)


    SNR = [0,0.5,1,1.5,2,2.5,3,3.5]
    # SC
    BER2 = [0.340403646,0.256484375,0.163739583,0.084541667,0.039036458,0.010296875,0.002539063,0.000552083]
    BLER2 = [0.889,0.744666667,0.509,0.288,0.147,0.043,0.012,0.003]
    # Fast-SSC-regular
    BER1 = [0.456621,0.38411,0.232499,0.081855,0.017245,0.002,0.000211,0.000014]
    BLER1 = [0.9974,0.9481,0.7083,0.3198,0.0847,0.0133,0.0019,0.0006]
    # Fast-SSC-Type
    BER3 = [0.457328,0.385054,0.231892,0.083138,0.016225,0.002171,0.000283,0.000015]
    BLER3 = [0.9968,0.9485,0.7083,0.3213,0.081,0.0166,0.0022,0.0008]
    plotfig3(SNR,BER3,BER2,BER1,BLER3,BLER2,BLER1)

0.889,0.744666667,0.509,0.288,0.147,0.043,0.012,0.003






















