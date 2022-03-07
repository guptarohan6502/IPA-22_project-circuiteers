
module PIPE_CONTROL_LOGIC(clk, );

input clk;
input [3:0] D_icode;
input [3:0] d_srcA;
input [3:0] d_srcB;
input [3:0] E_icode;
input [3:0] E_dstM;
input e_Cnd;
input [3:0] M_icode;
input [2:0] m_stat;
input [2:0] W_stat;

output reg F_stall;
output reg D_stall;
output reg D_bubble;
output reg E_bubble;
output reg M_bubble;
output reg W_stall;


parameter SBUB = 3'h0;
parameter SAOK = 3'h1;
parameter SHLT = 3'h2;
parameter SADR = 3'h3;
parameter SINS = 3'h4;


    initial
    begin
        F_stall <= 1'b0;
        D_stall <= 1'b0; 
        D_bubble <= 1'b0;
        E_bubble <= 1'b0;
        M_bubble <= 1'b0;
        W_stall <= 1'b0; 
    end


    always @(*) begin
	    
    end

endmodule