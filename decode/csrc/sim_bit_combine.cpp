#ifndef SIMVCD
#define SIMVCD 0
#endif

#if SIMVCD
#include "verilated_vcd_c.h"
#endif

#include "Vbit_combine.h" //will modify
#define VTOP Vbit_combine

#include "verilated.h"
#include "stdio.h"
#include <fstream>
#include <iostream>
#include <string>
using namespace std;

#define NUM 27 //9*i  
    
fstream f1,f2,fbit;

int fileinit(){
    /* f1.open("/hdd/Projects/Polar_code/decode/csrc/simfile/llr.txt",ios::in); */
    /* f2.open("/hdd/Projects/Polar_code/decode/csrc/simfile/g_res.txt",ios::in); */
    fbit.open("/hdd/Projects/Polar_code/decode/csrc/simfile/bitout.txt",ios::in);
    
    if(fbit.is_open()){
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
    uint32_t tmp_arr[NUM],a_arr[4],b_arr[4];
    /* uint64_t res_arr[LLR_NUM/3]; */
    uint32_t i=0;
    string str_bit;

/*file_init */
    if(!fileinit()) return 0;
    
//read file
    /* while(!Verilated::gotFinish() && getline(f1,str_llr)){ */
    /*     llr_arr[i++] = stoul(str_llr,0,10); */
    /* } */
    i = 0;
    while(getline(fbit,str_bit)){
        tmp_arr[i++] = stoul(str_bit,0,10);
    }
    
    /* while(getline(f2,str_gres)){ */
    /*     gres_arr[j++] = stoul(str_gres,0,10); */
    /* } */
    for(i = 0; i < NUM; i=i+9){
        a_arr[3] = tmp_arr[i];
        a_arr[2] = tmp_arr[i+1];
        a_arr[1] = tmp_arr[i+2];
        a_arr[0] = tmp_arr[i+3];
        b_arr[3] = tmp_arr[i+4];
        b_arr[2] = tmp_arr[i+5];
        b_arr[1] = tmp_arr[i+6];
        b_arr[0] = tmp_arr[i+7];
        std::copy(std::begin(a_arr),std::end(a_arr),std::begin(top->bit_left_in));
        std::copy(std::begin(b_arr),std::end(b_arr),std::begin(top->bit_right_in));
        top->stage = tmp_arr[i+8];

        top->eval();
#if SIMVCD
        tfp->dump(contextp->time());
        contextp->timeInc(1);
#endif
        cout << hex << top->bit_out[7];
        cout << hex << top->bit_out[6];
        cout << hex << top->bit_out[5];
        cout << hex << top->bit_out[4];
        cout << hex << top->bit_out[3];
        cout << hex << top->bit_out[2];
        cout << hex << top->bit_out[1];
        cout << hex << top->bit_out[0] <<endl;
        cout << hex << "-------------" <<endl;
        /* if(top->bit_out == bit_arr[2]) cout << "TRUE" << endl; */
        /* else cout << "FALSE" << endl; */
    }

    /* f1.close(); */
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

