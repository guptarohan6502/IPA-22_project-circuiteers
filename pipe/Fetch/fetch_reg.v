module FETCH_REG(clk, predict_pc, F_pred_PC);

input clk;
input [63:0] predict_pc;
output reg[63:0] F_pred_PC;


always @(posedge(clk)) begin
	
	F_pred_PC <= predict_pc;

end

endmodule


