module instruction_memory(clk, f_pc, imem_error, Byte0, Byte19);

input clk;
input[63:0] f_pc;
output reg imem_error;
output reg[7:0] Byte0;
output reg[71:0] Byte19;

reg [7:0] instr_mem[2047:0];
initial begin
	

//irmovq %16 %r12

//rmmovq %r12 (%rdi)

//call

//halt



// irmovq $8 %r8
instr_mem[112] = 8'b00110000; //icode ifun
instr_mem[113] = 8'b11111000; //reg
instr_mem[114] = 8'b00001000;
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
instr_mem[124] = 8'b00000001;
instr_mem[125] = 8'b00000000;
instr_mem[126] = 8'b00000000;
instr_mem[127] = 8'b00000000;
instr_mem[128] = 8'b00000000;
instr_mem[129] = 8'b00000000;
instr_mem[130] = 8'b00000000;
instr_mem[131] = 8'b00000000;
// xorq %rax % rax  %rax =0
instr_mem[132] = 8'b01100011; //icode ifun
instr_mem[133] = 8'b00000000; //reg

// andq %rsi %rsi -- set CC %rsi =6
instr_mem[133] = 8'b01100010; //icode ifun
instr_mem[134] = 8'b01100110; //reg
// jmp test- some memory address
instr_mem[133] = 8'b01110000; //icode ifun
instr_mem[134] = 8'b01100110; //reg
instr_mem[135] = 8'b00010000;
instr_mem[136] = 8'b00000000;
instr_mem[137] = 8'b00000000;
instr_mem[138] = 8'b00000000;
instr_mem[139] = 8'b00000000;
instr_mem[140] = 8'b00000000;
instr_mem[141] = 8'b00000000;
instr_mem[142] = 8'b00000000;


// loop:
instr_mem[143] = 8'b01100001; //icode ifun
instr_mem[144] = 8'b01100110; //reg

//test:
//jne loop;
instr_mem[145] = 8'b01110000; //icode ifun
instr_mem[146] = 8'b11110100; //
instr_mem[147] = 8'b00000000; //
instr_mem[148] = 8'b00000000; //
instr_mem[149] = 8'b00000000; //
instr_mem[150] = 8'b00000000; //
instr_mem[151] = 8'b00000000; //
instr_mem[152] = 8'b00000000; //
instr_mem[153] = 8'b00000000; //

//ret

end

always @(f_pc)) begin

	if(pc > 64'd2047) begin
		imem_error <= 1'b1;
		Byte0 <= 8'b00000000;

	end
	else begin
		imem_error = 1'b0;
		Byte0 = instr_mem[f_pc];
		Byte19[71:64] <=instr_mem[f_pc+1];
		Byte19[63:56] <=instr_mem[f_pc+2];
		Byte19[55:48] <=instr_mem[f_pc+3];
		Byte19[47:40] <=instr_mem[f_pc+4];
		Byte19[39:32] <=instr_mem[f_pc+5];
		Byte19[31:24] <=instr_mem[f_pc+6];
		Byte19[23:16] <=instr_mem[f_pc+7];
		Byte19[15:8] <=instr_mem[f_pc+8];
		Byte19[7:0] <=instr_mem[f_pc+9];
		
	end
		
end

endmodule