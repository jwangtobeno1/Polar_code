//======================================================
//Filename                : func_fg.v
//Author                  : WangJie
//Created On              : 2022-11-15 10:34
//Last Modified           : 
//Description             : 
//      function f and function g
//      if flag == 1'b1 : function_f
//      else            : function_g
//======================================================

module func_fg(
    input signed [11:0] llr_a,
    input signed [11:0] llr_b,
    input   wire        f_flag,
    input   wire        s, //g_function = (1-2s)llr_a+llr_b
    output  signed [11:0]   dout
);

wire    [11:0]  abs_a;
wire    [11:0]  abs_b;
wire    [11:0]  min_abs;
wire    [11:0]  min;

wire signed [12:0] sum_ab;
wire signed [11:0] sum;
wire signed [12:0] sub_ab;
wire signed [11:0] sub;

wire signed [11:0] f_res;
wire signed [11:0] g_res;

//f函数
assign abs_a = (llr_a[11]) ? {(~llr_a[11:4])+1'b1,llr_a[3:0]} : llr_a;
assign abs_b = (llr_b[11]) ? {(~llr_b[11:4])+1'b1,llr_b[3:0]} : llr_b;
assign min_abs = (abs_a > abs_b) ? abs_b : abs_a; //正数
assign min = (llr_a[11]^llr_b[11]) ? {~(min_abs[11:4])+1'b1,min_abs[3:0]} : min_abs;//补码
assign f_res = {llr_a[11]^llr_b[11],min[10:0]};

//g函数
assign sum_ab = llr_b + llr_a;
assign sum = g_func(sum_ab);
assign sub_ab = llr_b - llr_a;
assign sub = g_func(sub_ab);

function [11:0] g_func(input [12:0] tmp);
    begin
        case(tmp[12:11])
            2'b01 : g_func = {{8'b0111_1111},tmp[3:0]};
            2'b10 : g_func = {{8'b1000_0000},tmp[3:0]};
            default : g_func = tmp[11:0];
        endcase
    end
endfunction 

assign g_res = (s) ? sub : sum;

assign dout = (f_flag) ? f_res : g_res;

endmodule
