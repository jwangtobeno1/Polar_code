module uart_tx
#(
    parameter UART_BPS = 'd9600 ,
    parameter CLK_FREQ = 'd50_000_000
)(
    input   wire            clk     ,
    input   wire            rst_n   ,
    input   wire    [255:0] pi_data ,
    input   wire            pi_flag ,
    output  reg             tx      ,
    output  reg             data_tx_ok
);

localparam BAUD_CNT_MAX = CLK_FREQ / UART_BPS;

reg [12:0]  baud_cnt;
reg         bit_flag;
reg [3:0]   bit_cnt;
reg         work_en;
reg [5:0]   word_cnt; //32

reg [255:0] pi_data_reg;
wire [7:0]  pi_data_reg_array [31:0];

generate
    genvar gen_x;
    for(gen_x = 0; gen_x < 32; gen_x = gen_x + 1) begin: gen_scale //gen_scale为这个generate for循环的块名，不取名会报warning
        assign pi_data_reg_array[gen_x] = pi_data_reg[gen_x*8 +: 8]; 
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        pi_data_reg <= 256'b0;
    else if(pi_flag == 1'b1 && work_en == 1'b0)
        pi_data_reg <= pi_data;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        work_en <= 1'b0;
        data_tx_ok <= 1'b1;
    end
    else if(pi_flag == 1'b1) begin
        work_en <= 1'b1;
        data_tx_ok <= 1'b0;
    end
    else if((baud_cnt == BAUD_CNT_MAX - 4'd11) && (word_cnt == 6'd32)) begin
        work_en <= 1'b0;
        data_tx_ok <= 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        baud_cnt <= 13'd0;
    else if((baud_cnt == BAUD_CNT_MAX - 1) || (work_en == 1'b0))
        baud_cnt <= 13'd0;
    else if(work_en == 1'b1)
        baud_cnt <= baud_cnt + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        bit_flag <= 1'b0;
    else if(baud_cnt == 13'd1)
        bit_flag <= 1'b1;
    else
        bit_flag <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        bit_cnt <= 4'b0;
    else    if((bit_flag == 1'b1) && (bit_cnt == 4'd9) || (work_en == 1'b0))
        bit_cnt <= 4'b0;
    else    if((bit_flag == 1'b1) && (work_en == 1'b1))
        bit_cnt <= bit_cnt + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        word_cnt <= 6'd0;
    else if((bit_cnt == 4'd9) && (baud_cnt == BAUD_CNT_MAX-1'b1) && (work_en == 1'b1))
        word_cnt <= word_cnt + 1'b1;
    else if(work_en == 1'b0)
        word_cnt <= 6'd0;
end

always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0)
            tx <= 1'b1; //空闲状态时为高电平
        else    if(bit_flag == 1'b1)
            case(bit_cnt)
                0       : tx <= 1'b0;
                1       : tx <= pi_data_reg_array[31-word_cnt][0];
                2       : tx <= pi_data_reg_array[31-word_cnt][1];
                3       : tx <= pi_data_reg_array[31-word_cnt][2];
                4       : tx <= pi_data_reg_array[31-word_cnt][3];
                5       : tx <= pi_data_reg_array[31-word_cnt][4];
                6       : tx <= pi_data_reg_array[31-word_cnt][5];
                7       : tx <= pi_data_reg_array[31-word_cnt][6];
                8       : tx <= pi_data_reg_array[31-word_cnt][7];
                9       : tx <= 1'b1;
                default : tx <= 1'b1;
            endcase
end

endmodule