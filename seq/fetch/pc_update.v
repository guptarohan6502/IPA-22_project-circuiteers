`timescale 1ns / 1ps

module pc_update(clk, pc, icode, valC, valM, valP, pc_updated, cnd);

input clk, cnd;
input [63:0] valC; // fpr call purpose 
input [63:0] valM; // for ret purpose 
input [63:0] valP; // for all other instructions other than call and ret 
                   // used for the computation of a specific value 
input [63:0] pc;
input [3:0] icode;

output reg [63:0] pc_updated;

always@(*) begin
    if (icode == 4'b0111) //icode = 7
    begin
        if(cnd == 1'b1)
        begin
            pc_updated = valC;
        end
        else 
            pc_updated = valP;
        end
    end

    else if (icode == 4'b1000) // icode = 8; for call
    begin 
        pc_updated = valC;
    end

    else if (icode == 4'b1001) // icode = 9; for ret 
    begin
        pc_updated = valM;
    end

    else
    begin
        pc_updated = valP;
    end

end

endmodule