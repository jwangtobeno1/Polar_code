#include <stdio.h>
#include <fstream>
#include <iostream>
#include <string>
using namespace std;

#include "Vfunc_fg.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


#define MAX_SIM_TIME 100 //100个时钟周期后结束仿真
#define TOP Vfunc_fg
vluint64_t sim_time = 0;

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
TOP * top = NULL; 
/*
void step_and_dump_wave(){
    top->clk ^= 1;
    top->eval();
     contextp->timeInc(1); 
    tfp->dump(sim_time);
    sim_time++;
}
//reset n个周期
void reset(int n){
    top->rst = 1;
    while(n-- > 0) step_and_dump_wave();
    top->rst = 0;
}
*/

void sim_init(){
    contextp = new VerilatedContext;
    tfp = new VerilatedVcdC;
    top = new TOP;
    contextp->traceEverOn(true);  //trace初始化
    top->trace(tfp, 99);
    tfp->open("obj_dir/simx.vcd");
}
/*
void sim_exit(){
    step_and_dump_wave();
    tfp->close();
    delete top;
}

void delay_cycles(int num){
    while(num--){
        step_and_dump_wave();
    }
}
*/
//binary add
int add(int a, int b){
    int re = a;
    while(b){
        int tmp = a;
        a = a^b;
        b = (tmp&b)<<1;
        re = a;
    }
    return re;
}

int sub(int a, int b){
    b = add(~b,1);
    return add(a,b);
}

int verified(int llra,int llrb,int flag){
    int tmp,result;
    if(flag){ //f function
        tmp = (llra>>11)^(llrb>>11) ? 0 : 1; //tmp =0 is -
        if(llra<0) llra = ((~(llra>>4))<<4) + 16 + (llra&0x0f);
        if(llrb<0) llrb = ((~(llrb>>4))<<4) + 16 + (llrb&0x0f);
        if(llra > llrb){
            if(tmp)
                result = llrb;
            else{
                result = ((~(llrb>>4))<<4) + 16 + (llrb&0x0f);
                if(~(llrb>>4) == -1)
                    result = result | 2048;
            }
        }else{
            if(tmp)
                result = llra;
            else{
                result = ((~(llra>>4))<<4) + 16 + (llra&0x0f); 
                if(~(llra>>4) == -1)
                    result = result | 2048;
            }
        }
    }else{ //g function
        if((llrb >> 11) ^ (llra >> 11)){
            tmp = sub(llrb,llra);
        }else
            tmp = add(llrb,llra);
        switch((tmp >> 11)&(-1)){
            case 1  : result = result = (tmp&15)|2032; break; 
            case -2 : result = result = (tmp&15)|2048; break;  //10
            default : result = tmp;
        }
    }

    return result;
}

int main(int argc, char** argv)
{
    Verilated::commandArgs(argc, argv);
    sim_init(); 
    
    /* reset(10); */

    //initial:
    top->llr_a = 0;
    top->llr_b = 0;
    top->f_flag = 1; //1-f 0-g
    contextp->timeInc(1); 
    top->eval();
    tfp->dump(contextp->time());

    //read source from file
    fstream f1;
    f1.open("./testfile/llr_a.txt",ios::in);
    fstream f2;
    f2.open("./testfile/llr_b.txt",ios::in);

    string stra;
    string strb;
    int llra,llrb,dout,tmp;
    int no = 0,error = 0;
    int no_arr[1000];

    if(f1.is_open() && f2.is_open()){
        cout << "open file" << endl;
    }else{
        cout << "open file faild" << endl;
        return 0;
    }

    while(!Verilated::gotFinish() && sim_time < MAX_SIM_TIME && getline(f1,stra) && getline(f2,strb)){
        /* step_and_dump_wave(); */
        llra = stoi(stra,0,2);
        llrb = stoi(strb,0,2);
        top->llr_a = llra;
        top->llr_b = llrb;
        contextp->timeInc(1);
        top->eval();
        printf("%d:\tllr_a is %x\tllr_b is %x\tdout is %x\t",no++,top->llr_a,top->llr_b,top->dout);
        if(llra >= 2048) llra = llra | 0xfffff000;
        if(llrb >= 2048) llrb = llrb | 0xfffff000;
        dout = verified(llra,llrb,top->f_flag);
        if((dout&0x0fff) != top->dout) {
            no_arr[error] = no-1;
            error++;
        }
        printf("ttout is %x\n",dout&0x0fff);
        tfp->dump(contextp->time());
    }
    printf("total error:   %d\n",error);
    for(int i=0;i<error;i++){
        printf("%d\t",no_arr[i]);
        if(i%10 == 0) printf("\n");
    }
    f1.close();
    f2.close();
    top->final();
    tfp->close();

    delete top;
    /* sim_exit(); */
    return 0;
}

