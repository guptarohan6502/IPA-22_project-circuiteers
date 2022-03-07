// reads instructions from intruction memory 
// finding values of icode, ifun, rA, rB, valC using the instructions

module SELECT_PC(F_pred_PC,M_icode,M_cnd,M_valA,W_icode,W_valM,f_pc);

input [63:0] F_pred_PC;
input [3:0] M_icode;
/////////////////////////////look at this line////////'
input M_cnd;

input [63:0] M_valA;
input [3:0] W_icode;
input [3:0] W_valM;

output reg [63:0] f_pc;

always @(*) begin
    if(M_icode == 4'h7 && !M_Cnd) 
        f_pc <= M_valA;
    else if( W_icode == 4'h9 )
        f_pc <= W_valM;
    else
        f_pc <= F_pred_PC;
end


endmodule

module PREDICT_PC(icode,valC,valP,predict_pc);

input [3:0] icode;
input [63:0] valC;
input [63:0] valP;
output [63:0] predict_pc;




endmodule


module split(Byte0,icode,ifun);

input [7:0] Byte0;
output [3:0] icode;
output [3:0] ifun;

    assign icode = Byte0[0:4];
    assign ifun = Byte0[5:7];

endmodule


module Need_VALC(icode,need_valC);
input [3:0] icode;
output reg need_valC;

always @(icode)
    begin
    case (icode)
        4'h3, 4'h4, 4'h5, 4'h7, 4'h8,:
            begin
                assign need_valC = 1'b1;
            end
        4'h1, 4'h2, 4'h6, 4'h6, 4'h9, 4'hA, 4'hB:
            begin
                assign need_valC = 1'b0;
            end

        default: need_valC = 1'b0;
    endcase
    end
endmodule


module Need_REGIDS(icode,need_regids);

input [3:0] icode;
output reg need_regids;

    always @(icode)
        begin
        case (icode)
            4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'hA, 4'hB,:
                begin
                    assign need_regids = 1'b1;
                end
            4'h1, 4'h7, 4'h8, 4'h9:
                begin
                    assign need_regids = 1'b0;
                end

            default: need_regids = 1'b0;
        endcase
        end

endmodule


module align(Byte19,rA,rB,valC);

input [71:0] Byte19;
output [3:0] rA;
output [3:0] rB;
output [63:0] valC;

    assign rA = Byte19[71:68] ;
    assign rB = Byte19[67:64];
    assign valC = need_regids ? Byte19[63:0]:Byte19[71:8]

  
endmodule

module PC_INCREMENT(f_pc,need_regids,need_valC,valP);

input[63:0] f_pc;
input need_regids;
input need_valC;
output [63:0] valP;

    assign valP = need_valC ? (need_regids ? f_pc+10:f_pc+9):(need_regids ? f_pc+2:f_pc+1);

endmodule

module INSTR_VALID(icode,instr_valid);
input [3:0] icode;
output reg instr_valid;

always @(icode)
    begin
    case (icode)
        4'h0, 4'h1, 4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'h7, 4'h8, 4'h9, 4'hA, 4'hB:
            begin
                assign instr_valid = 1'b1;
            end
    
        default: instr_valid = 1'b0;
    endcase
    end


endmodule