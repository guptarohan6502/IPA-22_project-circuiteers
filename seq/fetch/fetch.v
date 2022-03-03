// reads instructions from intruction memory 
// finding values of icode, ifun, rA, rB, valC using the instructions

` 1ns / 1ps

module fetch (clk, pc, 
                icode, ifun, rA, rB, 
                ivalid, ierror, valC, valP, out);

input clk;
input [63:0] pc;

output reg [3:0] icode;
output reg [3:0] ifun;

output reg [3:0] rA;
output reg [3:0] rB;

output reg ivalid; // instruction validity
output reg ierror; // instruction error

output reg [63:0] valC;
output reg [63:0] valP;

output reg out; 

reg [7:0] imem[0:1023]; // instruction memory
reg [0:79] instruct; 

always@ (posedge clk) begin
    ierror = 0; 
    if(pc > 1023)
    begin 
        ierror = 1; 
    end

    instruct = {
        mem[pc + 0], mem[pc + 1], mem[pc + 2], mem[pc + 3], mem[pc + 4], 
        mem[pc + 5], mem[pc + 6], mem[pc + 7], mem[pc + 8], mem[pc + 9]
    };

    icode = instruct[0:3]; 
    ifun = instruct[4:7];
    valid = 1'b1; // when icode is invalid, instruction valid = 0

    if(icode == 4'0000) // when halt, icode = 0
    begin 
        out = 1; // halt activated 
        valP = pc + 64'd1;
    end

    else if(icode == 4'b0001) // for nop, icode = 1
    begin 
        valP = pc + 64'd1;
    end 

    else if(icode == 4'b0010) // for cmovxx, icode = 2
    begin 
        rA = instruct[8:11];
        rB = instruct[12:15];
        valP = pc + 64'd2;
    end

    else if(icode == 4'b0011) // for irmovq, icode = 3
    begin
        rA = instruct[8:11];
        rB = instruct[12:15];
        valC = instruct[16:79];
        valP = pc + 64'd10;
    end

    else if(icode == 4'b0100) // for rmmovq, icode = 4
    begin
        rA = instruct[8:11];
        rB = instruct[12:15];
        valC = instruct[16:79];
        valP = pc + 64'd10;
    end

    else if (icode == 4'b0101) // for mrmovq, icode = 5
    begin
        rA = instruct[8:11];
        rB = instruct[12:15];
        valC = instruct[16:79];
        valP = pc + 64'd10;
    end

    else if (icode == 4'b0110) // for OPq, icode = 6
    begin
        rA = instruct[8:11];
        rB = instruct[12:15];
        valP = pc + 64'd2;
    end

    else if (icode == 4'b0111) // for jxx, icode = 7
    begin
        valC = instruct[8:71];
        valP = pc + 64'd9;
    end

    else if (icode == 4'b1000) // for call, icode = 8
    begin
        valC = instruct[8:71];
        valP = pc + 64'd9;
    end

    else if(icode == 4'b1001) // for ret, icode = 9
    begin
        valP = pc + 64'd1;
    end

    else if (icode == 4'b1010) // for pushq, icode = 10 
    begin
        rA = instruct[8:11];
        rB = instruct[12:15];
        valP = pc + 64'd2;
    end

    else if (icode == 4'b1011) // for popq, icode = 11
    begin
        rA = instruct[8:11];
        rB = instruct[12:15];
        valP = pc + 64'd2;
    end

   else 
   begin
       valid = 1'b0; // icode is invalid 
   end

end 

endmodule