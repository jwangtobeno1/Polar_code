`include "defines.v"

module test
(
    input   wire    [`FUNC_G_BIT_LEN-1:0] llr_a,
    input   wire    [`FUNC_G_BIT_LEN-1:0] llr_b,

    output  wire    [`FUNC_G_BIT_LEN:0] llr_out
);

assign llr_out = llr_a + llr_b;

endmodule
