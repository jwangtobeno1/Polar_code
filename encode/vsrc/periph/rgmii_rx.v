module rgmii_rx(
    input           rgmii_rxc   ,
    input           rgmii_rx_ctl,
    input   [3:0]   rgmii_rxd   ,

    output          gmii_rx_clk ,
    output          gmii_rx_dv  ,
    output  [7:0]   gmii_rxd
);

wire [1:0]  gmii_rxdv_t;  //两位gmii接收有效信号

assign gmii_rx_clk = rgmii_rxc;
assign gmii_rx_dv = gmii_rxdv_t[0] & gmii_rxdv_t[1];

IDDR2 #(
   .DDR_ALIGNMENT("C0"), // Sets output alignment to "NONE", "C0" or "C1"
   .INIT_Q0(1'b0), // Sets initial state of the Q0 output to 1'b0 or 1'b1
   .INIT_Q1(1'b0), // Sets initial state of the Q1 output to 1'b0 or 1'b1
   .SRTYPE("ASYNC") // Specifies "SYNC" or "ASYNC" set/reset
) u_iddr_rx_ctl (
   .Q0(gmii_rxdv_t[0]), // 1-bit output captured with C0 clock
   .Q1(gmii_rxdv_t[1]), // 1-bit output captured with C1 clock
   .C0(rgmii_rxc), // 1-bit clock input
   .C1(~rgmii_rxc), // 1-bit clock input
   .CE(1'b1), // 1-bit clock enable input
   .D(rgmii_rx_ctl),   // 1-bit DDR data input
   .R(1'b0),   // 1-bit reset input
   .S(1'b0)    // 1-bit set input
);

genvar i;
generate for(i = 0; i < 4; i = i + 1)
    begin : rxdata_bus

        IDDR2 #(
           .DDR_ALIGNMENT("C0"), // Sets output alignment to "NONE", "C0" or "C1"
           .INIT_Q0(1'b0), // Sets initial state of the Q0 output to 1'b0 or 1'b1
           .INIT_Q1(1'b0), // Sets initial state of the Q1 output to 1'b0 or 1'b1
           .SRTYPE("ASYNC") // Specifies "SYNC" or "ASYNC" set/reset
        ) u_iddr_rxd (
           .Q0(gmii_rxd[4+i]), // 1-bit output captured with C0 clock
           .Q1(gmii_rxd[i]), // 1-bit output captured with C1 clock
           .C0(rgmii_rxc), // 1-bit clock input
           .C1(~rgmii_rxc), // 1-bit clock input
           .CE(1'b1), // 1-bit clock enable input
           .D(rgmii_rxd[i]),   // 1-bit DDR data input
           .R(1'b0),   // 1-bit reset input
           .S(1'b0)    // 1-bit set input
        );
    end
endgenerate

endmodule