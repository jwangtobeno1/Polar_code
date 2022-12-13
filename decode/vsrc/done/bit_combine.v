//======================================================
//Filename                : bit_combine.v
//Author                  : WangJie
//Created On              : 2022-12-12 19:54
//Last Modified           : 
//Description             : 
//
// bit_combine according to stage;
//                          
//======================================================
`include "defines.v"

module bit_combine(
    input   wire    [127:0] bit_left_in,
    input   wire    [127:0] bit_right_in,
    input   wire    [2:0]   stage,

    output  reg     [255:0] bit_out
);

always@(*) begin

    case(stage)//synopsys full_case
        `COMB4TO8: begin
            bit_out[3:0] = bit_right_in[3:0];
            bit_out[7:4] = bit_left_in[3:0] ^ bit_right_in[3:0];
            bit_out[255:8] = 248'd0;
        end
        `COMB8TO16: begin
            bit_out[7:0] = bit_right_in[7:0];
            bit_out[15:8] = bit_left_in[7:0] ^ bit_right_in[7:0];
            bit_out[255:16] = 240'd0;
        end
        `COMB16TO32: begin
            bit_out[15:0] = bit_right_in[15:0];
            bit_out[31:16] = bit_left_in[15:0] ^ bit_right_in[15:0];
            bit_out[255:32] = 224'd0;
        end
        `COMB32TO64: begin
            bit_out[31:0] = bit_right_in[31:0];
            bit_out[63:32] = bit_left_in[31:0] ^ bit_right_in[31:0];
            bit_out[255:64] = 192'd0;
        end
        `COMB64TO128: begin
            bit_out[63:0] = bit_right_in[63:0];
            bit_out[127:64] = bit_left_in[63:0] ^ bit_right_in[63:0];
            bit_out[255:128] = 128'd0;
        end
        `COMB128TO256: begin
            bit_out[127:0] = bit_right_in[127:0];
            bit_out[255:128] = bit_left_in[127:0] ^ bit_right_in[127:0];
        end
        default:    bit_out = 256'd0;
    endcase
end

endmodule
