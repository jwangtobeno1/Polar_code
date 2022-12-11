//======================================================
//Filename                : func_type3.v
//Author                  : WangJie
//Created On              : 2022-12-11 14:16
//Last Modified           : 
//Description             : 
//                          
//llr_arr_1 = {llr[0],llr[2],llr[4],llr[6]}
//llr_arr_2 = {llr[1],llr[3],llr[5],llr[7]}
//
//======================================================
`include "defines.v"
module func_type3(
    input   wire    [`PROCESS_UNIT_LLR_BUS] llr,
    output  wire    [`FUNC_TYPE_BIT_BUS] bit_out
);

wire [`LLR_INTERNAL_LEN-1:0] llr_arr_1  [`PROCESS_UNIT_LLR_NUM/4-1:0];
wire [`LLR_INTERNAL_LEN-1:0] llr_arr_2  [`PROCESS_UNIT_LLR_NUM/4-1:0];
wire [3:0] bit_res_1;
wire [3:0] bit_res_2;

generate
    genvar i;
    for(i = 0; i < `PROCESS_UNIT_LLR_NUM/2; i = i+2) begin : gen_scale
        assign llr_arr_1[i/2] = llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-i*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN];
    end
endgenerate

generate
    genvar j;
    for(j = 1; j < `PROCESS_UNIT_LLR_NUM/2; j = j+2) begin : gen_scale
        assign llr_arr_2[j/2] = llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-j*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN];
    end
endgenerate

func_spc4 spc_inst_even(
    .llr({llr_arr_1[0],llr_arr_1[1],llr_arr_1[2],llr_arr_1[3]}), //23:0
    .bit_out(bit_res_1) //3:0
);
func_spc4 spc_inst_odd(
    .llr({llr_arr_2[0],llr_arr_2[1],llr_arr_2[2],llr_arr_2[3]}), //23:0
    .bit_out(bit_res_2) //3:0
);

assign bit_out = {bit_res_1[3],bit_res_2[3],bit_res_1[2],bit_res_2[2],bit_res_1[1],bit_res_2[1],bit_res_1[0],bit_res_2[0]};

endmodule
