module WRITE_REG(clk,m_stat,m_icode,M_valE,m_valA,M_dstE,M_dstM
W_stat,W_icode,W_valE,W_valM,W_dstE,W_dstM);

input clk;
input [2:0]m_stat;
input [3:0]m_icode; 
input [63:0]m_valA; 
input [63:0]M_valE;
input [3:0]M_dstE;
input [3:0]M_dstM;

output reg [2:0] W_stat;
output reg [3:0] W_icode; 
output reg [3:0] W_dstE;
output reg [3:0] W_dstM;
output reg [63:0] W_valE;
output reg [63:0] W_valM;


endmodule
