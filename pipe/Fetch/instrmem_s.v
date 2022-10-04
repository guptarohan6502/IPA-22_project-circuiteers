module instruction_memory(clk, f_pc, imem_error, Byte0, Byte19);

input clk;
input[63:0] f_pc;
output reg imem_error;
output reg[7:0] Byte0;
output reg[71:0] Byte19;

reg [0:7] instr_mem[0:2047];

initial begin
        instr_mem[0] = 8'b01100000; //6 add
        instr_mem[1] = 8'b00000011; //%rax %rbx 
        instr_mem[2] = 8'b00010000; //no operation 

        instr_mem[3] = 8'b01100001; //6 subtract
        instr_mem[4] = 8'b00000010; //%rax %rdx

        instr_mem[5] = 8'b01000000; //4-rmmovq 
        instr_mem[6] = 8'b00000011; //rax and (rbx)
        instr_mem[7] = 8'b01010101; //VALC ---->from 6 to 13
        instr_mem[8] = 8'b01010101;
        instr_mem[9] = 8'b01010101;
        instr_mem[10] = 8'b01010101;
        instr_mem[11] = 8'b01010101;
        instr_mem[12] = 8'b01010101;
        instr_mem[13] = 8'b01010101;
        instr_mem[14] = 8'b01010101;

        instr_mem[15] = 8'b00010000; //no operation
        instr_mem[16] = 8'b00010000; //no operation
        instr_mem[17] = 8'b00000000; //halt
    end


always @(*) begin

	if(f_pc > 64'd2047) begin
		imem_error <= 1'b1;
		Byte0 <= 8'b00000000;

	end
	else begin
		imem_error = 1'b0;
		Byte0 = instr_mem[f_pc];
		Byte19[7:0] <= instr_mem[f_pc+1];
		Byte19[15:8] <= instr_mem[f_pc+2];
		Byte19[23:16] <= instr_mem[f_pc+3];
		Byte19[31:24] <= instr_mem[f_pc+4];
		Byte19[39:32] <= instr_mem[f_pc+5];
		Byte19[47:40] <= instr_mem[f_pc+6];
		Byte19[55:48] <= instr_mem[f_pc+7];
		Byte19[63:56] <= instr_mem[f_pc+8];
		Byte19[71:64] <= instr_mem[f_pc+9];

		
	end	
end

endmodule