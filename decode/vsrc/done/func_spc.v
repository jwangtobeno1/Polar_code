//======================================================
//Filename                : .v
//Author                  : WangJie
//Created On              : 2022-12-09 21:56
//Last Modified           : 
//Description             : 
//
// 1. hard decision per llr
// 2. if &bit[] == 0 : hard_decison is true;
//      else : invert min_abs bit;
//
//======================================================
module func_spc(
    input   wire    [`PROCESS_UNIT_LLR_BUS] llr,
    output  wire    [`FUNC_SPC_BIT_BUS]     bit_out
);

wire [`LLR_INTERNAL_LEN+4-1:0] llr_arr  [`PROCESS_UNIT_LLR_NUM-1:0];
wire [`LLR_INTERNAL_LEN+4-1:0] llr_abs  [`PROCESS_UNIT_LLR_NUM-1:0];
wire [`FUNC_SPC_BIT_BUS]     bit_tmp;
wire bit_sum;
wire [3:0] index;

wire [`LLR_INTERNAL_LEN+4-1:0] llr_abs_min_s1 [`PROCESS_UNIT_LLR_NUM/2-1:0];
wire [`LLR_INTERNAL_LEN+4-1:0] llr_abs_min_s2 [`PROCESS_UNIT_LLR_NUM/4-1:0];
wire [`LLR_INTERNAL_LEN+4-1:0] llr_abs_min_s3 [`PROCESS_UNIT_LLR_NUM/8-1:0];
wire [`LLR_INTERNAL_LEN+4-1:0] llr_abs_min_s4;

wire [3:0] mem2[15:0];
assign mem2[0 ] = 4'd0 ;
assign mem2[1 ] = 4'd1 ;
assign mem2[2 ] = 4'd2 ;
assign mem2[3 ] = 4'd3 ;
assign mem2[4 ] = 4'd4 ;
assign mem2[5 ] = 4'd5 ;
assign mem2[6 ] = 4'd6 ;
assign mem2[7 ] = 4'd7 ;
assign mem2[8 ] = 4'd8 ;
assign mem2[9 ] = 4'd9 ;
assign mem2[10] = 4'd10;
assign mem2[11] = 4'd11;
assign mem2[12] = 4'd12;
assign mem2[13] = 4'd13;
assign mem2[14] = 4'd14;
assign mem2[15] = 4'd15;

generate
    genvar i;
    for(i = 0; i < `PROCESS_UNIT_LLR_NUM; i = i+1) begin : gen_scale
        assign llr_arr[i] = {mem2[i],llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-i*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN]};
        assign bit_tmp[`PROCESS_UNIT_LLR_NUM-i-1] = llr_arr[i][`LLR_INTERNAL_LEN-1];
        assign llr_abs[i] = (llr_arr[i][`LLR_INTERNAL_LEN-1]) ? {mem2[i],(~llr_arr[i][`LLR_INTERNAL_LEN-1:0])+1'b1} : llr_arr[i];
    end
endgenerate

assign llr_abs_min_s1[0] = llr_abs[0 ][`LLR_INTERNAL_LEN-1:0] > llr_abs[1][`LLR_INTERNAL_LEN-1:0]  ? llr_abs[1 ] : llr_abs[0 ];
assign llr_abs_min_s1[1] = llr_abs[2 ][`LLR_INTERNAL_LEN-1:0] > llr_abs[3][`LLR_INTERNAL_LEN-1:0]  ? llr_abs[3 ] : llr_abs[2 ];
assign llr_abs_min_s1[2] = llr_abs[4 ][`LLR_INTERNAL_LEN-1:0] > llr_abs[5][`LLR_INTERNAL_LEN-1:0]  ? llr_abs[5 ] : llr_abs[4 ];
assign llr_abs_min_s1[3] = llr_abs[6 ][`LLR_INTERNAL_LEN-1:0] > llr_abs[7][`LLR_INTERNAL_LEN-1:0]  ? llr_abs[7 ] : llr_abs[6 ];
assign llr_abs_min_s1[4] = llr_abs[8 ][`LLR_INTERNAL_LEN-1:0] > llr_abs[9][`LLR_INTERNAL_LEN-1:0]  ? llr_abs[9 ] : llr_abs[8 ];
assign llr_abs_min_s1[5] = llr_abs[10][`LLR_INTERNAL_LEN-1:0] > llr_abs[11][`LLR_INTERNAL_LEN-1:0] ? llr_abs[11] : llr_abs[10];
assign llr_abs_min_s1[6] = llr_abs[12][`LLR_INTERNAL_LEN-1:0] > llr_abs[13][`LLR_INTERNAL_LEN-1:0] ? llr_abs[13] : llr_abs[12];
assign llr_abs_min_s1[7] = llr_abs[14][`LLR_INTERNAL_LEN-1:0] > llr_abs[15][`LLR_INTERNAL_LEN-1:0] ? llr_abs[15] : llr_abs[14];

assign llr_abs_min_s2[0] = llr_abs_min_s1[0][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s1[1][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s1[1] : llr_abs_min_s1[0];
assign llr_abs_min_s2[1] = llr_abs_min_s1[2][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s1[3][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s1[3] : llr_abs_min_s1[2];
assign llr_abs_min_s2[2] = llr_abs_min_s1[4][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s1[5][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s1[5] : llr_abs_min_s1[4];
assign llr_abs_min_s2[3] = llr_abs_min_s1[6][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s1[7][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s1[7] : llr_abs_min_s1[6];

assign llr_abs_min_s3[0] = llr_abs_min_s2[0][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s2[1][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s2[1] : llr_abs_min_s2[0];
assign llr_abs_min_s3[1] = llr_abs_min_s2[2][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s2[3][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s2[3] : llr_abs_min_s2[2];

assign llr_abs_min_s4 = llr_abs_min_s3[0][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s3[1][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s3[1] : llr_abs_min_s3[0];
assign index = llr_abs_min_s4[`LLR_INTERNAL_LEN+4-1:`LLR_INTERNAL_LEN];

assign bit_sum = ^bit_tmp;

assign bit_out = bit_sum == 0 ? bit_tmp : 
    (bit_tmp[15-index] == 0 ? bit_tmp + (1<<(15-index)) : bit_tmp & (~(1<<(15-index))));

endmodule
