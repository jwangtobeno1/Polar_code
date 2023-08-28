module top(
    input   wire            clk     ,
    input   wire            rst_n   ,
    input   wire            rx      ,
    output  wire            tx
);

wire [127:0] po_data;
wire         po_flag; 
wire [127:0] data_in;
wire         encode_flag;
wire [255:0] data_out;
wire         empty;
wire         fifo_rd_en;
wire         data_tx_ok;

reg fifo_data_vld;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        fifo_data_vld <= 1'b0;
    else if(fifo_rd_en && !empty)
        fifo_data_vld <= 1'b1;
    else
        fifo_data_vld <= 1'b0;
end

uart_rx uart_rx_inxt
(
    .clk     (clk),
    .rst_n   (rst_n),
    .rx      (rx),
    .po_data (po_data),
    .po_flag (po_flag)
);

encode polar_encoder_inst(
    .clk                (clk        ),
    .rst_n              (rst_n      ),
    .data_in            (data_in    ),
    .valid_i            (fifo_data_vld    ),
    .data_out           (data_out   ),
    .valid_o            (encode_flag),
    .ready_o            (fifo_rd_en )
);

uart_tx uart_tx_inst
(
    .clk            (clk),
    .rst_n          (rst_n),
    .pi_data        (data_out),
    .pi_flag        (encode_flag),
    .tx             (tx),
    .data_tx_ok     (data_tx_ok)
);

sync_fifo #(
    .WIDTH(128),
    .DEPTH(256)
) fifo_inst_128x256 (
    .clk(clk),
    .rst_n(rst_n),
    .winc(po_flag),
    .wdata(po_data),
    .wfull,

    .rinc(fifo_rd_en && (!empty)),
    .rdata(data_in),
    .rempty
);

endmodule