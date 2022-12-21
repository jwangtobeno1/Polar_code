#ifndef SIMVCD
#define SIMVCD 0
#endif

#if SIMVCD
#include "verilated_vcd_c.h"
#endif

#include "Vprocess_unit.h" //will modify
#define VTOP Vprocess_unit

#include "verilated.h"
#include "stdio.h"
#include <fstream>
#include <iostream>
#include <string>
using namespace std;

#define NUM 10400 //104*i  
    
fstream fdin,fdout;

int fileinit(){
    fdin.open("/hdd/Projects/Polar_code/decode/csrc/simfile/pfile_din.txt",ios::in);
    fdout.open("/hdd/Projects/Polar_code/decode/csrc/simfile/pfile_dout.txt",ios::in);
    /* fbit.open("/hdd/Projects/Polar_code/decode/csrc/simfile/bitout.txt",ios::in); */
    
    if(fdin.is_open() && fdout.is_open()){
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
    uint32_t din[NUM],llr_in[3],bit_comb_l[4],bit_comb_r[4];
    uint64_t dout[NUM-NUM/13*3],llr_out,bit_out,bit_comb_out[8];
    uint32_t i=0 , j=0,err_num=0;
    string str_din,str_dout;

/*file_init */
    if(!fileinit()) return 0;
    
//read file
    while(getline(fdin,str_din)){
        din[i++] = stoul(str_din,0,10);
    }
    i = 0;
    while(getline(fdout,str_dout)){
        dout[i++] = stoul(str_dout,0,10);
    }
    
    /* while(getline(f2,str_gres)){ */
    /*     gres_arr[j++] = stoul(str_gres,0,10); */
    /* } */
    for(i = 0; i < NUM; i=i+13){
        llr_in[2] = din[i+0];
        llr_in[1] = din[i+1];
        llr_in[0] = din[i+2];
        std::copy(std::begin(llr_in),std::end(llr_in),std::begin(top->llr_in));
        top->funcg_bit_in = din[i+3];
        top->inst = din[i+4];
        bit_comb_l[3] = din[i+5];
        bit_comb_l[2] = din[i+6];
        bit_comb_l[1] = din[i+7];
        bit_comb_l[0] = din[i+8];
        std::copy(std::begin(bit_comb_l),std::end(bit_comb_l),std::begin(top->bit_comb_left));
        bit_comb_r[3] = din[i+9];
        bit_comb_r[2] = din[i+10];
        bit_comb_r[1] = din[i+11];
        bit_comb_r[0] = din[i+12];
        std::copy(std::begin(bit_comb_r),std::end(bit_comb_r),std::begin(top->bit_comb_right));

        top->eval();
#if SIMVCD
        tfp->dump(contextp->time());
        contextp->timeInc(1);
#endif
        switch(din[i+4]/16){
        case 0: {
                    /* printf("f result is %lu\t\t",top->llr_out); */ 
                    if(top->llr_out != dout[j+0])
                        err_num++;
                }break;
        case 1: {
                    /* printf("g result is %lu\t\t",top->llr_out); */
                    if(top->llr_out != dout[j+0])
                        err_num++;
                }break;
        case 2: {
                    /* printf("rep result is %u\t\t\t\t",top->bit_out); */ 
                    if(top->bit_out != dout[j+1])
                        err_num++;
                }break;
        case 3: {
                    /* printf("spc result is %u\t\t\t",top->bit_out); */ 
                    if(top->bit_out != dout[j+1])
                        err_num++;
                }break;
        case 5: {
                    /* printf("rate1 result is %u\t\t\t",top->bit_out); */
                    if(top->bit_out != dout[j+1])
                        err_num++;
                } break;
        case 6: {
                    /* printf("type1 result is %u\t\t\t",top->bit_out); */
                    if(top->bit_out != dout[j+1])
                        err_num++;
                } break;
        case 7: {
                    /* printf("type3 result is %u\n",top->bit_out); */
                    if(top->bit_out != dout[j+1])
                        err_num++;
                } break;
        case 10: {
                    if(dout[j+2]==top->bit_comb_out[7] && dout[j+3]==top->bit_comb_out[6] && dout[j+4]==top->bit_comb_out[5] && dout[j+5]==top->bit_comb_out[4] && dout[j+6]==top->bit_comb_out[3] && dout[j+7]==top->bit_comb_out[2] && dout[j+8]==top->bit_comb_out[1] && dout[j+9]==top->bit_comb_out[0])
                        cout << hex << top->bit_comb_out[0] <<endl;
                    else
                        err_num++;
                 }
                 break;
        default: printf("error!\n");
        }

        j+=10;
        /* cout << hex << top->bit_out[7]; */
        /* cout << hex << top->bit_out[6]; */
        /* cout << hex << top->bit_out[5]; */
        /* cout << hex << top->bit_out[4]; */
        /* cout << hex << top->bit_out[3]; */
        /* cout << hex << top->bit_out[2]; */
        /* cout << hex << top->bit_out[1]; */
        /* cout << hex << top->bit_out[0] <<endl; */
        /* if(top->bit_out == bit_arr[2]) cout << "TRUE" << endl; */
        /* else cout << "FALSE" << endl; */
    }

    printf("total error : %u\n",err_num);
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

