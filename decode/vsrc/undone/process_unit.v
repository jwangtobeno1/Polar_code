//======================================================
//Filename                : .v
//Author                  : WangJie
//Created On              : 2022-12-04 16:58
//Last Modified           : 
//Description             : 
//                          
//======================================================

`include "defines.v"

module process_unit
(
    input   wire    [`PROCESS_UNIT_LLR_BUS] llr,
    input   wire    [`BIT_K - 1 : 0]    b_1,
    input   wire    [`BIT_K - 1 : 0]    b_2,

    input   wire    [`INST_BUS]         inst,

    output  reg     [`BIT_N - 1 : 0]    bit_combine,
    output  reg     [`BIT_K - 1 : 0]    b_out,
    output  reg     [`PROCESS_UNIT_LLR_BUS] llr_out
);

wire [`INST_OPCODE_BUS] inst_opcode;
wire [`FUNC_G_BIT_BUS] func_g_bit;

assign inst_opcode = inst[`INST_OP_LOCATION];

always @(*) begin
    case(inst_opcode):
        `FUNC_F: begin

        end
    endcase
end



endmodule

