module gen_matrix 
#(
	parameter	N = 256
)
(
	input	wire	[N-1:0]	data_in	,

	output	wire	[N-1:0]	data_out
);

wire	[31:0]	f_5_data[7:0];
wire	[31:0]	f_8_data[7:0];


function [31:0] f_5;
	input	[31:0]	bit_in;
	begin
		f_5 = {
			^bit_in,
			bit_in[30]^bit_in[28]^bit_in[26]^bit_in[24]^bit_in[22]^bit_in[20]^bit_in[18]^bit_in[16]^bit_in[14]^bit_in[12]^bit_in[10]^bit_in[8]^bit_in[6]^bit_in[4]^bit_in[2]^bit_in[0],
			bit_in[29]^bit_in[28]^bit_in[25]^bit_in[24]^bit_in[21]^bit_in[20]^bit_in[17]^bit_in[16]^bit_in[13]^bit_in[12]^bit_in[9]^bit_in[8]^bit_in[5]^bit_in[4]^bit_in[1]^bit_in[0],
			bit_in[28]^bit_in[24]^bit_in[20]^bit_in[16]^bit_in[12]^bit_in[8]^bit_in[4]^bit_in[0],
			bit_in[27]^bit_in[26]^bit_in[25]^bit_in[24]^bit_in[19]^bit_in[18]^bit_in[17]^bit_in[16]^bit_in[11]^bit_in[10]^bit_in[9]^bit_in[8]^bit_in[3]^bit_in[2]^bit_in[1]^bit_in[0],
			bit_in[26]^bit_in[24]^bit_in[18]^bit_in[16]^bit_in[10]^bit_in[8]^bit_in[2]^bit_in[0],
			bit_in[25]^bit_in[24]^bit_in[17]^bit_in[16]^bit_in[9]^bit_in[8]^bit_in[1]^bit_in[0],
			bit_in[24]^bit_in[16]^bit_in[8]^bit_in[0],
			bit_in[23]^bit_in[22]^bit_in[21]^bit_in[20]^bit_in[19]^bit_in[18]^bit_in[17]^bit_in[16]^bit_in[7]^bit_in[6]^bit_in[5]^bit_in[4]^bit_in[3]^bit_in[2]^bit_in[1]^bit_in[0],
			bit_in[22]^bit_in[20]^bit_in[18]^bit_in[16]^bit_in[6]^bit_in[4]^bit_in[2]^bit_in[0],
			bit_in[21]^bit_in[20]^bit_in[17]^bit_in[16]^bit_in[5]^bit_in[4]^bit_in[1]^bit_in[0],
			bit_in[20]^bit_in[16]^bit_in[4]^bit_in[0],
			bit_in[19]^bit_in[18]^bit_in[17]^bit_in[16]^bit_in[3]^bit_in[2]^bit_in[1]^bit_in[0],
			bit_in[18]^bit_in[16]^bit_in[2]^bit_in[0],
			bit_in[17]^bit_in[16]^bit_in[1]^bit_in[0],
			bit_in[16]^bit_in[0],
			
			bit_in[15]^bit_in[14]^bit_in[13]^bit_in[12]^bit_in[11]^bit_in[10]^bit_in[9]^bit_in[8]^bit_in[7]^bit_in[6]^bit_in[5]^bit_in[4]^bit_in[3]^bit_in[2]^bit_in[1]^bit_in[0],
			bit_in[14]^bit_in[12]^bit_in[10]^bit_in[8]^bit_in[6]^bit_in[4]^bit_in[2]^bit_in[0],
			bit_in[13]^bit_in[12]^bit_in[9]^bit_in[8]^bit_in[5]^bit_in[4]^bit_in[1]^bit_in[0],
			bit_in[12]^bit_in[8]^bit_in[4]^bit_in[0],
			bit_in[11]^bit_in[10]^bit_in[9]^bit_in[8]^bit_in[3]^bit_in[2]^bit_in[1]^bit_in[0],
			bit_in[10]^bit_in[8]^bit_in[2]^bit_in[0],
			bit_in[9]^bit_in[8]^bit_in[1]^bit_in[0],
			bit_in[8]^bit_in[0],   //8
			bit_in[7]^bit_in[6]^bit_in[5]^bit_in[4]^bit_in[3]^bit_in[2]^bit_in[1]^bit_in[0],
			bit_in[6]^bit_in[4]^bit_in[2]^bit_in[0],
			bit_in[5]^bit_in[4]^bit_in[1]^bit_in[0],
			bit_in[4]^bit_in[0],
			bit_in[3]^bit_in[2]^bit_in[1]^bit_in[0],
			bit_in[2]^bit_in[0],
			bit_in[1]^bit_in[0],
			bit_in[0]
		};
	end
endfunction

generate
	genvar i;
	for(i = 0; i < N/32; i = i + 1) begin
		assign f_5_data[i] = f_5(data_in[32*i +: 32]);
	end
endgenerate

assign f_8_data[0] = f_5_data[0];
assign f_8_data[1] = f_5_data[1]^f_5_data[0];
assign f_8_data[2] = f_5_data[2]^f_5_data[0];
assign f_8_data[3] = f_5_data[3]^f_5_data[2]^f_5_data[1]^f_5_data[0];
assign f_8_data[4] = f_5_data[4]^f_5_data[0];
assign f_8_data[5] = f_5_data[5]^f_5_data[4]^f_5_data[1]^f_5_data[0];
assign f_8_data[6] = f_5_data[6]^f_5_data[4]^f_5_data[2]^f_5_data[0];
assign f_8_data[7] = f_5_data[7]^f_5_data[6]^f_5_data[5]^f_5_data[4]^f_5_data[3]^f_5_data[2]^f_5_data[1]^f_5_data[0];

assign data_out = {f_8_data[7],f_8_data[6],f_8_data[5],f_8_data[4],f_8_data[3],f_8_data[2],f_8_data[1],f_8_data[0]};


endmodule