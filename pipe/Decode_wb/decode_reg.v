module DECODE_REG(clk,f_stat,f_icode,f_ifun,f_rA,f_rB,f_valC,f_valP
D_stat,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP);

input clk;
input [2:0]f_stat;
input [3:0]f_icode; 
input [3:0]f_ifun; 
input [3:0]f_rA;
input [3:0]f_rB;
input [63:0]f_valC;
input [63:0]f_valP;

output reg [2:0] D_stat;
output reg [3:0] D_icode; 
output reg [3:0] D_ifun;
output reg [3:0] D_rA;
output reg [3:0] D_rB;
output reg [63:0] D_valC;
output reg [63:0] D_valP;






endmodule