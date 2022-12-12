//======================================================
//Filename                : func_rate1.v
//Author                  : WangJie
//Created On              : 2022-12-10 20:56
//Last Modified           : 
//Description             : 
//                          
// the relation of llr and llr_arr:
// +----------------------------------------------------------+
// + llr[95:90] + llr[89:84] + llr[83:78] + ... + llr[5:0]    +
// + llr_arr[0] + llr_arr[1] + llr_arr[2] + ... + llr_arr[15] +
// +----------------------------------------------------------+
//
//======================================================
`include "defines.v"

module func_rate1(
    input   wire    [`PROCESS_UNIT_LLR_BUS] llr,
    output  wire    [`FUNC_SPC_BIT_BUS]     bit_out //[15:0] same with spc!
);

wire [`LLR_INTERNAL_LEN-1:0] llr_arr  [`PROCESS_UNIT_LLR_NUM-1:0];
wire [`FUNC_SPC_BIT_BUS]     bit_tmp;

generate
    genvar i;
    for(i = 0; i < `PROCESS_UNIT_LLR_NUM; i = i+1) begin : gen_scale
        assign llr_arr[i] = {llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-i*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN]};
        assign bit_tmp[`PROCESS_UNIT_LLR_NUM-i-1] = llr_arr[i][`LLR_INTERNAL_LEN-1];
    end
endgenerate

assign bit_out = bit_tmp;

endmodule
