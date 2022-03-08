`timescale 1ns / 1ps

`include "fetch/fetch.v"
`include "fetch/fetch_reg.v"
`include "fetch/instrmem.v"
`include "Decode_wb/decode_reg.v"
`include "Decode_wb/decode_wb.v"
`include "Decode_wb/white_reg.v"
`include "Execute/execute_reg.v"
`include "Execute/execute.v"
`include "Memory/mem_reg.v"
`include "pipeline_ctrl.v"

`include "Execute/Alu/alu.v"
`include "Execute/And/and_1bit.v"
`include "Execute/And/and_64bit.v"
`include "Execute/Xor/xor_1bit.v"
`include "Execute/Xor/xor_64bit.v"
`include "Execute/Or/or_1bit.v"

`include "Execute/Add/add_1bit.v"
`include "Execute/Add/add_64bit.v"

`include "Execute/Sub/not_1bit.v"
`include "Execute/Sub/not_64bit.v"
`include "Execute/Sub/sub_64bit.v"

module Processor;

    reg clk;
    reg [63:0] pc;
    reg stat[0:2];

    // fetch
    wire [3:0] M_icode;
    wire [63:0] M_valA;
    wire [3:0] W_valM;
    wire [63:0] f_pc;

    // fetch reg
    wire [63:0] predict_pc;
    wire [63:0] F_pred_PC;

    // instruction memory
    wire imem_error;
    wire [7:0] Byte0;
    wire [71:0] Byte19;
    wire [7:0] instr_mem[2047:0];

    // execute, execute register
    wire [63:0] aluA;
    wire [63:0] aluB;
    wire [1:0]  alufun;
    wire [63:0] valE;
    wire [2:0]  cf;
    // wire signed [63:0] out1;
    // wire [2:0] cf_add;
    // wire signed [63:0] out2;
    // wire [2:0] cf_sub;
    // wire signed [63:0] out3;
    // wire [2:0] cf_and;
    // wire signed [63:0] out4;
    // wire [2:0] cf_xor;

    wire [2:0]D_stat;
    wire [3:0]D_icode; 
    wire [3:0]D_ifun; 
    wire [3:0]d_dstE;
    wire [3:0]d_dstM;
    wire [3:0]d_srcA;
    wire [3:0]d_srcB;
    wire [63:0]d_valA;
    wire [63:0]d_valB;
    wire [63:0]D_valC;


    wire [2:0] E_stat;
    wire [3:0] E_icode; 
    wire [3:0] E_ifun;
    wire [3:0] E_dstE;
    wire [3:0] E_dstM;;
    wire [3:0] E_srcA;
    wire [3:0] E_srcB;
    wire [63:0] E_valC;
    wire [63:0] E_valA;
    wire [63:0] E_valB;

    // decode, decode reg, decode wb, write reg
    wire [2:0]f_stat;
    wire [3:0]f_icode; 
    wire [3:0]f_ifun; 
    wire [3:0]f_rA;
    wire [3:0]f_rB;
    wire [63:0]f_valC;
    wire [63:0]f_valP;

    wire [3:0] D_rA;
    wire [3:0] D_rB;
    wire [63:0] D_valP;

    wire [3:0]W_dstE;
    wire [3:0]W_dstM;
    wire [63:0] W_valE;
    wire [63:0] W_valM;

    wire [63:0] d_rvalA;
    wire [63:0] d_rvalB;

    wire [63:0] register_file[14:0];
    wire [2:0] W_stat;
    reg [2:0] stat;

	wire [63:0] d_rvalA;
	wire [63:0] D_valP;
	wire [3:0] d_srcA;
	wire [3:0] e_dstE;
	wire [3:0] M_dstM;
	wire [3:0] M_dstE;
	wire [3:0] W_dstM;
	wire [3:0] W_dstE;
	wire [63:0] e_valE;
	wire [63:0] m_valM;
	wire [63:0] M_valE;
 
    wire [63:0] d_rvalB;
	wire [3:0] d_srcB;
	wire [63:0] W_valM;
	wire [63:0] W_valE;

    wire [2:0]m_stat;
    wire [3:0]m_icode; 
    wire [63:0]m_valA; 
    wire [63:0]M_valE;
    wire [3:0]M_dstE;
    wire [3:0]M_dstM;

    wire [2:0] W_stat;
    wire [3:0] W_icode; 

    // memory 
    wire e_cnd; 
    wire [3:0]e_dstM;
    wire [63:0]e_valE;
    wire [2:0] M_stat;
    wire [3:0] M_icode; 
    wire M_cnd;

    // pipeline control 
    wire F_stall;
    wire D_stall;
    wire D_bubble;
    wire E_bubble;
    wire M_bubble;
    wire W_stall;

    // fetch
    FETCH_REG f_reg(.clk(clk), .predict_pc(predict_pc), .F_pred_PC(F_pred_PC));
    SELECT_PC sel_pc(.F_pred_PC(F_pred_PC), .M_icode(M_icode), .M_cnd(M_cnd), .M_valA(M_valA), .W_icode(W_icode), .W_valM(W_valM), .f_pc(f_pc));
    PREDICT_PC pred_pc(.f_icode(f_icode), .valC(valC), .valP(valP), .predict_pc(predict_pc));
    STAT stat(.f_icode(f_icode), .instr_valid(instr_valid), .imem_error(imem_error), .f_stat(f_stat));
    split sp(.Byte0(Byte0), .f_icode(f_icode), .f_ifun(f_ifun));
    align al(.Byte19(Byte19), .need_regids(need_regids), .f_rA(f_rA), .f_rB(f_rB), .f_valC(f_valC));
    PC_INCREMENT PC_i(.f_pc(f_pc), .f_icode(f_icode), .need_regids(need_regids), .need_valC(need_valC), .f_valP(f_valP));
    INSTR_VALID i_valid(.f_icode(f_icode), .instr_valid(instr_valid));
    Need_REGIDS nreg(.f_icode(f_icode), .need_regids(need_regids));
    Need_VALC n_valC(.f_icode(f_icode), .need_valC(need_valC));
    instruction_memory InstMem(.clk(clk), .f_pc(f_pc), .imem_error(imem_error), .Byte0(Byte0), .Byte19(Byte19));
    
    // decode
     DECODE_REG d_reg(.clk(clk), .f_stat(f_stat), .f_icode(f_icode), .f_ifun(f_ifun), .f_rA(f_rA), .f_rB(f_rB), .f_valC(f_valC), .f_valP(f_valP), .D_stat(D_stat), .D_icode(D_icode), .D_ifun(D_ifun), .D_rA(D_rA), .D_rB(D_rB), .D_valC(D_valC), .D_valP(D_valP));
     registerfile reg_file(.clk(clk), .dstE(dstE), .dstM(dstM), .srcA(srcA), .srcB(srcB), .valE(valE), .valM(valM), .valA(valA), .valB(valB));
     WRITE_STAT wr_stat(.W_stat(W_stat), .stat(stat));
     d_VALA_logic d_valAlog(.D_icode(D_icode), .d_rvalA(d_rvalA), .D_valP(D_valP), .d_srcA(d_srcA), .e_dstE(e_dstE), .M_dstM(M_dstM),
	 .M_dstE(M_dstE), .W_dstM(W_dstM), .W_dstE(W_dstE), .e_valE(e_ValE), .m_valM(m_valM), .M_valE(M_valE), .W_valM(W_valM), .W_valE(W_valE), .d_valA(d_valA) );
     d_VALB_logic d_valBlog(.d_rvalB(d_rvalB), .D_valP(D_valP), .d_srcB(d_srcB), .e_dstE(e_dstE), .M_dstM(M_dstM), .M_dstE(M_dstE),
	                .W_dstM(W_dstM), .W_dstE(W_dstE), .e_valE(e_valE), .m_valM(m_valM), .M_valE(M_valE), .W_valM(W_valM), .W_valE(W_valE), .d_valB(d_valB) );
    d_srcA_logic d_srcAlog(.D_icode(D_icode), .D_rA(D_rA), .d_srcA(d_src_A));
    d_srcB_logic d_srcBlog(.D_icode(D_icode), .D_rB(D_rB), .d_srcB(d_srcB));
    dstE_logic dstE_log(.D_icode(D_icode), .D_ifun(D_ifun), .D_rB(D_rB), .d_dstE(d_dstE));
    dstM_logic dstM_log(.D_icode(D_icode), .D_rA(D_rA), .d_dstM(d_dstM));
    WRITE_REG wr_reg(.clk(clk), .m_stat(m_stat), .m_icode(m_icode), .M_valE(M_valE), .m_valA(m_valA), .M_dstE(M_dstE), .M_dstM(M_dstE),
                    .W_stat(W_stat), .W_icode(W_icode), .W_valE(W_valE), .W_valM(W_valM), .W_dstE(W_dstE), .W_dstM(W_dstM));
    
    // execute
    EXECUTE_REG exec_reg(.clk(clk), .D_stat(D_stat), .D_icode(D_icode), .D_ifun(D_ifun), .D_valC(D_valC), .d_valA(d_valA),
        .d_valB(d_valB), .d_dstE(d_dstE), .d_dstM(d_dstM), .d_srcA(d_srcA), .d_srcB(d_srcB), .E_stat(E_stat), .E_icode(E_icode), .E_ifun(E_ifun), .E_valC(E_valC), .E_valA(E_valA), .E_valB(E_valB), .E_dstE(E_dstE), .E_dstM(E_dstM), .E_srcA(E_srcA), .E_srcB(E_srcB));
    alu_block alulogic(.aluA(aluA), .aluB(aluB), .alufun(alufun), .cf(cf), .valE(valE));
    ALU_A alualogic(.icode(icode), .valA(valA), .valC(valC), .aluA(aluA));
    ALU_B alublogic(.icode(icode), .valB(valB), .aluB(aluB));
    ALU_fun alufunlogic(.icode(icode), .ifun(ifun), .alufun(alufun));
    set_CC cclogiv(.icode(icode), .cf(cf), .outf(outf));
    CND cndlogic(.ifun(ifun), .outf(outf), .cnd(cnd));

    // memory
    MEMORY_REG mem_reg(.clk(clk), .E_stat(E_stat), .E_icode(E_icode), .e_cnd(e_cnd), e_valE(e_valE),
        .E_valA(E_valA), .e_dstE(e_dstE), .E_dstM(E_dstM),
        .M_stat(M_stat), .M_icode(M_icode), .M_cnd(M_cnd), .M_valE(M_valE), .M_valA(M_valA), .M_dstE(M_dstE), .M_dstM(M_dstM));

    // pipeline control 
    PIPE_CONTROL_LOGIC pipe_ctrl(.clk(clk), );

    always #5 clk=~clk;

  initial begin
    $dumpfile("proc.vcd");
    $dumpvars(0, proc);
    stat[0] = 1;
    stat[1] = 0;
    stat[2] = 0;
    clk = 0;
    pc = 64'd31;
  end 

  always@(*)
  begin
    pc = newpc; // Updated PC?
  end

  always@(*)
  begin
    if(hltins)
    begin
      stat[2]=hltins;
      stat[1]=1'b0;
      stat[0]=1'b0;
    end
    else if(instr_valid==1'b0)
    begin
      stat[1]=instr_valid;
      stat[2]=1'b0;
      stat[0]=1'b0;
    end
    else
    begin
      stat[0]=1'b1;
      stat[1]=1'b0;
      stat[2]=1'b0;
    end
  end
  
  always@(*)
  begin
    if(stat[2]==1'b1)
    begin
      $finish;
    end
  end

  initial 
    //$monitor("clk=%d 0=%d 1=%d 2=%d 3=%d 4=%d zf=%d sf=%d of=%d",clk,reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4,zf,sf,of);
    // $monitor("clk=%d halt=%d 0=%d 1=%d 2=%d 3=%d 4=%d",clk,stat[2],reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4);
		// $monitor("clk=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valC=%d valE=%d valM=%d insval=%d memerr=%d cnd=%d halt=%d 0=%d 1=%d 2=%d 3=%d 4=%d 5=%d 6=%d 7=%d 8=%d 9=%d 10=%d 11=%d 12=%d 13=%d 14=%d datamem=%d\n",clk,icode,ifun,rA,rB,valA,valB,valC,valE,valM,instr_valid,imem_error,cnd,stat[2],reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4,reg_mem5,reg_mem6,reg_mem7,reg_mem8,reg_mem9,reg_mem10,reg_mem11,reg_mem12,reg_mem13,reg_mem14,datamem);
		$monitor("clk=%d f=%d d=%d e=%d m=%d wb=%d",clk,f_icode,d_icode,e_icode,m_icode,w_icode);
endmodule