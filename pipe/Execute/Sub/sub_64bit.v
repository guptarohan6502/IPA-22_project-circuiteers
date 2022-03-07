`timescale 1ns / 1ps


module sub_64bit (a, b, out, cf_sub);

input signed [63:0]a;
input signed [63:0]b;
output signed [63:0]out;
output reg[2:0] cf_sub;


wire [2:0]overflow;
wire [2:0] fadd;
wire [63:0]no; // no = not output
not_64bit g1(b, no); // inverting bits of input b

wire [63:0]finv; // for final inversion
assign finv = 64'b1;

wire [63:0]add_finv;


add_64bit g2(finv, no, add_finv, fadd);

add_64bit g3(a, add_finv, out, overflow);

always @(*) begin

if (out == 64'd0) begin
	cf_sub[0] = 1'b1;
	

end else cf_sub[0] = 1'b0;

if(out[63]==1'b1) begin
	cf_sub[1] = 1'b1;
end else cf_sub[1] = 1'b0;

cf_sub[2] = overflow[2];

end

endmodule