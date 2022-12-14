//======================================================
//Filename                : process_unit.v
//Author                  : WangJie
//Created On              : 2022-12-04 16:58
//Last Modified           : 2022-12-13 21:54
//Description             : 
//                          
//======================================================

`include "defines.v"

module process_unit
(
    input   wire    [`PROCESS_UNIT_LLR_BUS]     llr_in,
    input   wire    [`BIT_K - 1 : 0]            bit_comb_left,
    input   wire    [`BIT_K - 1 : 0]            bit_comb_right,
    input   wire    [`FUNC_G_BIT_BUS]           funcg_bit_in,

    input   wire    [`PU_INST_BUS]                 inst,

    output  reg     [2:0]                       mem_wr_en,//[llr,bit,comb]
    output  reg     [`PROCESS_UNIT_BIT_BUS]     bit_out,
    output  wire    [`PROCESS_UNIT_LLR_OUT_BUS] llr_out,
    output  wire    [`BIT_N - 1 : 0]            bit_comb_out
);

wire [`PU_OPCODE_BUS] inst_opcode;
wire [`INST_STAGE_BUS]  stage;

wire [`FUNC_G_BIT_BUS]  funcg_bit_in_reg;
/* func_fg.v */
reg  [0:0] flag_fg;

wire    [`PROCESS_UNIT_BIT_BUS] bout_rep;
wire    [`PROCESS_UNIT_BIT_BUS] bout_spc;
wire    [`PROCESS_UNIT_BIT_BUS] bout_rate1;
wire    [`FUNC_TYPE_BIT_BUS] bout_type1;
wire    [`FUNC_TYPE_BIT_BUS] bout_type3;

assign inst_opcode = inst[`PU_OP_LOCATION];
assign stage = inst[`INST_STAGE_LOCATION];

assign funcg_bit_in_reg = (inst_opcode[3]&inst_opcode[0]) ? 8'b0 : funcg_bit_in;

always @(*) begin
    case(inst_opcode)
        `FUNC_F: begin
            bit_out = 16'b0;
            flag_fg = 1'b1;
            mem_wr_en = 3'b100;
        end
        `FUNC_G, `FUNC_G0R: begin
            bit_out = 16'b0;
            flag_fg = 1'b0;
            mem_wr_en = 3'b100;
        end
        `FUNC_REP: begin
            bit_out = bout_rep;
            flag_fg = 1'b0;
            mem_wr_en = 3'b010;
        end
        `FUNC_SPC: begin
            bit_out = bout_spc;
            flag_fg = 1'b0;
            mem_wr_en = 3'b010;
        end
        `FUNC_RATE0: begin
            bit_out = 16'd0;
            flag_fg = 1'b0;
            mem_wr_en = 3'b010;
        end
        `FUNC_RATE1: begin
            bit_out = bout_rate1;
            flag_fg = 1'b0;
            mem_wr_en = 3'b010;
        end
        `FUNC_TYPE1: begin
            bit_out = {8'd0,bout_type1};    
            flag_fg = 1'b0;
            mem_wr_en = 3'b010;
        end
        `FUNC_TYPE3: begin
            bit_out = {8'd0,bout_type3};
            flag_fg = 1'b0;
            mem_wr_en = 3'b010;
        end
        `BIT_COMBINE, `BIT_COMBINE_0R: begin
            bit_out = 16'b0;
            flag_fg = 1'b0;
            mem_wr_en = 3'b001;
        end
        default : begin 
            bit_out = 16'd0;
            flag_fg = 1'b0;
            mem_wr_en = 3'b000;
        end
    endcase
end

bit_combine bit_comb_inst(
    .bit_left_in    (bit_comb_left),
    .bit_right_in   (bit_comb_right),
    .stage          (stage),
    .bit_out        (bit_comb_out)
);

func_fg func_fg_inst(
    .llr     (llr_in),   //96bit
    .bit_in  (funcg_bit_in_reg),   //8bit
    .flag_fg (flag_fg),   //1 -> f;   0 -> g;
    .llr_out (llr_out)   //48bit
);

func_rate1 func_rate1_inst(
    .llr(llr_in),
    .bit_out(bout_rate1) //[15:0] same with spc!
);

func_rep func_rep_inst(
    .llr(llr_in),
    .bit_out(bout_rep)
);

func_spc func_spc_inst(
    .llr(llr_in),
    .bit_out(bout_spc)
);

func_type1 func_type1_inst(
    .llr(llr_in),
    .bit_out(bout_type1)
);

func_type3 func_type3_inst(
    .llr(llr_in),
    .bit_out(bout_type3)
);

endmodule

