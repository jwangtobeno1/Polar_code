//======================================================
//Filename                : func_rep.v
//Author                  : WangJie
//Created On              : 2022-12-08 21:39
//Last Modified           : 2022-12-09 21:55
//Description             : 
//                          
//======================================================
`include "defines.v"
module func_rep(
    input   wire    [`PROCESS_UNIT_LLR_BUS] llr,
    output  wire    [`FUNC_REP_BIT_BUS]     bit_out
);

wire [`LLR_INTERNAL_LEN+4-1:0] llr_arr  [`PROCESS_UNIT_LLR_NUM-1:0];
wire [`LLR_INTERNAL_LEN+4-1:0] llr_sum;

generate
    genvar i;
    for(i = 0; i < `PROCESS_UNIT_LLR_NUM; i = i+1) begin : gen_scale
        assign llr_arr[i] = llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-i*`LLR_INTERNAL_LEN)-1] == 0 ?
            {4'b0000,llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-i*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN]} : 
            {4'b1111,llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-i*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN]};
    end
endgenerate

assign llr_sum = llr_arr[0] + llr_arr[1] + llr_arr[2] + llr_arr[3] + llr_arr[4] + llr_arr[5] + llr_arr[6] + llr_arr[7] + llr_arr[8] + llr_arr[9] + llr_arr[10] + llr_arr[11] + llr_arr[12] + llr_arr[13] + llr_arr[14] + llr_arr[15]; 

assign bit_out = llr_sum[`LLR_INTERNAL_LEN+4-1] == 0 ? `PROCESS_UNIT_LLR_NUM'b0 :`PROCESS_UNIT_LLR_NUM'b1111_1111_1111_1111; 

endmodule
