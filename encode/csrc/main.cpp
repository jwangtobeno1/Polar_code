#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "Vlight.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


#define MAX_SIM_TIME 100000 //100个时钟周期后结束仿真
vluint64_t sim_time = 0;

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
Vlight* top = NULL; 

void step_and_dump_wave(){
    top->clk ^= 1;
    top->eval();
    /* contextp->timeInc(1); */
    tfp->dump(sim_time);
    sim_time++;
}
//reset n个周期
void reset(int n){
    top->rst = 1;
    while(n-- > 0) step_and_dump_wave();
    top->rst = 0;
}

void sim_init(){
    contextp = new VerilatedContext;
    tfp = new VerilatedVcdC;
    top = new Vlight;
    contextp->traceEverOn(true);  //trace初始化
    top->trace(tfp, 5);
    tfp->open("obj_dir/simx.vcd");
}

void sim_exit(){
    step_and_dump_wave();
    tfp->close();
    delete top;
}

int main(int argc, char** argv)
{
    Verilated::commandArgs(argc, argv);
    sim_init(); 
    
    reset(10);

    while(!Verilated::gotFinish() && sim_time < MAX_SIM_TIME){
        step_and_dump_wave();
    }
    sim_exit();
    return 0;
}

