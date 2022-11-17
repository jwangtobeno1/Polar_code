#!/usr/bin/env python
# coding=utf-8
import numpy as np
import matplotlib.pyplot as plt
import wavio

from random import randint
from scipy.signal import firwin, lfilter, butter,freqz

source_file = '../encode/polar_encode_result_arr.txt'

def load_source():
    """load source from encode_result"""
    source_arr = np.loadtxt(source_file)
    return source_arr


def create_source(fs = 1000, fl = 100, fh = 200, baud_rate = 10, N = 10):
    """
    N = source length
    t = 10
    baud_rate = 10 bit per s; if N = 100,signal duration 100/10 s & samples = 1000 * 10 = 10000 points 
    """
    samples_per_bit = 1.0 / baud_rate * fs
    #create source or load source from .txt file
    source_arr = load_source()
    if len(source_arr) == 0:
        source = [randint(0,1) for i in range(N)]
        source_arr = np.array(source)
        noise = np.random.normal(0,1,int(samples_per_bit * N))
    else:
        noise = np.random.normal(0,1,int(samples_per_bit * len(source_arr)))
        
    # save source to .txt file
    np.savetxt('source.txt',source_arr,fmt = '%d')

    source_arr[source_arr == 0] = fl
    source_arr[source_arr == 1] = fh
    symbols = np.repeat(source_arr,samples_per_bit)

    t = np.arange(0, len(symbols)/fs, 1.0/fs)
    signal = 4*np.sin(2*np.pi*symbols*t)
    signal_add_noise = signal + noise
    #save signal to .wav file
    wavio.write("signal24.wav", signal_add_noise, fs, sampwidth = 3)

    return signal_add_noise

def bandpass_firwin(ntaps,lowcut,highcut,fs,window = 'hamming'):
    taps = firwin(ntaps, [lowcut, highcut], fs = fs, pass_zero = False, window = window, scale = True)
    return taps

def fullwave(source):
    return np.absolute(source)

def lowpass_firwin(ntaps,pass_freq,fs,window = 'hamming'):
    taps = firwin(ntaps,pass_freq, fs = fs, window = window,pass_zero = True,scale = True)
    return taps

if __name__ == '__main__':
    signal = load_source()
    signal = create_source()
    #fir filter
    taps_1 = bandpass_firwin(ntaps=50,lowcut=90,highcut=110,fs=1000)
    taps_2 = bandpass_firwin(ntaps=50,lowcut=190,highcut=210,fs=1000)
    filter_out_1 = lfilter(taps_1, 1.0, signal)
    filter_out_2 = lfilter(taps_2, 1.0, signal)
    fig1,(ax1_1,ax1_2) = plt.subplots(2,1,sharex=True)
    ax1_1.plot(filter_out_1)
    ax1_1.set_title('BP_100Hz')
    ax1_2.plot(filter_out_2)
    ax1_2.set_title('BP_200Hz')
    #full wave
    fwave1 = fullwave(filter_out_1)
    fwave2 = fullwave(filter_out_2)
    fig2,(ax2_1,ax2_2) = plt.subplots(2,1,sharex=True)
    ax2_1.plot(fwave1)
    ax2_1.set_title('FullWave_100Hz')
    ax2_2.plot(fwave2)
    ax2_2.set_title('FullWave_200Hz')
    #lowpass filter
    taps_lp = lowpass_firwin(ntaps = 51,pass_freq = 50, fs = 1000)
    lowpass1 = lfilter(taps_lp, 1.0, fwave1)
    lowpass2 = lfilter(taps_lp, 1.0, fwave2)
    fig3,(ax3_1,ax3_2) = plt.subplots(2,1,sharex=True)
    ax3_1.plot(lowpass1)
    ax3_1.set_title('LP_100Hz')
    ax3_2.plot(lowpass2)
    ax3_2.set_title('LP_200Hz')
    #plot signal and fskdemod out
    fskdemod_out = lowpass1-lowpass2
    np.savetxt('fskdemod_data.txt',fskdemod_out,fmt='%f')
    fig,(ax1,ax2) = plt.subplots(2,1,sharex=True)
    ax1.plot(signal)
    ax1.set_title('signal')
    ax2.plot(fskdemod_out)
    ax2.set_title('fskdemod_out')

    plt.show()

