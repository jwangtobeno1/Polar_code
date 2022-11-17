module bit_reverse(
	input			clk		,
	input			rst_n	,
	input	[255:0]	data_in	,
	output			data_out
);

reg	[255:0]	cnt;

reg	[255:0]	data_reverse;

data_reverse = {
	data_in[0  ],data_in[128],data_in[64 ],data_in[192],data_in[32 ],data_in[160],data_in[96 ],data_in[224],
	data_in[16 ],data_in[144],data_in[80 ],data_in[208],data_in[48 ],data_in[176],data_in[112],data_in[240],
	data_in[8  ],data_in[136],data_in[72 ],data_in[200],data_in[40 ],data_in[168],data_in[104],data_in[232],
	data_in[24 ],data_in[152],data_in[88 ],data_in[216],data_in[56 ],data_in[184],data_in[120],data_in[248],
	data_in[4  ],data_in[132],data_in[68 ],data_in[196],data_in[36 ],data_in[164],data_in[100],data_in[228],
	data_in[20 ],data_in[148],data_in[84 ],data_in[212],data_in[52 ],data_in[180],data_in[116],data_in[244],
	data_in[12 ],data_in[140],data_in[76 ],data_in[204],data_in[44 ],data_in[172],data_in[108],data_in[236],
	data_in[28 ],data_in[156],data_in[92 ],data_in[220],data_in[60 ],data_in[188],data_in[124],data_in[252],
	data_in[2  ],data_in[130],data_in[66 ],data_in[194],data_in[34 ],data_in[162],data_in[98 ],data_in[226],
	data_in[18 ],data_in[146],data_in[82 ],data_in[210],data_in[50 ],data_in[178],data_in[114],data_in[242],
	data_in[10 ],data_in[138],data_in[74 ],data_in[202],data_in[42 ],data_in[170],data_in[106],data_in[234],
	data_in[26 ],data_in[154],data_in[90 ],data_in[218],data_in[58 ],data_in[186],data_in[122],data_in[250],
	data_in[6  ],data_in[134],data_in[70 ],data_in[198],data_in[38 ],data_in[166],data_in[102],data_in[230],
	data_in[22 ],data_in[150],data_in[86 ],data_in[214],data_in[54 ],data_in[182],data_in[118],data_in[246],
	data_in[14 ],data_in[142],data_in[78 ],data_in[206],data_in[46 ],data_in[174],data_in[110],data_in[238],
	data_in[30 ],data_in[158],data_in[94 ],data_in[222],data_in[62 ],data_in[190],data_in[126],data_in[254],
	data_in[1  ],data_in[129],data_in[65 ],data_in[193],data_in[33 ],data_in[161],data_in[97 ],data_in[225],
	data_in[17 ],data_in[145],data_in[81 ],data_in[209],data_in[49 ],data_in[177],data_in[113],data_in[241],
	data_in[9  ],data_in[137],data_in[73 ],data_in[201],data_in[41 ],data_in[169],data_in[105],data_in[233],
	data_in[25 ],data_in[153],data_in[89 ],data_in[217],data_in[57 ],data_in[185],data_in[121],data_in[249],
	data_in[5  ],data_in[133],data_in[69 ],data_in[197],data_in[37 ],data_in[165],data_in[101],data_in[229],
	data_in[21 ],data_in[149],data_in[85 ],data_in[213],data_in[53 ],data_in[181],data_in[117],data_in[245],
	data_in[13 ],data_in[141],data_in[77 ],data_in[205],data_in[45 ],data_in[173],data_in[109],data_in[237],
	data_in[29 ],data_in[157],data_in[93 ],data_in[221],data_in[61 ],data_in[189],data_in[125],data_in[253],
	data_in[3  ],data_in[131],data_in[67 ],data_in[195],data_in[35 ],data_in[163],data_in[99 ],data_in[227],
	data_in[19 ],data_in[147],data_in[83 ],data_in[211],data_in[51 ],data_in[179],data_in[115],data_in[243],
	data_in[11 ],data_in[139],data_in[75 ],data_in[203],data_in[43 ],data_in[171],data_in[107],data_in[235],
	data_in[27 ],data_in[155],data_in[91 ],data_in[219],data_in[59 ],data_in[187],data_in[123],data_in[251],
	data_in[7  ],data_in[135],data_in[71 ],data_in[199],data_in[39 ],data_in[167],data_in[103],data_in[231],
	data_in[23 ],data_in[151],data_in[87 ],data_in[215],data_in[55 ],data_in[183],data_in[119],data_in[247],
	data_in[15 ],data_in[143],data_in[79 ],data_in[207],data_in[47 ],data_in[175],data_in[111],data_in[239],
	data_in[31 ],data_in[159],data_in[95 ],data_in[223],data_in[63 ],data_in[191],data_in[127],data_in[255]
};

always@(posedge clk or rst_n)	begin
	if(!rst_n)
		cnt <= 0;
	else if(cnt == 9'd255)
		cnt <= 0;
	else
		cnt <= cnt + 1'b1;
end

endmodule