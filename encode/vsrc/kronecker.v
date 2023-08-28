module kronecker(
    input                   clk,
    input                   rst_n,
    input                   vld_i,
    input   [255:0]         din,
    output  reg [255:0]     dout,
    output  reg             vld_o
);


wire [31:0]  kron_5_reg [0:7];
generate
    genvar gen_i;
    for(gen_i = 0; gen_i < 8; gen_i = gen_i + 1) begin : kron_8
        kron_5 kron_5_gen_i(
            .clk(clk),
            .rst_n(rst_n),
            .din(din[32*(gen_i+1)-1 : 32*gen_i]),
            .dout(kron_5_reg[gen_i])
        );
    end
endgenerate

wire	[31:0]	kron_8_reg [0:7];
assign kron_8_reg[0] = kron_5_reg[0];
assign kron_8_reg[1] = kron_5_reg[1]^kron_5_reg[0];
assign kron_8_reg[2] = kron_5_reg[2]^kron_5_reg[0];
assign kron_8_reg[3] = kron_5_reg[3]^kron_5_reg[2]^kron_5_reg[1]^kron_5_reg[0];
assign kron_8_reg[4] = kron_5_reg[4]^kron_5_reg[0];
assign kron_8_reg[5] = kron_5_reg[5]^kron_5_reg[4]^kron_5_reg[1]^kron_5_reg[0];
assign kron_8_reg[6] = kron_5_reg[6]^kron_5_reg[4]^kron_5_reg[2]^kron_5_reg[0];
assign kron_8_reg[7] = kron_5_reg[7]^kron_5_reg[6]^kron_5_reg[5]^kron_5_reg[4]^kron_5_reg[3]^kron_5_reg[2]^kron_5_reg[1]^kron_5_reg[0];

wire [255:0] kron_res;
assign kron_res = {kron_8_reg[7],kron_8_reg[6],kron_8_reg[5],kron_8_reg[4],kron_8_reg[3],kron_8_reg[2],kron_8_reg[1],kron_8_reg[0]};

reg vld_i_d1;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        vld_i_d1 <= 1'b0;
        vld_o <= 1'b0;
    end else begin
        vld_i_d1 <= vld_i;
        vld_o <= vld_i_d1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        dout <= 'd0;
    else
        dout <= kron_res;
end

endmodule
