//======================================================
//Filename                : pe.v
//Author                  : WangJie
//Created On              : 2022-11-15 10:34
//Last Modified           : 
//Description             : 
//      function f and function g
//      if flag == 1'b1 : function_f
//      else            : function_g
//======================================================

// LLR_INTERNAL_LEN = 6
`include "defines.v"

module pe(
    input signed [`LLR_INTERNAL_LEN-1:0] llr_a,
    input signed [`LLR_INTERNAL_LEN-1:0] llr_b,
    input   wire        flag,
    input   wire        s, //g_function = (1-2s)llr_a+llr_b
    output  signed [`LLR_INTERNAL_LEN-1:0]   dout
);

wire    [`LLR_INTERNAL_LEN-1:0]  abs_a;
wire    [`LLR_INTERNAL_LEN-1:0]  abs_b;
wire    [`LLR_INTERNAL_LEN-1:0]  min_abs;
wire    [`LLR_INTERNAL_LEN-1:0]  min;

wire signed [`LLR_INTERNAL_LEN:0] sum_ab;
wire signed [`LLR_INTERNAL_LEN-1:0] sum;
wire signed [`LLR_INTERNAL_LEN:0] sub_ab;
wire signed [`LLR_INTERNAL_LEN-1:0] sub;

wire signed [`LLR_INTERNAL_LEN-1:0] f_res;
wire signed [`LLR_INTERNAL_LEN-1:0] g_res;

//f函数
assign abs_a = (llr_a[`LLR_INTERNAL_LEN-1]) ? {(~llr_a)+1'b1} : llr_a;
assign abs_b = (llr_b[`LLR_INTERNAL_LEN-1]) ? {(~llr_b)+1'b1} : llr_b;
assign min_abs = (abs_a > abs_b) ? abs_b : abs_a; //正数
assign min = (llr_a[`LLR_INTERNAL_LEN-1]^llr_b[`LLR_INTERNAL_LEN-1]) ? {~(min_abs)+1'b1} : min_abs;//补码
/* assign f_res = {llr_a[`LLR_INTERNAL_LEN-1]^llr_b[`LLR_INTERNAL_LEN-1],min[`LLR_INTERNAL_LEN-2:0]}; */
assign f_res = min;

//g函数
assign sum_ab = llr_b + llr_a;
assign sum = g_func(sum_ab);
assign sub_ab = llr_b - llr_a;
assign sub = g_func(sub_ab);

function [`LLR_INTERNAL_LEN-1:0] g_func(input [`LLR_INTERNAL_LEN:0] tmp);
    begin
        case(tmp[`LLR_INTERNAL_LEN : `LLR_INTERNAL_LEN-1])
            2'b01 : g_func = {6'b01_1111};
            2'b10 : g_func = {6'b10_0000};
            default : g_func = tmp[`LLR_INTERNAL_LEN-1:0];
        endcase
    end
endfunction 

assign g_res = (s) ? sub : sum;

assign dout = (flag) ? f_res : g_res;

endmodule
