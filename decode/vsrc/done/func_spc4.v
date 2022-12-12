//======================================================
//Filename                : func_spc4.v
//Author                  : WangJie
//Created On              : 2022-12-09 21:56
//Last Modified           : 
//Description             : 4 llr spc function only for type3
//
// 1. hard decision per llr
// 2. if &bit[] == 0 : hard_decison is true;
//      else : invert min_abs bit;
//
//======================================================
`include "defines.v"

module func_spc4(
    input   wire    [`FUNC_SPC4_LLR_BUS] llr, //23:0
    output  wire    [`FUNC_SPC4_BIT_BUS] bit_out //3:0
);

wire [`LLR_INTERNAL_LEN+2-1:0] llr_arr  [3:0];
wire [`LLR_INTERNAL_LEN+2-1:0] llr_abs  [3:0];
wire [`FUNC_SPC4_BIT_BUS]     bit_tmp;
wire bit_sum;
wire [1:0] index;

wire [`LLR_INTERNAL_LEN+2-1:0] llr_abs_min_s1 [1:0];
wire [`LLR_INTERNAL_LEN+2-1:0] llr_abs_min_s2;

wire [1:0] mem2[3:0];
assign mem2[0 ] = 2'd0 ;
assign mem2[1 ] = 2'd1 ;
assign mem2[2 ] = 2'd2 ;
assign mem2[3 ] = 2'd3 ;

generate
    genvar i;
    for(i = 0; i < 4; i = i+1) begin : gen_scale
        assign llr_arr[i] = {mem2[i],llr[(24-i*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN]};
        assign bit_tmp[3-i] = llr_arr[i][`LLR_INTERNAL_LEN-1];
        assign llr_abs[i] = (llr_arr[i][`LLR_INTERNAL_LEN-1]) ? {mem2[i],(~llr_arr[i][`LLR_INTERNAL_LEN-1:0])+1'b1} : llr_arr[i];
    end
endgenerate

assign llr_abs_min_s1[0] = llr_abs[0 ][`LLR_INTERNAL_LEN-1:0] > llr_abs[1][`LLR_INTERNAL_LEN-1:0]  ? llr_abs[1 ] : llr_abs[0 ];
assign llr_abs_min_s1[1] = llr_abs[2 ][`LLR_INTERNAL_LEN-1:0] > llr_abs[3][`LLR_INTERNAL_LEN-1:0]  ? llr_abs[3 ] : llr_abs[2 ];

assign llr_abs_min_s2 = llr_abs_min_s1[0][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s1[1][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s1[1] : llr_abs_min_s1[0];
assign index = llr_abs_min_s2[`LLR_INTERNAL_LEN+2-1:`LLR_INTERNAL_LEN];

assign bit_sum = ^bit_tmp;

assign bit_out = bit_sum == 0 ? bit_tmp : 
    (bit_tmp[3-index] == 0 ? bit_tmp + (1<<(3-index)) : bit_tmp & (~(1<<(3-index))));

endmodule
