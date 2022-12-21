//======================================================
//Filename                : .v
//Author                  : WangJie
//Created On              : 2022-12-16 20:52
//Last Modified           : 
//Description             : 
//                          
//======================================================
`include "defines.v"
module instmem(
    input   wire    [7:0]   addr,
    input   wire            en,
    output  wire    [11:0]  inst
);

reg [11:0]  inst_mem[(`CNT_INST_MAX-1'b1):0];

initial begin
    $readmemb("/hdd/Projects/Polar_code/decode/vsrc/inst.txt",inst_mem);
end

assign inst = (en) ? inst_mem[addr] : 12'b0;

endmodule
