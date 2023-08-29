module uart_rx
#(
    parameter   UART_BPS = 'd9600,
    parameter   CLK_FREQ = 'd50_000_000
)
(
    input   wire            clk     ,
    input   wire            rst_n   ,
    input   wire            rx      ,
    output  reg     [127:0] po_data ,
    output  reg             po_flag
);

localparam BAUD_CNT_MAX = CLK_FREQ / UART_BPS;
localparam RX_FLAG_WAIT = 14'd10000;

reg     rx_reg1;
reg     rx_reg2;
reg     rx_reg3;
reg     work_en;
reg     bit_flag;
reg     rx_flag;
reg     start_nedge;
reg     rx_data_128_flag;
reg     po_data_ok;


reg [3:0]   bit_cnt;
reg [12:0]  baud_cnt;
reg [7:0]   rx_data;
reg [3:0]   rx_flag_cnt;
reg [127:0] rx_data_128;

reg         rx_flag_wait_cnt_en;
reg         rx_flag_wait_flag;
reg [15:0]  rx_flag_wait_cnt; //2个字节

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_flag_wait_cnt_en <= 1'b0;
    else if(rx_flag == 1'b1)
        rx_flag_wait_cnt_en <= 1'b1;
    else if(start_nedge == 1'b1 || (rx_flag_wait_cnt == RX_FLAG_WAIT - 1'b1))
        rx_flag_wait_cnt_en <= 1'b0;
    else
        rx_flag_wait_cnt_en <= rx_flag_wait_cnt_en;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_flag_wait_cnt <= 16'b0;
    else if(rx_flag_wait_cnt_en == 1'b0)
        rx_flag_wait_cnt <= 16'b0;
    else if(rx_flag_wait_cnt_en == 1'b1)
        rx_flag_wait_cnt <= rx_flag_wait_cnt + 1'b1;
    else
        rx_flag_wait_cnt <= rx_flag_wait_cnt;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_flag_wait_flag <= 1'b0;
    else if(rx_flag_wait_cnt == RX_FLAG_WAIT - 1'b1)
        rx_flag_wait_flag <= 1'b1;
    else
        rx_flag_wait_flag <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_reg1 <= 1'b1;
    else
        rx_reg1 <= rx;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_reg2 <= 1'b1;
    else
        rx_reg2 <= rx_reg1;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_reg3 <= 1'b1;
    else
        rx_reg3 <= rx_reg2;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        start_nedge <= 1'b0;
    else if((~rx_reg2) && rx_reg3)
        start_nedge <= 1'b1;
    else
        start_nedge <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        work_en <= 1'b0;
    else if(start_nedge == 1'b1)
        work_en <= 1'b1;
    else if((bit_flag == 1'b1) && (bit_cnt == 4'd8))   //NOTE
        work_en <= 1'b0;       
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        baud_cnt <= 13'd0;
    else if((baud_cnt == BAUD_CNT_MAX - 1'b1) || (work_en == 1'b0))
        baud_cnt <= 13'd0;
    else if(work_en == 1'b1)
        baud_cnt <= baud_cnt + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        bit_flag <= 1'b0;
    else if(baud_cnt == BAUD_CNT_MAX/2 - 1'b1)
        bit_flag <= 1'b1;
    else
        bit_flag <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        bit_cnt <= 4'd0;
    else if((bit_flag == 1'b1) && (bit_cnt == 4'd8))
        bit_cnt <= 4'd0;
    else if(bit_flag == 1'b1)
        bit_cnt <= bit_cnt + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_data <= 8'd0;
    else if((bit_flag == 1'b1) && (bit_cnt >= 4'd1) && (bit_cnt <= 4'd8))
        rx_data <= {rx_reg3, rx_data[7:1]};
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_flag <= 1'b0;
    else if((bit_cnt == 4'd8) && (bit_flag == 1'b1))
        rx_flag <= 1'b1;
    else
        rx_flag <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_flag_cnt <= 4'd0;
    else if(((rx_flag == 1'b1) && (rx_flag_cnt == 4'd15)) || (rx_flag_wait_flag == 1'b1))
        rx_flag_cnt <= 4'd0;
    else if(rx_flag == 1'b1)
        rx_flag_cnt <= rx_flag_cnt + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_data_128 <= 128'd0;
    else if((rx_flag == 1'b1) && (rx_flag_cnt >= 4'd0) && (rx_flag_cnt <= 4'd15))
        rx_data_128 <= {rx_data_128[119:0],rx_data};
    else if(rx_flag_wait_flag == 1'b1)
        case(rx_flag_cnt)
            1       :   rx_data_128 <= {rx_data_128[7:0],120'b0};
            2       :   rx_data_128 <= {rx_data_128[15:0],112'b0};
            3       :   rx_data_128 <= {rx_data_128[23:0],104'b0};
            4       :   rx_data_128 <= {rx_data_128[31:0],96'b0};
            5       :   rx_data_128 <= {rx_data_128[39:0],88'b0};
            6       :   rx_data_128 <= {rx_data_128[47:0],80'b0};
            7       :   rx_data_128 <= {rx_data_128[55:0],72'b0};
            8       :   rx_data_128 <= {rx_data_128[63:0],64'b0};
            9       :   rx_data_128 <= {rx_data_128[71:0],56'b0};
            10      :   rx_data_128 <= {rx_data_128[79:0],48'b0};
            11      :   rx_data_128 <= {rx_data_128[87:0],40'b0};
            12      :   rx_data_128 <= {rx_data_128[95:0],32'b0};
            13      :   rx_data_128 <= {rx_data_128[103:0],24'b0};
            14      :   rx_data_128 <= {rx_data_128[111:0],16'b0};
            15      :   rx_data_128 <= {rx_data_128[119:0],8'b0};
            default :   rx_data_128 <= rx_data_128;
        endcase
        
    else if(po_data_ok == 1'b1)
        rx_data_128 <= 128'b0;
    else
        rx_data_128 <= rx_data_128;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        rx_data_128_flag <= 1'b0;
    else if((((rx_flag_cnt == 4'd15) && (rx_flag == 1'b1)) || (rx_flag_wait_flag == 1'b1)) && (rx_data_128 != 128'b0))
        rx_data_128_flag <= 1'b1;
    else
        rx_data_128_flag <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        po_data <= 128'b0;  
        po_data_ok <= 1'b0;    
    end
    else if(rx_data_128_flag == 1'b1) begin
        po_data <= rx_data_128;
        po_data_ok <= 1'b1;      
    end
    else begin
        po_data <= po_data;
        po_data_ok <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        po_flag <= 1'b0;
    else
        po_flag <= rx_data_128_flag;
end

endmodule