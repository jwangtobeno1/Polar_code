//======================================================
//Filename                : func_spc.v
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
`include "defines.v"

module func_spc(
    input   wire    [`PROCESS_UNIT_LLR_BUS] llr,
    output  wire    [`FUNC_SPC_BIT_BUS]     bit_out
);

reg  [`LLR_INTERNAL_LEN+4-1:0] llr_arr  [`PROCESS_UNIT_LLR_NUM-1:0];
wire [`LLR_INTERNAL_LEN+4-1:0] llr_abs  [`PROCESS_UNIT_LLR_NUM-1:0];
reg  [`FUNC_SPC_BIT_BUS]     bit_tmp;
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

always@(*) begin
    llr_arr[15] = {mem2[15],llr[95:90]};
    llr_arr[14] = {mem2[14],llr[89:84]};
    llr_arr[13] = {mem2[13],llr[83:78]};
    llr_arr[12] = {mem2[12],llr[77:72]};
    llr_arr[11] = {mem2[11],llr[71:66]};
    llr_arr[10] = {mem2[10],llr[65:60]};
    llr_arr[ 9] = {mem2[ 9],llr[59:54]};
    llr_arr[ 8] = {mem2[ 8],llr[53:48]};
    llr_arr[ 7] = {mem2[ 7],llr[47:42]};
    llr_arr[ 6] = {mem2[ 6],llr[41:36]};
    llr_arr[ 5] = {mem2[ 5],llr[35:30]};
    llr_arr[ 4] = {mem2[ 4],llr[29:24]};
    llr_arr[ 3] = {mem2[ 3],llr[23:18]};
    llr_arr[ 2] = {mem2[ 2],llr[17:12]};
    llr_arr[ 1] = {mem2[ 1],llr[11:6]};
    llr_arr[ 0] = {mem2[ 0],llr[5:0]};
    bit_tmp = {llr[95],llr[89],llr[83],llr[77],llr[71],llr[65],llr[59],llr[53],llr[47],llr[41],llr[35],llr[29],llr[23],llr[17],llr[11],llr[5]};
end

generate
    genvar i;
    for(i = 0; i < `PROCESS_UNIT_LLR_NUM; i = i+1) begin : gen_scale
        /* assign llr_arr[i] = {mem2[i],llr[(`PROCESS_UNIT_LLR_NUM*`LLR_INTERNAL_LEN-i*`LLR_INTERNAL_LEN)-1 -:`LLR_INTERNAL_LEN]}; */
        /* assign bit_tmp[`PROCESS_UNIT_LLR_NUM-i-1] = llr_arr[i][`LLR_INTERNAL_LEN-1]; */
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

assign llr_abs_min_s3[0] = |(llr[95:24]) ?
    (llr_abs_min_s2[0][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s2[1][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s2[1] : llr_abs_min_s2[0]) : 
    llr_abs_min_s2[0];
assign llr_abs_min_s3[1] = llr_abs_min_s2[2][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s2[3][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s2[3] : llr_abs_min_s2[2];

//if llr[95:48] == 48'b0 => SPC_8 => s4 = s3[0]
assign llr_abs_min_s4 = |(llr[95:48]) ? 
    (llr_abs_min_s3[0][`LLR_INTERNAL_LEN-1:0] > llr_abs_min_s3[1][`LLR_INTERNAL_LEN-1:0] ? llr_abs_min_s3[1] : llr_abs_min_s3[0]) :
    llr_abs_min_s3[0];

assign index = llr_abs_min_s4[`LLR_INTERNAL_LEN+4-1:`LLR_INTERNAL_LEN];

assign bit_sum = ^bit_tmp;

assign bit_out = bit_sum == 0 ? bit_tmp : 
    (bit_tmp[index] == 0 ? bit_tmp + (1<<index) : bit_tmp & (~(1<<index)));
    /* (bit_tmp[15-index] == 0 ? bit_tmp + (1<<(15-index)) : bit_tmp & (~(1<<(15-index)))); */

endmodule
