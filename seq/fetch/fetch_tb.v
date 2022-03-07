`timescale 1ns / 1ps

module fetch_tb; 

reg clk; 
reg [63:0] pc; 

wire [3:0] icode; 
wire [3:0] ifun;

wire [3:0] rA;
wire [3:0] rB;

wire [63:0] valP;
wire [63:0] valC;

reg [7:0] instr_mem [2047:0];

split sp(.Byte0(Byte0), .icode(icode), .ifun(ifun));
align al(.Byte19(Byte19), .need_regids(need_regids), .rA(rA), .rB(rB), .valC(valC));
PC_INCREMENT PC_i(.pc(pc), .need_regids(need_regids), .need_valC(need_valC), .valP(valP));
INSTR_VALID i_valid(.icode(icode), .instr_valid(instr_valid));
Need_REGIDS nreg(.icode(icode), .need_regids(need_regids));
Need_VALC n_valC(.icode(icode), .need_valC(need_valC));



initial begin
    $dumpfile("fetch_test.vcd");
    $dumpvars(0, fetch_test);

    clk = 0; 
    pc = 64'd0;

    #10 clk = ~clk;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
    #10 clk = ~clk; pc=valP;
    #10 clk = ~clk; 
  end  
  
initial 
		$monitor("clk=%d, pc=%d, icode=%b, ifun=%b, rA=%b, rB=%b, valC=%d, valP=%d\n", clk, pc, icode, ifun, rA, rB, valC, valP);

end

endmodule