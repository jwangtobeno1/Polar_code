module encode (
    input                   clk         	,
    input                   rst_n       	,
    input   [127:0]         data_in     	,
	input                   valid_i		    ,
    output  wire [255:0]    data_out    	,
    output  wire            valid_o		    ,
	output	reg			    ready_o	
);

reg data_in_vld;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        data_in_vld <= 1'b0;
    else if(valid_i && ready_o)
        data_in_vld <= 1'b1;
    else
        data_in_vld <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ready_o <= 1'b1;
    else if(valid_i)
        ready_o <= 1'b0;
    else if(valid_o)
        ready_o <= 1'b1;
end

reg [127:0] bit_mix_din;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        bit_mix_din <= 'd0;
    else if(valid_i && ready_o)
        bit_mix_din <= data_in;
end

wire [255:0] bit_mix_res;
wire bit_mix_res_vld;
bit_mix bit_mix_inst(
    .clk(clk),
    .rst_n(rst_n),
    .vld_i(data_in_vld),
    .din(bit_mix_din),
    .dout(bit_mix_res),
    .vld_o(bit_mix_res_vld)
);

wire [255:0] encode_res;
wire        kronecker_res_vld;
kronecker kronecker_inst(
    .clk(clk),
    .rst_n(rst_n),
    .vld_i(bit_mix_res_vld),
    .din(bit_mix_res),
    .dout(encode_res),
    .vld_o(kronecker_res_vld)
);

bit_reverse bit_reverse_inst(
    .clk(clk),
    .rst_n(rst_n),
    .vld_i(kronecker_res_vld),
    .din(encode_res),
    .dout(data_out),
    .vld_o(valid_o)
);


endmodule

