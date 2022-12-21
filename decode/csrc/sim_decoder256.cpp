#ifndef SIMVCD
#define SIMVCD 0
#endif

#if SIMVCD
#include "verilated_vcd_c.h"
#endif

#include "Vdecoder256.h" //will modify
#define VTOP Vdecoder256

#include "verilated.h"
#include "stdio.h"
#include <fstream>
#include <iostream>
#include <string>
using namespace std;

#define MAX_SIM_TIME 700 //185*i  
    
VerilatedContext* contextp = new VerilatedContext;
VTOP* top = new VTOP{contextp};
#if SIMVCD
    VerilatedVcdC* tfp = new VerilatedVcdC;
#endif

fstream fdin,fdout;
uint32_t sim_time;

int fileinit(){
    fdin.open("/hdd/Projects/Polar_code/decode/pysrc/llr_t.txt",ios::in);
    fdout.open("/hdd/Projects/Polar_code/decode/pysrc/simout.txt",ios::out); 
    /* fbit.open("/hdd/Projects/Polar_code/decode/csrc/simfile/bitout.txt",ios::in); */
    
    if(fdin.is_open() && fdout.is_open()){
        cout << "open file" << endl;
        return 1;
    }else{
        cout << "open file faild" << endl;
        return 0;
    }
}

void clk_init(){
    top->clk ^= 1;
    top->eval();
#if SIMVCD
    contextp->timeInc(1);
    tfp->dump(contextp->time());
#endif
    top->clk ^= 1;
    top->eval();
#if SIMVCD
    contextp->timeInc(1);
    tfp->dump(contextp->time());
#endif
    sim_time++;
}



int main(int argc, char** argv, char** env) {
    uint32_t llr[3],din[256];
    char hex_str[40];
    int n,i=0;
    string str_din;

#if SIMVCD
    contextp->traceEverOn(true);  //trace初始化
    top->trace(tfp, 99);
    tfp->open("obj_dir/simx.vcd");
#endif

    contextp->commandArgs(argc, argv);
//init
    top->work_en = 0;
    top->rst_n = 0;
    n = 10;
    while(n-- >0) {clk_init();}
    top->rst_n = 1;

/*file_init */
    if(!fileinit()) return 0;
    
//read file
    while(getline(fdin,str_din)){
        din[i++] = stoul(str_din,0,10);
    }
    /* while(getline(fdout,str_dout)){ */
    /*     dout[i++] = stoul(str_dout,0,10); */
    /* } */
    top->work_en = 1;
    clk_init();
    top->work_en = 0;
    for(i=0; i<48;i = i+3){
        llr[2] = din[i+0];
        llr[1] = din[i+1];
        llr[0] = din[i+2];
        std::copy(std::begin(llr),std::end(llr),std::begin(top->llr_in));
        clk_init();
    }

    while(!Verilated::gotFinish() && sim_time < MAX_SIM_TIME){
        clk_init();
    }

    for(i = 0; i<8; i++){
        sprintf(hex_str,"%08x",top->bit_out[7-i]);
        fdout << hex_str;
    }

    fdin.close();
    fdout.close();
    top->final();
#if SIMVCD
    tfp->close();
#endif
    delete top;
    delete contextp;
    return 0;
}

