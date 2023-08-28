module kron_5(
    input               clk,
    input               rst_n,
    input       [31:0]  din,
    
    output  reg [31:0]  dout
);

wire    [31:0]  kron_5;
assign kron_5 = {
			^din,
			din[30]^din[28]^din[26]^din[24]^din[22]^din[20]^din[18]^din[16]^din[14]^din[12]^din[10]^din[8]^din[6]^din[4]^din[2]^din[0],
			din[29]^din[28]^din[25]^din[24]^din[21]^din[20]^din[17]^din[16]^din[13]^din[12]^din[9]^din[8]^din[5]^din[4]^din[1]^din[0],
			din[28]^din[24]^din[20]^din[16]^din[12]^din[8]^din[4]^din[0],
			din[27]^din[26]^din[25]^din[24]^din[19]^din[18]^din[17]^din[16]^din[11]^din[10]^din[9]^din[8]^din[3]^din[2]^din[1]^din[0],
			din[26]^din[24]^din[18]^din[16]^din[10]^din[8]^din[2]^din[0],
			din[25]^din[24]^din[17]^din[16]^din[9]^din[8]^din[1]^din[0],
			din[24]^din[16]^din[8]^din[0],
			din[23]^din[22]^din[21]^din[20]^din[19]^din[18]^din[17]^din[16]^din[7]^din[6]^din[5]^din[4]^din[3]^din[2]^din[1]^din[0],
			din[22]^din[20]^din[18]^din[16]^din[6]^din[4]^din[2]^din[0],
			din[21]^din[20]^din[17]^din[16]^din[5]^din[4]^din[1]^din[0],
			din[20]^din[16]^din[4]^din[0],
			din[19]^din[18]^din[17]^din[16]^din[3]^din[2]^din[1]^din[0],
			din[18]^din[16]^din[2]^din[0],
			din[17]^din[16]^din[1]^din[0],
			din[16]^din[0],
			
			din[15]^din[14]^din[13]^din[12]^din[11]^din[10]^din[9]^din[8]^din[7]^din[6]^din[5]^din[4]^din[3]^din[2]^din[1]^din[0],
			din[14]^din[12]^din[10]^din[8]^din[6]^din[4]^din[2]^din[0],
			din[13]^din[12]^din[9]^din[8]^din[5]^din[4]^din[1]^din[0],
			din[12]^din[8]^din[4]^din[0],
			din[11]^din[10]^din[9]^din[8]^din[3]^din[2]^din[1]^din[0],
			din[10]^din[8]^din[2]^din[0],
			din[9]^din[8]^din[1]^din[0],
			din[8]^din[0],   //8
			din[7]^din[6]^din[5]^din[4]^din[3]^din[2]^din[1]^din[0],
			din[6]^din[4]^din[2]^din[0],
			din[5]^din[4]^din[1]^din[0],
			din[4]^din[0],
			din[3]^din[2]^din[1]^din[0],
			din[2]^din[0],
			din[1]^din[0],
			din[0]
		};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        dout <= 'd0;
    else
        dout <= kron_5;
end

endmodule
