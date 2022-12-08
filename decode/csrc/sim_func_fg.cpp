#include "Vfunc_fg.h"
#include "verilated.h"
#include "stdio.h"
#include <fstream>
#include <iostream>
#include <string>
using namespace std;

#define LLR_NUM 300

int main(int argc, char** argv, char** env) {
    uint32_t llr_arr[LLR_NUM],llr[3];
    uint64_t fres_arr[LLR_NUM/3];
    uint32_t i=0, j=0;
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);
    Vfunc_fg* top = new Vfunc_fg{contextp};

    fstream f1;
    f1.open("/hdd/Projects/Polar_code/decode/csrc/simfile/llr.txt",ios::in);
    fstream f2;
    f2.open("/hdd/Projects/Polar_code/decode/csrc/simfile/f_res.txt",ios::in);
    
    if(f1.is_open() && f2.is_open()){
        cout << "open file" << endl;
    }else{
        cout << "open file faild" << endl;
        return 0;
    }

    string str_llr,str_fres,compare_res;
    while(!Verilated::gotFinish() && getline(f1,str_llr)){
        llr_arr[i++] = stoul(str_llr,0,10);
    }
    
    while(getline(f2,str_fres)){
        fres_arr[j++] = stoul(str_fres,0,10);
    }
    top->bit_in = 0;
    top->flag_fg = 1;
    j=0;
    for(i = 0; i < LLR_NUM; i = i+3){
        llr[2] = llr_arr[i];
        llr[1] = llr_arr[i+1];
        llr[0] = llr_arr[i+2];
        std::copy(std::begin(llr),std::end(llr),std::begin(top->llr));
        /* printf("topllr[0] is %u\nllr[1] is %u\nllr[2] is %u\n",top->llr[0],top->llr[1],top->llr[2]); */
        top->eval();
        if(top->llr_out == fres_arr[j]) compare_res = "TRUE";
        else compare_res = "FALSE";
        printf("llr_out is %ld\tpy_out is %ld\t",top->llr_out,fres_arr[j++]);
        cout << compare_res << endl;
    }
    /* llr[2] = 676136248; */
    /* llr[1] = 1856265036; */
    /* llr[0] = 2297639175; */
    delete top;
    delete contextp;
    return 0;
}

