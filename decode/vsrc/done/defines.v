`timescale 1ns/1ps

`define BIT_N 256
`define BIT_K 128

`define LLR_CHANNEL_LEN 4
`define LLR_INTERNAL_LEN 6

`define PROCESS_UNIT_LLR_NUM 16
`define PROCESS_UNIT_LLR_BUS (`LLR_INTERNAL_LEN*`PROCESS_UNIT_LLR_NUM)-1:0 //95:0
`define PROCESS_UNIT_LLR_OUT_BUS (`LLR_INTERNAL_LEN*`PROCESS_UNIT_LLR_NUM)/2-1:0//47:0
`define PROCESS_UNIT_BIT_BUS `PROCESS_UNIT_LLR_NUM-1:0
`define PORCESS_UNIT_LLR_OUT_BUS (`LLR_INTERNAL_LEN*`FUNC_G_BIT_LEN)-1 : 0
`define FUNC_G_BIT_LEN `PROCESS_UNIT_LLR_NUM/2

`define FUNC_REP_BIT_BUS `PROCESS_UNIT_LLR_NUM-1:0 //15:0
`define FUNC_SPC_BIT_BUS `PROCESS_UNIT_LLR_NUM-1:0 //15:0

`define FUNC_TYPE_BIT_BUS (`PROCESS_UNIT_LLR_NUM/2)-1:0 //7:0
`define FUNC_G_BIT_BUS (`PROCESS_UNIT_LLR_NUM/2)-1:0 //7:0
`define FUNC_SPC4_LLR_BUS 23:0
`define FUNC_SPC4_BIT_BUS 3:0

`define INST_BUS 7:0 //4(operation) :3(stage) :1(left or right) 
`define PU_OPCODE_BUS 3:0
`define INST_STAGE_BUS 2:0
`define PU_OP_LOCATION 7:4
`define INST_STAGE_LOCATION 3:1
`define FUNC_F      4'b0000
`define FUNC_G      4'b0001
`define FUNC_REP    4'b0010
`define FUNC_SPC    4'b0011
`define FUNC_RATE0  4'b0100
`define FUNC_RATE1  4'b0101
`define FUNC_TYPE1  4'b0110
`define FUNC_TYPE3  4'b0111
`define FUNC_G0R    4'b1001
`define BIT_COMBINE 4'b1010
`define BIT_COMBINE_0R 4'b1100

`define COMB4TO8     3'd0
`define COMB8TO16    3'd1
`define COMB16TO32   3'd2
`define COMB32TO64   3'd3
`define COMB64TO128  3'd4
`define COMB128TO256 3'd5

