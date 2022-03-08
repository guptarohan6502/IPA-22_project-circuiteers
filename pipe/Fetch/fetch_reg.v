<<<<<<< HEAD
module FETCH_REG(clk, predict_pc, F_pred_PC);
=======
module FETCH_REG(clk,F_stall,predict_pc, F_pred_PC);
>>>>>>> 4fee24f8a7d8700132833b62b89fa82ea028af55

input clk;
input F_stall;
input [63:0] predict_pc;
output reg[63:0] F_pred_PC;


always @(posedge(clk)) begin
	
	if(!F_stall) begin
		F_pred_PC <= predict_pc;

	end
	
end

endmodule


