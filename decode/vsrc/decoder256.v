//======================================================
//Filename                : decoder256.v
//Author                  : WangJie
//Created On              : 2022-12-13 21:54
//Last Modified           : 2022-12-21 15:45
//Description             : 
//
//Polar Decoder : 
//  Code length : 256; Rate : 0.5;
//  Decode method : Fast Sc decode
//  Child_Code : func_spc,func_rep,func_rate1,func_type1,func_type3
//  
//  Decode step by step according to the instructions; './inst.txt'
//                          
//======================================================
`include "defines.v"

module decoder256(
    input   wire            clk,
    input   wire            rst_n,

    input   wire    [95:0]  llr_in,
    input   wire            work_en,
    output  reg     [127:0] bit_out
);

wire [`INST_BUS] inst;
reg [`PU_INST_BUS]   inst_tmp;

reg [95:0]  llr_mem256  [15:0];
reg [47:0]  llr_mem128  [15:0];
reg [47:0]  llr_mem64   [7:0];
reg [47:0]  llr_mem32   [3:0];
reg [47:0]  llr_mem16   [1:0];
reg [47:0]  llr_mem8;
reg [23:0]  llr_mem4;

reg [255:0] bit_mem256;
reg [7:0] bit_mem128[1:0][15:0];
reg [7:0] bit_mem64[1:0][7:0];
reg [7:0] bit_mem32[1:0][3:0];
reg [7:0] bit_mem16[1:0][1:0];
reg [7:0] bit_mem8[1:0];
reg [3:0] bit_mem4[1:0];

reg [95:0]  llr_in_tmp;
reg [7:0]   bit_in_tmp;
reg [127:0] bit_comb_left_tmp;
reg [127:0] bit_comb_right_tmp;
reg [47:0]  llr_out_tmp;
reg [255:0] bit_comb_out_tmp;
reg [15:0]  bit_out_tmp;
wire [2:0]  mem_wr_en;
reg         mem_en; //read inst
reg [7:0]   cnt_inst;

localparam  IDLE        =   4'b0001,
            LOAD_LLR    =   4'b0010,
            DECODE      =   4'b0100,
            BIT_OUT     =   4'b1000;

localparam  FETCH = 3'b001,
            EXEC  = 3'b010,
            STORE = 3'b100;

reg [3:0]   cur_state;
reg [3:0]   next_state;
reg         decode_en;
reg         decode_done;
reg [2:0]   decode_state;
reg         sw_en;

reg [4:0]   cnt_16;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cur_state <= IDLE;
    else
        cur_state <= next_state;
end

always@(*) begin
    next_state = IDLE;
    case(cur_state)
        IDLE :      if(sw_en)
                        next_state = LOAD_LLR;
                    else
                        next_state = IDLE;
        LOAD_LLR :  if(sw_en)
                        next_state = DECODE;
                    else
                        next_state = LOAD_LLR;
        DECODE :    if(sw_en)
                        next_state = BIT_OUT;
                    else
                        next_state = DECODE;
        BIT_OUT : next_state = IDLE;
        default : next_state = IDLE;
    endcase
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sw_en <= 1'b0;
        cnt_16 <= 5'd0;
        mem_en <= 1'b0;
    end
    else begin
        sw_en <= 1'b0;
        decode_done <= 1'b0;
        case(next_state)
            IDLE: begin
                if(work_en)
                    sw_en <= 1'b1;
                else
                    sw_en <= 1'b0;
            end
            LOAD_LLR: begin
                if(cnt_16 == 5'd16) begin
                    sw_en <= 1'b1;
                    cnt_16 <= 5'd0;
                end
                else begin
                    cnt_16 <= cnt_16 + 1'b1;
                    llr_mem256[15-cnt_16] <= llr_in;
                end
            end
            DECODE: begin
                if(cnt_inst == (`CNT_INST_MAX-1'b1) && (decode_state == 3'b100)) begin
                    cnt_inst <= 8'd0;
                    sw_en <= 1'b1;
                    decode_en <= 1'b0;
                    mem_en <= 1'b0;
                end 
                else begin
                    decode_en <= 1'b1;
                    mem_en <= 1'b1;
                end
            end
            BIT_OUT : begin
                decode_done <= 1'b1;
            end
            default : begin
                sw_en <= 1'b0;
            end
        endcase
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        decode_state <= 3'b001;
    end
    else if(decode_en) begin
        case(decode_state)
            FETCH: begin
                decode_state <= EXEC;
                inst_tmp <= inst[7:0];
                case(inst[3:1])
                    `COMB128TO256 : begin
                        llr_in_tmp <= llr_mem256[inst[11:8]];
                        bit_in_tmp <= bit_mem128[inst[0]][inst[11:8]];
                        bit_comb_left_tmp <= {bit_mem128[1][15],bit_mem128[1][14],bit_mem128[1][13],bit_mem128[1][12],bit_mem128[1][11],bit_mem128[1][10],bit_mem128[1][9],bit_mem128[1][8],bit_mem128[1][7],bit_mem128[1][6],bit_mem128[1][5],bit_mem128[1][4],bit_mem128[1][3],bit_mem128[1][2],bit_mem128[1][1],bit_mem128[1][0]};
                        bit_comb_right_tmp <= {bit_mem128[0][15],bit_mem128[0][14],bit_mem128[0][13],bit_mem128[0][12],bit_mem128[0][11],bit_mem128[0][10],bit_mem128[0][9],bit_mem128[0][8],bit_mem128[0][7],bit_mem128[0][6],bit_mem128[0][5],bit_mem128[0][4],bit_mem128[0][3],bit_mem128[0][2],bit_mem128[0][1],bit_mem128[0][0]};
                    end
                    `COMB64TO128 : begin //100
                        llr_in_tmp <= {llr_mem128[inst[11:8]],llr_mem128[inst[11:8]-1'b1]};
                        bit_in_tmp <= bit_mem64[inst[0]][inst[11:9]];
                        bit_comb_left_tmp <= {64'b0,bit_mem64[1][7],bit_mem64[1][6],bit_mem64[1][5],bit_mem64[1][4],bit_mem64[1][3],bit_mem64[1][2],bit_mem64[1][1],bit_mem64[1][0]};
                        bit_comb_right_tmp <= {64'b0,bit_mem64[0][7],bit_mem64[0][6],bit_mem64[0][5],bit_mem64[0][4],bit_mem64[0][3],bit_mem64[0][2],bit_mem64[0][1],bit_mem64[0][0]};
                    end
                    `COMB32TO64 : begin //011
                        llr_in_tmp <= {llr_mem64[inst[10:8]],llr_mem64[inst[10:8]-1'b1]};
                        bit_in_tmp<= bit_mem32[inst[0]][inst[10:9]];
                        if(inst[7]&inst[6])
                            bit_comb_left_tmp <= 128'b0;
                        else
                            bit_comb_left_tmp <= {96'b0,bit_mem32[1][3],bit_mem32[1][2],bit_mem32[1][1],bit_mem32[1][0]};
                        bit_comb_right_tmp <= {96'b0,bit_mem32[0][3],bit_mem32[0][2],bit_mem32[0][1],bit_mem32[0][0]};
                    end
                    `COMB16TO32 : begin //010
                        llr_in_tmp <= {llr_mem32[inst[9:8]],llr_mem32[inst[9:8]-1'b1]};
                        bit_in_tmp<= bit_mem16[inst[0]][inst[9]];
                        if(inst[7]&inst[6])
                            bit_comb_left_tmp <= 128'b0;
                        else
                            bit_comb_left_tmp <= {112'b0,bit_mem16[1][1],bit_mem16[1][0]};
                        bit_comb_right_tmp <= {112'b0,bit_mem16[0][1],bit_mem16[0][0]};
                    end
                    `COMB8TO16 : begin //001
                        case(inst[7:4]) 
                            4'b0011: llr_in_tmp <= {llr_mem16[1][47:42],llr_mem16[0][47:42],llr_mem16[1][23:18],llr_mem16[0][23:18],llr_mem16[1][35:30],llr_mem16[0][35:30],llr_mem16[1][11:6],llr_mem16[0][11:6],llr_mem16[1][41:36],llr_mem16[0][41:36],llr_mem16[1][17:12],llr_mem16[0][17:12],llr_mem16[1][29:24],llr_mem16[0][29:24],llr_mem16[1][5:0],llr_mem16[0][5:0]};
                            default:llr_in_tmp <= {llr_mem16[1],llr_mem16[0]};
                        endcase
                        bit_in_tmp <= {bit_mem8[inst[0]][7],bit_mem8[inst[0]][3],bit_mem8[inst[0]][5],bit_mem8[inst[0]][1],bit_mem8[inst[0]][6],bit_mem8[inst[0]][2],bit_mem8[inst[0]][4],bit_mem8[inst[0]][0]};
                        bit_comb_left_tmp <= {120'b0,bit_mem8[1]};
                        bit_comb_right_tmp <= {120'b0,bit_mem8[0]};
                    end
                    `COMB4TO8 : begin //000
                        case(inst[7:4])
                            4'b0011,4'b0110,4'b0111: llr_in_tmp <= {48'b0,llr_mem8[47:42],llr_mem8[23:18],llr_mem8[35:30],llr_mem8[11:6],llr_mem8[41:36],llr_mem8[17:12],llr_mem8[29:24],llr_mem8[5:0]};
                            default: llr_in_tmp <= {48'b0,llr_mem8};
                        endcase
                        bit_in_tmp <= {4'b0,bit_mem4[inst[0]][3],bit_mem4[inst[0]][1],bit_mem4[inst[0]][2],bit_mem4[inst[0]][0]};
                        bit_comb_left_tmp <= {124'b0,bit_mem4[1]};
                        bit_comb_right_tmp <= {124'b0,bit_mem4[0]};
                    end
                    `COMB2TO4: begin //110
                        case(inst[7:4])
                            4'b0011: llr_in_tmp <= {72'b0,llr_mem4[23:18],llr_mem4[11:6],llr_mem4[17:12],llr_mem4[5:0]};
                            default: llr_in_tmp <= {72'b0,llr_mem4};
                        endcase
                        bit_in_tmp <= 8'b0;
                        bit_comb_left_tmp <= {128'b0};
                        bit_comb_right_tmp <= {128'b0};
                    end
                    default : begin
                        llr_in_tmp <= 96'b0;
                        bit_in_tmp <= 8'b0;
                        bit_comb_left_tmp <= 128'b0;
                        bit_comb_right_tmp <= 128'b0;
                    end
                endcase
            end
            EXEC : begin
                /* exec_en <= 1'b1; */
                if(inst[3:1] == 3'd7) begin
                    case(inst[7:4])
                        //128bit reverse
                        4'b1000 : {bit_mem128[inst[0]][15],bit_mem128[inst[0]][14],bit_mem128[inst[0]][13],bit_mem128[inst[0]][12],bit_mem128[inst[0]][11],bit_mem128[inst[0]][10],bit_mem128[inst[0]][9],bit_mem128[inst[0]][8],bit_mem128[inst[0]][7],bit_mem128[inst[0]][6],bit_mem128[inst[0]][5],bit_mem128[inst[0]][4],bit_mem128[inst[0]][3],bit_mem128[inst[0]][2],bit_mem128[inst[0]][1],bit_mem128[inst[0]][0]} <= {bit_mem128[inst[0]][15][7],bit_mem128[inst[0]][7][7],bit_mem128[inst[0]][11][7],bit_mem128[inst[0]][3][7],bit_mem128[inst[0]][13][7],bit_mem128[inst[0]][5][7],bit_mem128[inst[0]][9][7],bit_mem128[inst[0]][1][7],bit_mem128[inst[0]][14][7],bit_mem128[inst[0]][6][7],bit_mem128[inst[0]][10][7],bit_mem128[inst[0]][2][7],bit_mem128[inst[0]][12][7],bit_mem128[inst[0]][4][7],bit_mem128[inst[0]][8][7],bit_mem128[inst[0]][0][7],bit_mem128[inst[0]][15][3],bit_mem128[inst[0]][7][3],bit_mem128[inst[0]][11][3],bit_mem128[inst[0]][3][3],bit_mem128[inst[0]][13][3],bit_mem128[inst[0]][5][3],bit_mem128[inst[0]][9][3],bit_mem128[inst[0]][1][3],bit_mem128[inst[0]][14][3],bit_mem128[inst[0]][6][3],bit_mem128[inst[0]][10][3],bit_mem128[inst[0]][2][3],bit_mem128[inst[0]][12][3],bit_mem128[inst[0]][4][3],bit_mem128[inst[0]][8][3],bit_mem128[inst[0]][0][3],bit_mem128[inst[0]][15][5],bit_mem128[inst[0]][7][5],bit_mem128[inst[0]][11][5],bit_mem128[inst[0]][3][5],bit_mem128[inst[0]][13][5],bit_mem128[inst[0]][5][5],bit_mem128[inst[0]][9][5],bit_mem128[inst[0]][1][5],bit_mem128[inst[0]][14][5],bit_mem128[inst[0]][6][5],bit_mem128[inst[0]][10][5],bit_mem128[inst[0]][2][5],bit_mem128[inst[0]][12][5],bit_mem128[inst[0]][4][5],bit_mem128[inst[0]][8][5],bit_mem128[inst[0]][0][5],bit_mem128[inst[0]][15][1],bit_mem128[inst[0]][7][1],bit_mem128[inst[0]][11][1],bit_mem128[inst[0]][3][1],bit_mem128[inst[0]][13][1],bit_mem128[inst[0]][5][1],bit_mem128[inst[0]][9][1],bit_mem128[inst[0]][1][1],bit_mem128[inst[0]][14][1],bit_mem128[inst[0]][6][1],bit_mem128[inst[0]][10][1],bit_mem128[inst[0]][2][1],bit_mem128[inst[0]][12][1],bit_mem128[inst[0]][4][1],bit_mem128[inst[0]][8][1],bit_mem128[inst[0]][0][1],bit_mem128[inst[0]][15][6],bit_mem128[inst[0]][7][6],bit_mem128[inst[0]][11][6],bit_mem128[inst[0]][3][6],bit_mem128[inst[0]][13][6],bit_mem128[inst[0]][5][6],bit_mem128[inst[0]][9][6],bit_mem128[inst[0]][1][6],bit_mem128[inst[0]][14][6],bit_mem128[inst[0]][6][6],bit_mem128[inst[0]][10][6],bit_mem128[inst[0]][2][6],bit_mem128[inst[0]][12][6],bit_mem128[inst[0]][4][6],bit_mem128[inst[0]][8][6],bit_mem128[inst[0]][0][6],bit_mem128[inst[0]][15][2],bit_mem128[inst[0]][7][2],bit_mem128[inst[0]][11][2],bit_mem128[inst[0]][3][2],bit_mem128[inst[0]][13][2],bit_mem128[inst[0]][5][2],bit_mem128[inst[0]][9][2],bit_mem128[inst[0]][1][2],bit_mem128[inst[0]][14][2],bit_mem128[inst[0]][6][2],bit_mem128[inst[0]][10][2],bit_mem128[inst[0]][2][2],bit_mem128[inst[0]][12][2],bit_mem128[inst[0]][4][2],bit_mem128[inst[0]][8][2],bit_mem128[inst[0]][0][2],bit_mem128[inst[0]][15][4],bit_mem128[inst[0]][7][4],bit_mem128[inst[0]][11][4],bit_mem128[inst[0]][3][4],bit_mem128[inst[0]][13][4],bit_mem128[inst[0]][5][4],bit_mem128[inst[0]][9][4],bit_mem128[inst[0]][1][4],bit_mem128[inst[0]][14][4],bit_mem128[inst[0]][6][4],bit_mem128[inst[0]][10][4],bit_mem128[inst[0]][2][4],bit_mem128[inst[0]][12][4],bit_mem128[inst[0]][4][4],bit_mem128[inst[0]][8][4],bit_mem128[inst[0]][0][4],bit_mem128[inst[0]][15][0],bit_mem128[inst[0]][7][0],bit_mem128[inst[0]][11][0],bit_mem128[inst[0]][3][0],bit_mem128[inst[0]][13][0],bit_mem128[inst[0]][5][0],bit_mem128[inst[0]][9][0],bit_mem128[inst[0]][1][0],bit_mem128[inst[0]][14][0],bit_mem128[inst[0]][6][0],bit_mem128[inst[0]][10][0],bit_mem128[inst[0]][2][0],bit_mem128[inst[0]][12][0],bit_mem128[inst[0]][4][0],bit_mem128[inst[0]][8][0],bit_mem128[inst[0]][0][0]};
                        //64bit reverse
                        4'b0100 : {bit_mem64[inst[0]][7],bit_mem64[inst[0]][6],bit_mem64[inst[0]][5],bit_mem64[inst[0]][4],bit_mem64[inst[0]][3],bit_mem64[inst[0]][2],bit_mem64[inst[0]][1],bit_mem64[inst[0]][0]} = {bit_mem64[inst[0]][7][7],bit_mem64[inst[0]][3][7],bit_mem64[inst[0]][5][7],bit_mem64[inst[0]][1][7],bit_mem64[inst[0]][6][7],bit_mem64[inst[0]][2][7],bit_mem64[inst[0]][4][7],bit_mem64[inst[0]][0][7],bit_mem64[inst[0]][7][3],bit_mem64[inst[0]][3][3],bit_mem64[inst[0]][5][3],bit_mem64[inst[0]][1][3],bit_mem64[inst[0]][6][3],bit_mem64[inst[0]][2][3],bit_mem64[inst[0]][4][3],bit_mem64[inst[0]][0][3],bit_mem64[inst[0]][7][5],bit_mem64[inst[0]][3][5],bit_mem64[inst[0]][5][5],bit_mem64[inst[0]][1][5],bit_mem64[inst[0]][6][5],bit_mem64[inst[0]][2][5],bit_mem64[inst[0]][4][5],bit_mem64[inst[0]][0][5],bit_mem64[inst[0]][7][1],bit_mem64[inst[0]][3][1],bit_mem64[inst[0]][5][1],bit_mem64[inst[0]][1][1],bit_mem64[inst[0]][6][1],bit_mem64[inst[0]][2][1],bit_mem64[inst[0]][4][1],bit_mem64[inst[0]][0][1],bit_mem64[inst[0]][7][6],bit_mem64[inst[0]][3][6],bit_mem64[inst[0]][5][6],bit_mem64[inst[0]][1][6],bit_mem64[inst[0]][6][6],bit_mem64[inst[0]][2][6],bit_mem64[inst[0]][4][6],bit_mem64[inst[0]][0][6],bit_mem64[inst[0]][7][2],bit_mem64[inst[0]][3][2],bit_mem64[inst[0]][5][2],bit_mem64[inst[0]][1][2],bit_mem64[inst[0]][6][2],bit_mem64[inst[0]][2][2],bit_mem64[inst[0]][4][2],bit_mem64[inst[0]][0][2],bit_mem64[inst[0]][7][4],bit_mem64[inst[0]][3][4],bit_mem64[inst[0]][5][4],bit_mem64[inst[0]][1][4],bit_mem64[inst[0]][6][4],bit_mem64[inst[0]][2][4],bit_mem64[inst[0]][4][4],bit_mem64[inst[0]][0][4],bit_mem64[inst[0]][7][0],bit_mem64[inst[0]][3][0],bit_mem64[inst[0]][5][0],bit_mem64[inst[0]][1][0],bit_mem64[inst[0]][6][0],bit_mem64[inst[0]][2][0],bit_mem64[inst[0]][4][0],bit_mem64[inst[0]][0][0]};
                        //32bit reverse
                        4'b0010 : {bit_mem32[inst[0]][3],bit_mem32[inst[0]][2],bit_mem32[inst[0]][1],bit_mem32[inst[0]][0]} <= {bit_mem32[inst[0]][3][7],bit_mem32[inst[0]][1][7],bit_mem32[inst[0]][2][7],bit_mem32[inst[0]][0][7],bit_mem32[inst[0]][3][3],bit_mem32[inst[0]][1][3],bit_mem32[inst[0]][2][3],bit_mem32[inst[0]][0][3],bit_mem32[inst[0]][3][5],bit_mem32[inst[0]][1][5],bit_mem32[inst[0]][2][5],bit_mem32[inst[0]][0][5],bit_mem32[inst[0]][3][1],bit_mem32[inst[0]][1][1],bit_mem32[inst[0]][2][1],bit_mem32[inst[0]][0][1],bit_mem32[inst[0]][3][6],bit_mem32[inst[0]][1][6],bit_mem32[inst[0]][2][6],bit_mem32[inst[0]][0][6],bit_mem32[inst[0]][3][2],bit_mem32[inst[0]][1][2],bit_mem32[inst[0]][2][2],bit_mem32[inst[0]][0][2],bit_mem32[inst[0]][3][4],bit_mem32[inst[0]][1][4],bit_mem32[inst[0]][2][4],bit_mem32[inst[0]][0][4],bit_mem32[inst[0]][3][0],bit_mem32[inst[0]][1][0],bit_mem32[inst[0]][2][0],bit_mem32[inst[0]][0][0]};
                        4'b0001 : {bit_mem16[inst[0]][1],bit_mem16[inst[0]][0]} = {bit_mem16[inst[0]][1][7],bit_mem16[inst[0]][0][7],bit_mem16[inst[0]][1][3],bit_mem16[inst[0]][0][3],bit_mem16[inst[0]][1][5],bit_mem16[inst[0]][0][5],bit_mem16[inst[0]][1][1],bit_mem16[inst[0]][0][1],bit_mem16[inst[0]][1][6],bit_mem16[inst[0]][0][6],bit_mem16[inst[0]][1][2],bit_mem16[inst[0]][0][2],bit_mem16[inst[0]][1][4],bit_mem16[inst[0]][0][4],bit_mem16[inst[0]][1][0],bit_mem16[inst[0]][0][0]};
                        default : bit_mem32 <= bit_mem32;
                    endcase
                end
                decode_state <= STORE;
            end
            STORE : begin
                cnt_inst <= cnt_inst + 1'b1;
                decode_state <= FETCH;
                /* exec_en <= 1'b0; */
                case(inst[3:1])
                    `COMB128TO256 : begin //101
                        if(mem_wr_en[2])
                            llr_mem128[inst[11:8]] <= llr_out_tmp;
                        else
                            llr_mem128[inst[11:8]] <= llr_mem128[inst[11:8]];
                        if(mem_wr_en[0]) begin
                            bit_mem256 <= bit_comb_out_tmp;
                        end
                        else
                            bit_mem256 <= bit_mem256;
                    end
                    `COMB64TO128 : begin //100
                        if(mem_wr_en[2])
                            llr_mem64[inst[11:9]] <= llr_out_tmp;
                        else
                            llr_mem64[inst[11:9]] <= llr_mem64[inst[11:9]];
                        if(mem_wr_en[0])
                            {bit_mem128[inst[0]][15],bit_mem128[inst[0]][14],bit_mem128[inst[0]][13],bit_mem128[inst[0]][12],bit_mem128[inst[0]][11],bit_mem128[inst[0]][10],bit_mem128[inst[0]][9],bit_mem128[inst[0]][8],bit_mem128[inst[0]][7],bit_mem128[inst[0]][6],bit_mem128[inst[0]][5],bit_mem128[inst[0]][4],bit_mem128[inst[0]][3],bit_mem128[inst[0]][2],bit_mem128[inst[0]][1],bit_mem128[inst[0]][0]} <= bit_comb_out_tmp[127:0];
                        else
                            bit_mem128 <= bit_mem128;
                    end
                    `COMB32TO64 : begin //011
                        if(mem_wr_en[2])
                            llr_mem32[inst[10:9]] <= llr_out_tmp;
                        else
                            llr_mem32[inst[10:9]] <= llr_mem32[inst[10:9]];
                        if(mem_wr_en[0])
                            {bit_mem64[inst[0]][7],bit_mem64[inst[0]][6],bit_mem64[inst[0]][5],bit_mem64[inst[0]][4],bit_mem64[inst[0]][3],bit_mem64[inst[0]][2],bit_mem64[inst[0]][1],bit_mem64[inst[0]][0]} <= bit_comb_out_tmp[63:0];
                        else
                            bit_mem64[inst[0]] <= bit_mem64[inst[0]];
                    end
                    `COMB16TO32 : begin //010
                        if(mem_wr_en[2])
                            llr_mem16[inst[9]] <= llr_out_tmp;
                        else
                            llr_mem16[inst[9]] <= llr_mem16[inst[9]];
                        if(mem_wr_en[0])
                            {bit_mem32[inst[0]][3],bit_mem32[inst[0]][2],bit_mem32[inst[0]][1],bit_mem32[inst[0]][0]} <= bit_comb_out_tmp[31:0];
                        else
                            bit_mem32 <= bit_mem32;
                    end
                    `COMB8TO16 : begin //001
                        if(mem_wr_en[2])
                            llr_mem8 <= llr_out_tmp;
                        else
                            llr_mem8 <= llr_mem8;
                        case(mem_wr_en[1:0])
                            2'b10: {bit_mem16[inst[0]][1],bit_mem16[inst[0]][0]} <= bit_out_tmp;
                            2'b01: {bit_mem16[inst[0]][1],bit_mem16[inst[0]][0]} <= bit_comb_out_tmp[15:0];
                            default: bit_mem16 <= bit_mem16;
                        endcase
                    end
                    `COMB4TO8 : begin //000
                        if(mem_wr_en[2])
                            llr_mem4 <= llr_out_tmp[23:0];
                        else
                            llr_mem4 <= llr_mem4;
                        case(mem_wr_en[1:0])
                            2'b10: bit_mem8[inst[0]] <= bit_out_tmp[7:0];
                            2'b01: bit_mem8[inst[0]] <= bit_comb_out_tmp[7:0];
                            default: bit_mem8 <= bit_mem8;
                        endcase
                    end
                    `COMB2TO4: begin //110
                        case(mem_wr_en[1:0])
                            2'b10: bit_mem4[inst[0]] <= bit_out_tmp[3:0];
                            2'b01: bit_mem4[inst[0]] <= bit_comb_out_tmp[3:0];
                            default bit_mem4 <= bit_mem4;
                        endcase
                    end
                    default : begin
                        bit_mem256 <= bit_mem256;
                    end
                endcase
            end
            default: begin
                /* exec_en <= 1'b0; */
                cnt_inst <= cnt_inst;
            end
        endcase
    end
    else begin
        decode_state <= 3'b001;
        /* exec_en <= 1'b0; */
    end
end

process_unit pu_inst(
    .llr_in(llr_in_tmp),
    .bit_comb_left(bit_comb_left_tmp),
    .bit_comb_right(bit_comb_right_tmp),
    .funcg_bit_in(bit_in_tmp),
    
    .inst(inst_tmp),
    
    .mem_wr_en(mem_wr_en),
    .bit_out(bit_out_tmp),
    .llr_out(llr_out_tmp),
    .bit_comb_out(bit_comb_out_tmp)
);

extract extract_inst(
    .din(bit_mem256),
    .dout(bit_out)
);

instmem mem_inst(
    .addr(cnt_inst),
    .en(mem_en),
    .inst(inst)
);


endmodule



