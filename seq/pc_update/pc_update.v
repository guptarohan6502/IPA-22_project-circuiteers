`timescale 1ns / 1ps

module pc_update(clk,cnd, pc, icode, valC, valM, valP, pc);

input clk, cnd;
input [63:0] valC; 
input [63:0] valM; 
input [63:0] valP;  
input [63:0] pc;
input [3:0] icode;

output reg [63:0] pc;

always@(posedge(clk)) begin
    

    if (icode == 4'b0111) //icode = 7
    begin
        if(cnd == 1'b1)
        begin
            pc <= valC;
        end
        else 
            pc <= valP;
        end
    end

    else if (icode == 4'b1000) // icode = 8; for call
    begin 
        pc <= valC;
    end

    else if (icode == 4'b1001) // icode = 9; for ret 
    begin
        pc <= valM;
    end
    else if(icode == 4'b0000) begin
        pc <= pc; ///doubt how to stop updating pc
    end
    else
    begin
        pc<= valP;
    end

end

endmodule