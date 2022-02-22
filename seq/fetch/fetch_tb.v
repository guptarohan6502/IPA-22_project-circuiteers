`timescale 1ns / 1ps

module fetch_tb; 

reg lk; 
reg [63:0] pc; 

wire [3:0] icode; 
wire [3:0] ifun;

wire [3:0] rA;
wire [3:0] rB;

wire [63:0] valP;
wire [63:0] valC;

fetch dut(.clk(clk), .pc(pc), 
          .icode(icode), .ifun(ifun), 
          .rA(rA), .rB(rB),
          .valP(valP),
          .valC(valC) );

initial begin
    $dumpfile("fetch_test.vcd");
    $dumpvars(0, fetch_test);

    clk = 0; 
    pc = 64'd0;

    #10 clk=~clk; pc=64'd32;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    #10 clk=~clk; pc=valP;
    
  end 
  always #10 clk = ~clk;
  
  initial 
		$monitor("clk=%d, pc=%d, icode=%b, ifun=%b, rA=%b, rB=%b,valC=%d,valP=%d\n",clk,pc,icode,ifun,rA,rB,valC,valP);

end

endmodule