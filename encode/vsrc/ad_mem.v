`timescale 1ns/1ps

module ad_mem #(

  parameter  DATA_WIDTH = 16,
  parameter  ADDRESS_WIDTH = 5) (

  input                               clka,
  input                               wea,
  input       [(ADDRESS_WIDTH-1):0]   addra,
  input       [(DATA_WIDTH-1):0]      dina,

  input                               clkb,
  input                               reb,
  input       [(ADDRESS_WIDTH-1):0]   addrb,
  output  reg [(DATA_WIDTH-1):0]      doutb);

  (* ram_style = "block" *)
  reg         [(DATA_WIDTH-1):0]      m_ram[0:((2**ADDRESS_WIDTH)-1)];

  always @(posedge clka) begin
    if (wea == 1'b1) begin
      m_ram[addra] <= dina;
    end
  end

  always @(posedge clkb) begin
    if (reb == 1'b1) begin
      doutb <= m_ram[addrb];
    end
  end

endmodule

// ***************************************************************************
// ***************************************************************************
