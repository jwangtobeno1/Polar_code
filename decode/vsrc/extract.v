module extract(
    input   wire    [255:0] din,
    output  wire    [127:0] dout
);

wire [255:0]    kron_result;

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

function [255:0] kronecker;
    input [255:0] gen_data_in;
    reg	[31:0]	f_5_data[7:0];
    reg	[31:0]	f_8_data[7:0];
    begin
        f_5_data[0] = f_5(gen_data_in[31:0]);
        f_5_data[1] = f_5(gen_data_in[63:32]);
        f_5_data[2] = f_5(gen_data_in[95:64]);
        f_5_data[3] = f_5(gen_data_in[127:96]);
        f_5_data[4] = f_5(gen_data_in[159:128]);
        f_5_data[5] = f_5(gen_data_in[191:160]);
        f_5_data[6] = f_5(gen_data_in[223:192]);
        f_5_data[7] = f_5(gen_data_in[255:224]);
        f_8_data[0] = f_5_data[0];
        f_8_data[1] = f_5_data[1]^f_5_data[0];
        f_8_data[2] = f_5_data[2]^f_5_data[0];
        f_8_data[3] = f_5_data[3]^f_5_data[2]^f_5_data[1]^f_5_data[0];
        f_8_data[4] = f_5_data[4]^f_5_data[0];
        f_8_data[5] = f_5_data[5]^f_5_data[4]^f_5_data[1]^f_5_data[0];
        f_8_data[6] = f_5_data[6]^f_5_data[4]^f_5_data[2]^f_5_data[0];
        f_8_data[7] = f_5_data[7]^f_5_data[6]^f_5_data[5]^f_5_data[4]^f_5_data[3]^f_5_data[2]^f_5_data[1]^f_5_data[0];
        kronecker = {f_8_data[7],f_8_data[6],f_8_data[5],f_8_data[4],f_8_data[3],f_8_data[2],f_8_data[1],f_8_data[0]};
    end
endfunction

assign kron_result = kronecker(din);

assign dout = {kron_result[200],kron_result[196],kron_result[194:192],kron_result[176],kron_result[168],kron_result[164],kron_result[162:160],kron_result[152],kron_result[149:144],kron_result[142:128],kron_result[112],kron_result[105:104],kron_result[102:96],kron_result[92],kron_result[90:88],kron_result[86:80],kron_result[78:64],kron_result[60],kron_result[58:56],kron_result[54:0]};


endmodule
