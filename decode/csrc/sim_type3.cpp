#ifndef SIMVCD
#define SIMVCD 0
#endif

#if SIMVCD
#include "verilated_vcd_c.h"
#endif

#include "Vfunc_type3.h" //will modify
#define VTOP Vfunc_type3

#include "verilated.h"
#include "stdio.h"
#include <fstream>
#include <iostream>
#include <string>
using namespace std;

#define LLR_NUM 300 //3*i  
    
fstream f1,f2,fbit;

int fileinit(){
    f1.open("/hdd/Projects/Polar_code/decode/csrc/simfile/llr.txt",ios::in);
    /* f2.open("/hdd/Projects/Polar_code/decode/csrc/simfile/g_res.txt",ios::in); */
    fbit.open("/hdd/Projects/Polar_code/decode/csrc/simfile/bitout.txt",ios::in);
    
    if(f1.is_open() && fbit.is_open()){
        cout << "open file" << endl;
        return 1;
    }else{
        cout << "open file faild" << endl;
        return 0;
    }
}

/* void moduleinit(){ */
/*     /1* top->llr = 0; *1/ */
/*     top->eval(); */
/* #if SIMVCD */
/*     tfp->dump(contextp->time()); */
/*     contextp->timeInc(1); // 1 timeprecsion period pass */ 
/* #endif */
/* } */

int main(int argc, char** argv, char** env) {
    VerilatedContext* contextp = new VerilatedContext;
    VTOP* top = new VTOP{contextp};

#if SIMVCD
    VerilatedVcdC* tfp = new VerilatedVcdC;
    contextp->traceEverOn(true);  //trace初始化
    top->trace(tfp, 99);
    tfp->open("obj_dir/simx.vcd");
#endif

    contextp->commandArgs(argc, argv);
//init 
    uint32_t llr_arr[LLR_NUM],llr[3];
    uint32_t bit_arr[LLR_NUM/3];
    uint64_t res_arr[LLR_NUM/3];
    uint32_t i=0, j=0;
    string str_llr,compare_res,str_bit;

    /* moduleinit(); */
    if(!fileinit()) return 0;
    
//read file
    while(!Verilated::gotFinish() && getline(f1,str_llr)){
        llr_arr[i++] = stoul(str_llr,0,10);
    }
    i = 0;
    while(getline(fbit,str_bit)){
        bit_arr[i++] = stoul(str_bit,0,10);
    }
    
    /* while(getline(f2,str_gres)){ */
    /*     gres_arr[j++] = stoul(str_gres,0,10); */
    /* } */

    j = 0;
    for(i = 0; i < LLR_NUM; i = i+3){
        llr[2] = llr_arr[i];
        llr[1] = llr_arr[i+1];
        llr[0] = llr_arr[i+2];
        std::copy(std::begin(llr),std::end(llr),std::begin(top->llr));
        top->eval();
#if SIMVCD
        tfp->dump(contextp->time());
        contextp->timeInc(1);
#endif
        /* printf("llr[0] is %u\nllr[1] is %u\nllr[2] is %u\n",top->llr[0],top->llr[1],top->llr[2]); */
        printf("result is %5u\t bit_arr is %5u\t",top->bit_out,bit_arr[j]);
        if(top->bit_out == bit_arr[j]) compare_res = "TRUE";
        else compare_res = "FALSE";
        /* printf("llr_out is %ld\tpy_out is %ld\t",top->llr_out,fres_arr[j++]); */
        cout << compare_res << endl;
        j++;
    }
    f1.close();
    /* f2.close(); */
    fbit.close();
    top->final();
#if SIMVCD
    tfp->close();
#endif
    delete top;
    delete contextp;
    return 0;
}

