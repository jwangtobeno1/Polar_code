`timescale 1ns/1ps

module async_fifo #(parameter
    WIDTH = 8,
    DEPTH = 16
)(
    input               wclk,
    input               wrst_n,
    input               winc,
    input   [WIDTH-1:0] wdata,
    output  reg         wfull,  

    input               rclk,
    input               rrst_n,
    input               rinc,
    output  [WIDTH-1:0] rdata,
    output  reg         rempty
);

/* 注意：
    顶层输出最后都经过一级寄存器，不然单bit CDC时容易出现问题：会因组合电路产生的pulse而同步
    到错误的结果。例如异步FIFO顶层的wfull和rempty最好是经过一级寄存后再输出。
*/

localparam  ADDR_WIDTH = $clog2(DEPTH);

reg     [ADDR_WIDTH:0]  wptr_bin;
reg     [ADDR_WIDTH:0]  rptr_bin;

always @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n)
        wptr_bin <= 'd0;
    else if(winc && ~wfull)
        wptr_bin <= wptr_bin + 1'b1;
    else
        wptr_bin <= wptr_bin;
end

always @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n)
        rptr_bin <= 'd0;
    else if(rinc && ~rempty)
        rptr_bin <= rptr_bin + 1'b1;
    else
        rptr_bin <= rptr_bin;
end

wire    [ADDR_WIDTH:0]  wptr_gray;
wire    [ADDR_WIDTH:0]  rptr_gray;

assign wptr_gray = wptr_bin ^ (wptr_bin >> 1);
assign rptr_gray = rptr_bin ^ (rptr_bin >> 1);

reg     [ADDR_WIDTH:0]  wptr_gray_reg;
reg     [ADDR_WIDTH:0]  rptr_gray_reg;

always @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n)
        wptr_gray_reg <= 'd0;
    else
        wptr_gray_reg <= wptr_gray;
end

always @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n)
        rptr_gray_reg <= 'd0;
    else
        rptr_gray_reg <= rptr_gray;
end

reg     [ADDR_WIDTH:0]  rptr_gray_reg_d1;
reg     [ADDR_WIDTH:0]  rptr_gray_reg_d2;
reg     [ADDR_WIDTH:0]  wptr_gray_reg_d1;
reg     [ADDR_WIDTH:0]  wptr_gray_reg_d2;

always @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
        rptr_gray_reg_d1 <= 'd0;
        rptr_gray_reg_d2 <= 'd0;
    end else begin
        rptr_gray_reg_d1 <= rptr_gray_reg;
        rptr_gray_reg_d2 <= rptr_gray_reg_d1;
    end
end

always @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n) begin
        wptr_gray_reg_d1 <= 'd0;
        wptr_gray_reg_d2 <= 'd0;
    end else begin
        wptr_gray_reg_d1 <= wptr_gray_reg;
        wptr_gray_reg_d2 <= wptr_gray_reg_d1;
    end
end

wire wfull_s;
wire rempty_s;

assign wfull_s = wptr_gray_reg == {~rptr_gray_reg_d2[ADDR_WIDTH:ADDR_WIDTH-1],rptr_gray_reg_d2[ADDR_WIDTH-2:0]};
assign rempty_s = rptr_gray_reg == wptr_gray_reg_d2;

always @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n)
        wfull <= 'd0;
    else
        wfull <= wfull_s;
end

always @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n)
        rempty <= 'd0;
    else
        rempty <= rempty_s;
end

ad_mem #(

    .DATA_WIDTH(WIDTH),
    .ADDRESS_WIDTH(ADDR_WIDTH)

)fifo_mem (

    .clka(wclk),
    .wea(winc && ~wfull),
    .addra(wptr_bin[ADDR_WIDTH-1:0]),
    .dina(wdata),

    .clkb(rclk),
    .reb(rinc && ~rempty),
    .addrb(rptr_bin[ADDR_WIDTH-1:0]),
    .doutb(rdata)
    );

    

endmodule
