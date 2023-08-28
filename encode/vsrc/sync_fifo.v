`timescale 1ns / 1ps

module sync_fifo#(parameter
    WIDTH = 8,
    DEPTH = 16
)(
    input               clk,
    input               rst_n,
    input               winc,
    input   [WIDTH-1:0] wdata,
    output  reg         wfull,

    input               rinc,
    output  [WIDTH-1:0] rdata,
    output  reg         rempty
);

localparam ADDR_WIDTH = $clog2(DEPTH);

reg     [ADDR_WIDTH-1:0]    wptr_bin;
reg     [ADDR_WIDTH-1:0]    rptr_bin;

/* verilator lint_off WIDTHEXPAND */

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        wptr_bin <= 'd0;
    else if(winc && ~wfull)
        wptr_bin <= wptr_bin + 1'b1;
    else
        wptr_bin <= wptr_bin;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        rptr_bin <= 'd0;
    else if(rinc && ~rempty)
        rptr_bin <= rptr_bin + 1'b1;
    else
        rptr_bin <= rptr_bin;
end

reg [ADDR_WIDTH:0]    data_cnt; // 同步FIFO注意计数器的宽度要可以计数到DEPTH，即一般比ptr多1bit

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        data_cnt <= 'd0;
    else begin
        case({winc, rinc})
            2'b00:
                data_cnt <= data_cnt;
            2'b01:
                if(!rempty)
                    data_cnt <= data_cnt - 1'b1;
            2'b10:
                if(!wfull)
                    data_cnt <= data_cnt + 1'b1;
            2'b11:
                data_cnt <= data_cnt;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wfull <= 'd0;
        rempty <= 'd0;
    end else begin
        wfull <= (data_cnt >= DEPTH-1);
        rempty <= (data_cnt == 0);
    end
end

ad_mem #(
    .DATA_WIDTH(WIDTH),
    .ADDRESS_WIDTH(ADDR_WIDTH)
)fifo_ram_inst(
    .clka(clk),
    .wea(winc && ~wfull),
    .addra(wptr_bin),
    .dina(wdata),

    .clkb(clk),
    .reb(rinc && ~rempty),
    .addrb(rptr_bin),
    .doutb(rdata)
);

endmodule
