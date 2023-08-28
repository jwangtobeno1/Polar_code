module bit_mix(
    input               clk,
    input               rst_n,
    input               vld_i,
    input   [127:0]     din,

    output  reg [255:0] dout,
    output  reg         vld_o
);

wire [255:0]    bit_mix;
assign bit_mix = {
			55'b0,din[127]  ,3'b0,din[126]    ,1'b0,din[125:123],15'b0,din[122]    ,7'b0,din[121],
			3'b0 ,din[120]  ,1'b0,din[119:117],7'b0,din[116]    ,2'b0 ,din[115:110],1'b0,din[109:95],
			15'b0,din[94 ]  ,6'b0,din[93:92]  ,1'b0,din[91:85]  ,3'b0 ,din[84]     ,1'b0,din[83:81],
			1'b0 ,din[80:74],1'b0,din[73:59]  ,3'b0,din[58 ]    ,1'b0 ,din[57:55]  ,1'b0,din[54:0] //88ä¸?
		};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        dout <= 'd0;
    else if(vld_i)
        dout <= bit_mix;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        vld_o <= 1'b0;
    else if(vld_i)
        vld_o <= 1'b1;
    else
        vld_o <= 1'b0;
end

endmodule
