//======================================================
//Filename                : func_fg.v
//Author                  : WangJie
//Created On              : 2022-12-04 22:25
//Last Modified           : 
//Description             : 
//                          
//======================================================
`include "defines.v"

module func_fg(
    input   wire    [`PROCESS_UNIT_LLR_BUS]     llr,
    input   wire    [`FUNC_G_BIT_LEN-1:0]       bit_in,
    input   wire                                flag_fg,  //1 -> f;   0 -> g;
    output  wire    [`PORCESS_UNIT_LLR_OUT_BUS]    llr_out
);

wire [`LLR_INTERNAL_LEN-1:0] llr_arr  [`PROCESS_UNIT_LLR_NUM-1:0];
wire [`LLR_INTERNAL_LEN-1:0] dout_arr [`FUNC_G_BIT_LEN-1:0];
wire [0:0]                   s_arr    [`FUNC_G_BIT_LEN-1:0];

generate
    genvar i;
    for(i = 0; i < `PROCESS_UNIT_LLR_NUM; i = i+1) begin : gen_scale
        assign llr_arr[i] = llr[i*`LLR_INTERNAL_LEN+:`LLR_INTERNAL_LEN];
    end
endgenerate

generate
    genvar s_i;
    for(s_i=0; s_i < `FUNC_G_BIT_LEN; s_i = s_i+1) begin : gen_si
        assign s_arr[s_i] = bit_in[s_i:s_i];
    end
endgenerate

generate
    genvar j;
    for(j = 0; j < `PROCESS_UNIT_LLR_NUM; j = j+2) begin : gen_scale_j
        pe pe_inst_j(
            .llr_a(llr_arr[j]),
            .llr_b(llr_arr[j+1]),
            .flag(flag_fg),
            .s(s_arr[j/2]),
            .dout(dout_arr[j/2])
        );
    end
endgenerate

assign llr_out = {dout_arr[7],dout_arr[6],dout_arr[5],dout_arr[4],dout_arr[3],dout_arr[2],dout_arr[1],dout_arr[0]};

endmodule
