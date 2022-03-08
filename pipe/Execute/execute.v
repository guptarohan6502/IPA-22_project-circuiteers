
`include "Alu/alu.v"
`include "And/and_1bit.v"
`include "And/and_64bit.v"
`include "Xor/xor_1bit.v"
`include "Xor/xor_64bit.v"
`include "Or/or_1bit.v"

`include "Add/add_1bit.v"
`include "Add/add_64bit.v"

`include "Sub/not_1bit.v"
`include "Sub/not_64bit.v"
`include "Sub/sub_64bit.v"


module alu_block(aluA, aluB, alufun, valE, cf);

input[63:0] aluA;
input[63:0] aluB;
input[1:0] alufun;

output reg[63:0] valE;
output reg[2:0]cf;

wire signed [63:0] out1;
wire [2:0] cf_add;
wire signed [63:0] out2;
wire [2:0] cf_sub;
wire signed [63:0] out3;
wire [2:0] cf_and;
wire signed [63:0] out4;
wire [2:0] cf_xor;

	and_64bit g1(aluA, aluB, out3, cf_and);
	xor_64bit g2(aluA, aluB, out4, cf_xor);
	add_64bit g3(aluA, aluB, out1, cf_add);
	sub_64bit g4(aluA, aluB, out2, cf_sub);


	always@(*)
	begin
		case(alufun)
			2'b00:begin
				valE <= out1;
				cf <= cf_add;
			end
			2'b01:begin
				valE <= out2;
				cf <= cf_sub;
				
			end
			2'b10:begin
				valE <= out3;
				cf <= cf_and;
			end
			2'b11:begin
				valE <= out4;
				cf <= cf_xor;
			end
			
		endcase
	end
			
endmodule

<<<<<<< HEAD
module ALU_A(icode, valC, valA, aluA);
=======
>>>>>>> 4fee24f8a7d8700132833b62b89fa82ea028af55

module EXE_DST_E_LOGIC (E_icode,e_cnd,e_dstE);

input[3:0] E_icode;
input e_cnd;
output reg [3:0] e_dstE;

parameter rnone = 4'hF ;

always @(*) begin
    case (E_icode)
        4'h2:begin
            e_dstE = e_cnd ?  E_dstE:rnone; 
        end

        default: e_dstE <= E_dstE;
    endcase
    
end
endmodule

module ALU_A(E_icode,E_valC,E_valA,aluA);

input[3:0] E_icode;
input[63:0] E_valC;
input[63:0] E_valA;

output reg[63:0] aluA;

always @(E_icode,E_valC,E_valA) begin
	
	case (E_icode)
	4'h2,4'h6: 
		aluA <= E_valA;
	4'h5,4'h4,4'h3:
		aluA <= E_valC;
	4'h8,4'hA:
		aluA <= 64'd8;
	4'h9,4'hB:
		aluA <= -64'd8;
	endcase
end

endmodule


<<<<<<< HEAD
module ALU_B(icode, valB, aluB);
=======
module ALU_B(E_icode,E_valB,aluB);
>>>>>>> 4fee24f8a7d8700132833b62b89fa82ea028af55

input[3:0] E_icode;
input[63:0] E_valB;

output reg[63:0] aluB;

always @(E_icode,E_valB) begin
	
	case (E_icode)
	4'h4,4'h5,4'h6, 4'h8,4'h9, 4'hA, 4'hB: 
		aluB <= E_valB;
	4'h3,4'h4:
		aluB <= 64'b0;
	endcase
end

 
endmodule


<<<<<<< HEAD
module ALU_fun(icode, ifun, alufun);
=======
module ALU_fun(E_icode,E_ifun,alufun);
>>>>>>> 4fee24f8a7d8700132833b62b89fa82ea028af55

input[3:0] E_icode;
input[3:0] E_ifun;

output reg[1:0] alufun;

always @(E_icode) begin

	case (E_icode)
	4'h6: begin
		alufun[1] = E_ifun[1];
		alufun[0] = E_ifun[0];
	end
		default:alufun <= 2'b00;
	endcase
	
end
endmodule


<<<<<<< HEAD
module set_CC(icode, cf, outf);
=======
module set_CC(E_icode,cf,m_stat,W_stat,outf);
>>>>>>> 4fee24f8a7d8700132833b62b89fa82ea028af55

input [3:0] icode;
input [2:0]cf;
input [2:0] m_stat,W_stat;
output reg[2:0] outf;


parameter SBUB = 3'h0;
parameter SAOK = 3'h1;
parameter SHLT = 3'h2;
parameter SADR = 3'h3;
parameter SINS = 3'h4;

always @ (E_icode,cf)
begin
if(m_stat != SHLT || m_stat== SADR || m_stat != SINS) begin
    if(W_stat != SHLT || W_stat== SADR || W_stat != SINS) begin
        case (E_icode)
            4'h6:
                outf <= cf;    
        endcase
    end
end
        

end

endmodule


module CND(E_ifun,outf,e_cnd);
    
    input[3:0] E_ifun;
    input[2:0] outf;
    output reg e_cnd;

    always @(E_ifun,outf)
    begin
        case(E_ifun)
        4'h0: e_cnd <= 1'b1;

        4'h1:
        begin
            if((outf[1]^outf[0])|outf[2]) 
            e_cnd <= 1'b1;
            else
            e_cnd <= 1'b0;
        end

        4'h2:
        begin
            if(outf[1]^outf[0]) 
            e_cnd <= 1'b1;
            else
            e_cnd <= 1'b0;
        end
        
        4'h3:
        begin
            if(outf[2]) 
            e_cnd <= 1'b1;
            else
            e_cnd <= 1'b0;
        end 
        
        4'h4:
        begin
            if(~outf[2]) 
            e_cnd <= 1'b1;
            else
            e_cnd <= 1'b0;
        end
        
        4'h5:
        begin
            if(~(outf[1]^outf[0])) 
            e_cnd <= 1'b1;
            else
            e_cnd <= 1'b0;
        end
        
        4'h6:
        begin
            if(~(outf[1]^outf[0]) & ~outf[2]) 
            e_cnd <= 1'b1;
            else
            e_cnd <= 1'b0;
        end
        endcase
        
    end

endmodule