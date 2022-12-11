//======================================================
//Filename                : func_type1.v
//Author                  : WangJie
//Created On              : 2022-12-10 21:11
//Last Modified           : 
//Description             : 
//                          
//llr_arr_1 = {llr[0],llr[2],llr[4], ... ,llr[14]}
//llr_arr_2 = {llr[1],llr[3],llr[5], ... ,llr[15]}
//
//======================================================
`include "defines.v"
module func_type1(
    input   wire    [`PROCESS_UNIT_LLR_BUS] llr,
    output  wire    [`FUNC_TYPE1_BIT_BUS] bit_out
);

wire [`LLR_INTERNAL_LEN+2-1:0] llr_arr_1  [`PROCESS_UNIT_LLR_NUM/4-1:0];
wire [`LLR_INTERNAL_LEN+2-1:0] llr_arr_2  [`PROCESS_UNIT_LLR_NUM/4-1:0];
wire [`LLR_INTERNAL_LEN+2-1:0] llr_sum_1;
wire [`LLR_INTERNAL_LEN+2-1:0] llr_sum_2;

wire [1:0] b;
/* wire [`LLR_INTERNAL_LEN+4-1:0] llr_sum; */

generate
    genvar i;
    for(i = 0; i < `PROCESS_UNIT_LLR_NUM/2; i = i+2) begin : gen_scale
        assign llr_arr_1[i/2] = llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-i*`LLR_INTERNAL_LEN)-1] == 0 ?
            {2'b00,llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-i*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN]} : 
            {2'b11,llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-i*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN]};
    end
endgenerate

generate
    genvar j;
    for(j = 1; j < `PROCESS_UNIT_LLR_NUM/2; j = j+2) begin : gen_scale
        assign llr_arr_2[j/2] = llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-j*`LLR_INTERNAL_LEN)-1] == 0 ?
            {2'b00,llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-j*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN]} : 
            {2'b11,llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-j*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN]};
    end
endgenerate

assign llr_sum_1 = llr_arr_1[0] + llr_arr_1[1] + llr_arr_1[2] + llr_arr_1[3];
assign llr_sum_2 = llr_arr_2[0] + llr_arr_2[1] + llr_arr_2[2] + llr_arr_2[3];

assign b[1] = llr_sum_1[`LLR_INTERNAL_LEN+2-1];
assign b[0] = llr_sum_2[`LLR_INTERNAL_LEN+2-1]; 

assign bit_out = {4{b}};

endmodule
