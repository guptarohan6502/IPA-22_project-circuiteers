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
    clk = 0; 
    pc = 64'd0;

    

end

endmodule