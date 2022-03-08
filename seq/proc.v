'timescale 1ns / 1ps

`include "../fetch/fetch.v"
`include "../fetch/instrmem.v"
`include "../decode/decode.v"
`include "../Execute/execute.v"
`include "../memory/ram.v"
`include "../pc_update/pc_update.v"

module proc;

reg clk; 
reg [63:0] pc;
reg halt;

// fetch, intruction memory
wire [3:0] icode;
wire [3:0] ifun;
reg [7:0] Byte0;
reg [71:0] Byte19;
wire need_valC;
wire need_regids;
wire [63:0] valC;
wire [3:0] rA;
wire [3:0] rB;
wire [63:0] valP;
wire imem_error;
wire instr_valid; // reg or wire?

// decode
wire [3:0] dstE;
wire [3:0] dstM;
wire [3:0] srcA;
wire [3:0] srcB;
wire [63:0] valE;
wire [63:0] valM;
wire [63:0] register_file[14:0];

// execute
wire [63:0] aluA;
wire [63:0] aluB;
wire [1:0] alufun;
wire [63:0] valE;
wire [2:0] cf;
wire signed [63:0] out1;
wire [2:0] cf_add;
wire signed [63:0] out2;
wire [2:0] cf_sub;
wire signed [63:0] out3;
wire [2:0] cf_and;
wire signed [63:0] out4;
wire [2:0] cf_xor;
wire [2:0] outf;
wire cnd;

// memory
wire [63:0] memaddr;
wire [63:0] memdata;
wire read;
wire write;
wire [63:0] memory[8191:0];
wire [63:0] valM;
wire dmemerror;
reg [2:0] stat;

// clock signal
reg clk = 1'b1;
integer k = 0;

// fetch
split sp(.Byte0(Byte0), .icode(icode), .ifun(ifun));
align al(.Byte19(Byte19), .need_regids(need_regids), .rA(rA), .rB(rB), .valC(valC));
PC_INCREMENT PC_i(.pc(pc), .need_regids(need_regids), .need_valC(need_valC), .valP(valP));
INSTR_VALID i_valid(.icode(icode), .instr_valid(instr_valid));
Need_REGIDS nreg(.icode(icode), .need_regids(need_regids));
Need_VALC n_valC(.icode(icode), .need_valC(need_valC));

// decode 
registerfile reg_f(.clk(clk), .dstE(dstE), .dstM(dstM), .srcA(srcA) , .srcB(srcB) , .valA(valA) , .valB(valB) , .valM(valM), .valE(valE));
srcA_logic sA_l(.icode(icode), .rA(rA), .srcA(srcA));
srcB_logic sB_l(.icode(icode), .rB(rB), .srcB(srcB));
dstE_logic dE_l(.icode(icode), .rB(rB), .cnd(cnd), .ifun(ifun), .dstE(dstE));
dstM_logic dM_l(.icode(icode), .rA(rA), .dstM(dstM));

// execute 
alu_block alulogic(.aluA(aluA), .aluB(aluB), .alufun(alufun), .cf(cf), .valE(valE));
ALU_A alualogic(.icode(icode), .valA(valA), .valC(valC), .aluA(aluA));
ALU_B alublogic(.icode(icode), .valB(valB), .aluB(aluB));
ALU_fun alufunlogic(.icode(icode), .ifun(ifun), .alufun(alufun));
set_CC cclogiv(.icode(icode), .cf(cf), .outf(outf));
CND cndlogic(.ifun(ifun), .outf(outf), .cnd(cnd));

// memory
RAM ram1(.memaddr(memaddr), .memdata(memdata), .read(read), .write(write), .valM(valM), .dmemerror(dmemerror));
MEM_addr Ma(.icode(icode), .valA(valA), .valE(valE), .memaddr(memaddr));
MEM_read Mr(.icode(icode), .read(read));
MEM_write Mw(.icode(icode), .write(write));
MEM_data Md(.icode(icode), .valA(valA), .valP(valP), .memdata(memdata));    

// PC Update
pc_update pc_new(.clk(clk), .cnd(cnd), .pc(pc), .icode(icode), .valC(valC), .valM(valM), .valP(valP), .newpc(newpc));

initial
begin

    $dumpfile("proc.vcd");
    $dumpvars(0, proc);
    // $readmemh("rom.mem", instr_mem);

end

always @(posedge clk)
      begin    
        pc <= newpC;
        

      end

    always @(pc)
    begin
      Byte19<= instr_mem[pc];
      Byte19[71:64] <= instr_mem[pc+1];
      Byte19[63:56] <= instr_mem[pc+2];
      Byte19[55:48] <= instr_mem[pc+3];
      Byte19[47:40] <= instr_mem[pc+4];
      Byte19[39:32] <= instr_mem[pc+5];
      Byte19[31:24] <= instr_mem[pc+6];
      Byte19[23:16] <= instr_mem[pc+7];
      Byte19[15:8] <= instr_mem[pc+8];
      Byte19[7:0] <= instr_mem[pc+9];
      if( icode == 4'h0)

        $finish;

    end

    always #10 clk = ~clk;

endmodule