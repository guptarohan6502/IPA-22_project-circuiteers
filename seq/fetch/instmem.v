module instruction_memory(clk,pc,imem_error,Byte0,Byte19);

input clk;
input[63:0] pc;
output imem_error;
output [7:0] Byte0;
output [71:0] Byte19;

reg [7:0] instr_mem[2047:0];

// irmovq $8 %r8
instr_mem[112] = 8'b00110000; //icode ifun
instr_mem[113] = 8'b11111000; //reg
instr_mem[114] = 8'b01000000;
instr_mem[115] = 8'b00000000;
instr_mem[116] = 8'b00000000;
instr_mem[117] = 8'b00000000;
instr_mem[118] = 8'b00000000;
instr_mem[119] = 8'b00000000;
instr_mem[120] = 8'b00000000;
instr_mem[121] = 8'b00000000;
// irmovq %1 %rd
instr_mem[122] = 8'b00110000; //icode ifun
instr_mem[123] = 8'b11111001; //reg
instr_mem[124] = 8'b00010000;
instr_mem[125] = 8'b00000000;
instr_mem[126] = 8'b00000000;
instr_mem[127] = 8'b00000000;
instr_mem[128] = 8'b00000000;
instr_mem[129] = 8'b00000000;
instr_mem[130] = 8'b00000000;
instr_mem[131] = 8'b00000000;
// xorq %rax % rax
instr_mem[132] = 8'b00110011; //icode ifun
instr_mem[133] = 8'b00000000; //reg

// andq %rsi %rsi -- set CC
instr_mem[133] = 8'b00110010; //icode ifun
instr_mem[134] = 8'b00000110; //reg
// jmp test- some memory address
instr_mem[133] = 8'b01110000; //icode ifun
instr_mem[134] = 8'b01100110; //reg
instr_mem[124] = 8'b00010000;
instr_mem[125] = 8'b00000000;
instr_mem[126] = 8'b00000000;
instr_mem[127] = 8'b00000000;
instr_mem[128] = 8'b00000000;
instr_mem[129] = 8'b00000000;
instr_mem[130] = 8'b00000000;
instr_mem[131] = 8'b00000000;
//test:


// loop:


always @(posedge(clk)) begin


	
end


endmodule