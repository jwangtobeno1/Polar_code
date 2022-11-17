module bit_mix(
	input 	wire			sys_clk	,
	input	wire			rst_n	,
	input	wire	[127:0]	data_in	,

	output	reg		[255:0]	data_out	
);

always @(posedge sys_clk or negedge rst_n)	begin
	if(rst_n == 1'b0)
		data_out <= 256'b0;
	else
		data_out <= {};
end

endmodule