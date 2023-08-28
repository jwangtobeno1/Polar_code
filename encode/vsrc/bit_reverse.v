module bit_reverse(
    input                   clk,
    input                   rst_n,
    input                   vld_i,
    input   [255:0]         din,
    output  reg     [255:0] dout,
    output  reg             vld_o
);

wire [255:0]    bit_reverse;
assign bit_reverse = {
			din[255],din[127],din[191],din[63 ],din[223],din[95 ],din[159],din[31 ],
			din[239],din[111],din[175],din[47 ],din[207],din[79 ],din[143],din[15 ],
			din[247],din[119],din[183],din[55 ],din[215],din[87 ],din[151],din[23 ],
			din[231],din[103],din[167],din[39 ],din[199],din[71 ],din[135],din[7  ],
			din[251],din[123],din[187],din[59 ],din[219],din[91 ],din[155],din[27 ],
			din[235],din[107],din[171],din[43 ],din[203],din[75 ],din[139],din[11 ],
			din[243],din[115],din[179],din[51 ],din[211],din[83 ],din[147],din[19 ],
			din[227],din[99 ],din[163],din[35 ],din[195],din[67 ],din[131],din[3  ],
			din[253],din[125],din[189],din[61 ],din[221],din[93 ],din[157],din[29 ],
			din[237],din[109],din[173],din[45 ],din[205],din[77 ],din[141],din[13 ],
			din[245],din[117],din[181],din[53 ],din[213],din[85 ],din[149],din[21 ],
			din[229],din[101],din[165],din[37 ],din[197],din[69 ],din[133],din[5  ],
			din[249],din[121],din[185],din[57 ],din[217],din[89 ],din[153],din[25 ],
			din[233],din[105],din[169],din[41 ],din[201],din[73 ],din[137],din[9  ],
			din[241],din[113],din[177],din[49 ],din[209],din[81 ],din[145],din[17 ],
			din[225],din[97 ],din[161],din[33 ],din[193],din[65 ],din[129],din[1  ],
			din[254],din[126],din[190],din[62 ],din[222],din[94 ],din[158],din[30 ],
			din[238],din[110],din[174],din[46 ],din[206],din[78 ],din[142],din[14 ],
			din[246],din[118],din[182],din[54 ],din[214],din[86 ],din[150],din[22 ],
			din[230],din[102],din[166],din[38 ],din[198],din[70 ],din[134],din[6  ],
			din[250],din[122],din[186],din[58 ],din[218],din[90 ],din[154],din[26 ],
			din[234],din[106],din[170],din[42 ],din[202],din[74 ],din[138],din[10 ],
			din[242],din[114],din[178],din[50 ],din[210],din[82 ],din[146],din[18 ],
			din[226],din[98 ],din[162],din[34 ],din[194],din[66 ],din[130],din[2  ],
			din[252],din[124],din[188],din[60 ],din[220],din[92 ],din[156],din[28 ],
			din[236],din[108],din[172],din[44 ],din[204],din[76 ],din[140],din[12 ],
			din[244],din[116],din[180],din[52 ],din[212],din[84 ],din[148],din[20 ],
			din[228],din[100],din[164],din[36 ],din[196],din[68 ],din[132],din[4  ],
			din[248],din[120],din[184],din[56 ],din[216],din[88 ],din[152],din[24 ],
			din[232],din[104],din[168],din[40 ],din[200],din[72 ],din[136],din[8  ],
			din[240],din[112],din[176],din[48 ],din[208],din[80 ],din[144],din[16 ],
			din[224],din[96 ],din[160],din[32 ],din[192],din[64 ],din[128],din[0  ]
		};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        vld_o <= 1'b0;
    else if(vld_i)
        vld_o <= 1'b1;
    else
        vld_o <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        dout <= 'd0;
    else if(vld_i)
        dout <= bit_reverse;
end

endmodule
