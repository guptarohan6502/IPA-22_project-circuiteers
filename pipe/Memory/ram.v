`timescale 1ns / 1ps

module RAM(memaddr, memdata, read, write, valM, dmemerror);

input[63:0] memaddr;
input[63:0] memdata;
input read;
input write;

reg [63:0] memory[8191:0]; 

output reg[63:0] valM;
output reg dmemerror;


always @(write, read, memdata, memaddr) begin

	if(read && !write) begin
		valM <= memory[memaddr];
	end

	if(write && !read) begin
		memory[memaddr] <= valM;
	end

	if (memaddr >= 64'd258) begin
		dmemerror <= 1'b1;
	end
	else begin
		dmemerror <= 1'b0;

	end

	
	
end


endmodule

module MEM_addr(M_icode, M_valE, M_valA, memaddr);

input[3:0] M_icode;
input [63:0] M_valE;
input[63:0] M_valA;

output reg[63:0] memaddr;

always @(M_icode, M_valE, M_valA) begin
	

	case (M_icode)
		4'h4, 4'h5, 4'hA, 4'h8: 
			memaddr <= M_valE;
		4'h9, 4'hB:
			memaddr <= M_valA;
	endcase

end

endmodule

module MEM_data(icode, valA, valP, memdata);

input[3:0] icode;
input [63:0] valA;
input[63:0] valP;

output reg[63:0] memdata;

always @(icode, valA, valP) begin
	
	case (icode)
		4'h4, 4'hA:
			memdata <= valA;
		4'h8:
			memdata<= valP;
		
	endcase
end

endmodule

module MEM_read (M_icode, read);

input [3:0] M_icode;
output reg read;

always @(M_icode) begin
	

	case (M_icode)
		4'h5, 4'hB, 4'h9:
			read <= 1'b1;
		default: read <= 1'b0;
	endcase
end
endmodule

module MEM_write (M_icode, write);

input [3:0] M_icode;
output reg write;

always @(M_icode) begin
	

	case (M_icode)
		4'h4, 4'hA, 4'h8:
			write <= 1'b1;
			
		default: write <= 1'b0;
	endcase
end
endmodule

module STAT(dmemerror, M_stat, m_stat);
  
    input dmemerror;
    input [2:0] M_stat;
    output reg[2:0] m_stat;


    parameter SAOK = 3'h1;
    parameter SHLT = 3'h2;
    parameter SADR = 3'h3;
    parameter SINS = 3'h4;

    always @(*)
    begin
        if(dmemerror) begin
		m_stat <= SADR;	
	end
        else begin
		m_stat <= M_stat;
	end

    end

endmodule

