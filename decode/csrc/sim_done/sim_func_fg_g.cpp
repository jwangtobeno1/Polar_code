#include "Vfunc_fg.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "stdio.h"
#include <fstream>
#include <iostream>
#include <string>
using namespace std;

#define LLR_NUM 30 //3*i  

int main(int argc, char** argv, char** env) {
    uint32_t llr_arr[LLR_NUM],llr[3];
    uint8_t bit_arr[LLR_NUM/3];
    uint64_t gres_arr[LLR_NUM/3];
    uint32_t i=0, j=0;
    VerilatedContext* contextp = new VerilatedContext;
    VerilatedVcdC* tfp = new VerilatedVcdC;
    contextp->commandArgs(argc, argv);
    Vfunc_fg* top = new Vfunc_fg{contextp};
    contextp->traceEverOn(true);  //trace初始化
    top->trace(tfp, 99);
    tfp->open("obj_dir/simx.vcd");
    contextp->timeInc(1); 
    tfp->dump(contextp->time());

    fstream f1;
    f1.open("/hdd/Projects/Polar_code/decode/csrc/simfile/llr.txt",ios::in);
    fstream f2;
    f2.open("/hdd/Projects/Polar_code/decode/csrc/simfile/g_res.txt",ios::in);
    fstream fbit;
    fbit.open("/hdd/Projects/Polar_code/decode/csrc/simfile/g_bit.txt",ios::in);
    
    if(f1.is_open() && f2.is_open() && fbit.is_open()){
        cout << "open file" << endl;
    }else{
        cout << "open file faild" << endl;
        return 0;
    }
    string str_llr,str_gres,compare_res,str_bit;
    while(!Verilated::gotFinish() && getline(f1,str_llr)){
        llr_arr[i++] = stoul(str_llr,0,10);
    }
    i = 0;
    while(getline(fbit,str_bit)){
        bit_arr[i++] = stoi(str_bit);
    }
    
    while(getline(f2,str_gres)){
        gres_arr[j++] = stoul(str_gres,0,10);
    }
    top->bit_in = 0;
    top->flag_fg = 0;
    j=0;
    for(i = 0; i < LLR_NUM; i = i+3){
        llr[2] = llr_arr[i];
        llr[1] = llr_arr[i+1];
        llr[0] = llr_arr[i+2];
        std::copy(std::begin(llr),std::end(llr),std::begin(top->llr));
        top->bit_in = bit_arr[j++];
        top->eval();
        contextp->timeInc(1);
        tfp->dump(contextp->time());
        printf("llr[0] is %u\nllr[1] is %u\nllr[2] is %u\nbit_in is %u\n",top->llr[0],top->llr[1],top->llr[2],top->bit_in);
        printf("result is %ld\n",top->llr_out);
        /* if(top->llr_out == fres_arr[j]) compare_res = "TRUE"; */
        /* else compare_res = "FALSE"; */
        /* printf("llr_out is %ld\tpy_out is %ld\t",top->llr_out,fres_arr[j++]); */
        /* cout << compare_res << endl; */
    }
    /* llr[2] = 676136248; */
    /* llr[1] = 1856265036; */
    /* llr[0] = 2297639175; */
    f1.close();
    f2.close();
    fbit.close();
    top->final();
    tfp->close();
    delete top;
    delete contextp;
    return 0;
}

