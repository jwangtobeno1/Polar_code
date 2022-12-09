`timescale 1ns/1ps

`define BIT_N 256
`define BIT_K 128

`define LLR_CHANNEL_LEN 4
`define LLR_INTERNAL_LEN 6

`define PROCESS_UNIT_LLR_NUM 16
`define PROCESS_UNIT_LLR_BUS (`LLR_INTERNAL_LEN*`PROCESS_UNIT_LLR_NUM)-1 : 0
`define PORCESS_UNIT_LLR_OUT_BUS (`LLR_INTERNAL_LEN*`FUNC_G_BIT_LEN)-1 : 0
`define FUNC_G_BIT_LEN `PROCESS_UNIT_LLR_NUM/2

`define FUNC_REP_BIT_BUS `PROCESS_UNIT_LLR_NUM-1:0 //15:0

`define INST_BUS 7:0 //4(operation) :3(stage) :1(left or right) 
`define INST_OPCODE_BUS 3:0
`define INST_OP_LOCATION 7:4
`define INST_STAGE_LOCATION 3:1
`define FUNC_F      4'b0001
`define FUNC_G      4'b0010
`define FUNC_G0R    4'b0011
`define FUNC_REP    4'b0100
`define FUNC_SPC    4'b0101
`define FUNC_RATE0  4'b0110
`define FUNC_RATE1  4'b0111
`define FUNC_TYPE1  4'b1000
`define FUNC_TYPE3  4'b1001
`define BIT_COMBINE 4'b1010
`define BIT_COMBINE_0R 4'b1011

