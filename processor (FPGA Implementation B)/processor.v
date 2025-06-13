`timescale 1ns / 1ps

module processor(
    input clk,
    input reset_n,
    output reg1,
    output reg2,
    output reg3,
    output reg4,
    output reg5,
    output reg6,
    output reg7,
    output reg8,
    output reg9,
    output reg10
    );
    
    /* IF STAGE wires */
    wire PCWrite;
    wire IF_IDWrite;
    wire IF_IDFlush;
    wire [31:0] IF_PCplus4;
    wire [31:0] nextPC;
    wire [31:0] IF_PC;
    wire [31:0] IF_Instr;
    
    /* ID STAGE wires */
    wire ID_EXFlush;
    wire [31:0] ID_PC;
    wire [31:0] ID_PCplus4;
    wire [31:0] ID_Instr;
    wire [31:0] ID_immediate;
    wire [31:0] ID_ReadRegData1;
    wire [31:0] ID_ReadRegData2;
    wire [31:0] ID_BranchAddr;
    wire [31:0] ID_JalrAddr;
    
    wire ID_cntl_MemWrite;
    wire ID_cntl_MemRead;
    wire ID_cntl_RegWrite;
    wire ID_cntl_Branch;
    wire ID_ExeBranch;
    wire [2:0] ID_sel_MemToReg;      	//000: ALUResult, 001: DMemReadData_width, 010: immediate, 011: branchAddr, 100: PC + 4
    wire [1:0] ID_sel_ALUSrc;  			//00: ReadData2, 01: immediate, 10: shamt
    wire [1:0] ID_sel_jump;				//01: JALR, 10: JAL
    wire [3:0] ID_ALUOp;
    wire [1:0] ID_ForwardA;
    wire [1:0] ID_ForwardB;
    wire [31:0] ID_Forwarded_BranchALUop1;
    wire [31:0] ID_Forwarded_BranchALUop2;
    
    /* EX STAGE wires */
    wire [31:0] EX_PCplus4;
    wire EX_cntl_MemWrite;
    wire EX_cntl_MemRead;
    wire EX_cntl_RegWrite;
    wire [6:0] EX_opcode;
    wire [2:0] EX_sel_MemToReg;      	//000: ALUResult, 001: DMemReadData_width, 010: immediate, 011: branchAddr, 100: PC + 4
    wire [1:0] EX_sel_ALUSrc;  			//00: ReadData2, 01: immediate, 10: shamt
    wire [3:0] EX_funct;
    wire [3:0] EX_ALUOp;
    wire [3:0] EX_ALUCntl;
    wire [4:0] EX_ReadRegNum1;
    wire [4:0] EX_ReadRegNum2;
    wire [31:0] EX_ReadRegData1;
    wire [31:0] EX_ReadRegData2;
    wire [31:0] EX_BranchAddr;
    wire [31:0] EX_immediate;
    wire [31:0] EX_ALUResult;
    wire [4:0] EX_WriteRegNum;
    wire [31:0] EX_WriteMemData;
    wire [31:0] EX_ALUop1; 
    wire [31:0] EX_ALUop2;
    wire [31:0] EX_Forwarded_ALUop1;
    wire [31:0] EX_Forwarded_ALUop2;
    wire [1:0] EX_ForwardA;
    wire [1:0] EX_ForwardB;
    
    /* MEM STAGE wires */
    wire [31:0] MEM_PCplus4;
    wire MEM_cntl_MemWrite;
    wire MEM_cntl_RegWrite;
    wire MEM_cntl_MemRead;
    wire [2:0] MEM_sel_MemToReg;      	//000: ALUResult, 001: DMemReadData_width, 010: immediate, 011: branchAddr, 100: PC + 4
    wire [2:0] MEM_funct;
    wire [31:0] MEM_ReadMemData;
    wire [31:0] MEM_ALUResult;
    wire [4:0] MEM_WriteRegNum;
    wire [31:0] MEM_WriteMemData;
    wire [31:0] MEM_WidthControlled_WriteMemData;
    wire [31:0] MEM_BranchAddr;
    wire [31:0] MEM_immediate;
    
    /* WB STAGE wires */
    wire [31:0] WB_PCplus4;
    wire WB_cntl_RegWrite;
    wire [2:0] WB_sel_MemToReg;      	//000: ALUResult, 001: DMemReadData_width, 010: immediate, 011: branchAddr, 100: PC + 4
    wire [2:0] WB_funct;
    wire [31:0] WB_ReadMemData;
    wire [31:0] WB_WidthControlled_ReadMemData;
    wire [31:0] WB_ALUResult;
    wire [31:0] WB_WriteRegData;
    wire [4:0] WB_WriteRegNum;
    wire [31:0] WB_BranchAddr;
    wire [31:0] WB_immediate;
    
    
    /* IF STAGE */
    assign nextPC =	(ID_sel_jump === 2'b01) ? ID_JalrAddr : 
					(ID_sel_jump === 2'b10) ? ID_BranchAddr : 
    				(ID_cntl_Branch && ID_ExeBranch) ? ID_BranchAddr : IF_PCplus4;
    PC PC(
        .clk(clk), 
        .reset_n(reset_n),
        .PCWrite(PCWrite), 
        .nextPC(nextPC),
        .IF_PC(IF_PC)
    );
    Adder PCAdder(
        .op1(IF_PC),
        .op2(32'h0_0004),
        .result(IF_PCplus4)
    );
    instrMem InstrMEM(
        .iaddr(IF_PC),
        .dout(IF_Instr)
    );
        
    /* IF/ID register */
    assign IF_IDFlush = (ID_cntl_Branch && ID_ExeBranch) ? 1'b1 : 1'b0;
    IF_ID IF_ID(
        .clk(clk),
        .reset_n(reset_n),
        .IF_IDWrite(IF_IDWrite),
        .IF_IDFlush(IF_IDFlush),
        .IF_PC(IF_PC),
        .IF_PCplus4(IF_PCplus4),
        .IF_Instr(IF_Instr),
        .ID_PC(ID_PC),
        .ID_PCplus4(ID_PCplus4),
        .ID_Instr(ID_Instr)
    );
    
    /* ID STAGE */
    hazardDetectionUnit HazardUnit(
        .EX_cntl_MemRead(EX_cntl_MemRead),
        .MEM_cntl_MemRead(MEM_cntl_MemRead),
        .EX_cntl_RegWrite(EX_cntl_RegWrite),
        .ID_opcode(ID_Instr[6:0]),
        .EX_WriteRegNum(EX_WriteRegNum),
        .MEM_WriteRegNum(MEM_WriteRegNum),
        .ID_ReadRegNum1(ID_Instr[19:15]),
        .ID_ReadRegNum2(ID_Instr[24:20]),
        .PCWrite(PCWrite),
        .IF_IDWrite(IF_IDWrite),
        .ID_EXFlush(ID_EXFlush)
    );
    immGen ImmediateGen(
        .currInstr(ID_Instr),
        .immediate(ID_immediate)
    );
    Adder BranchAdder(
        .op1(ID_PC),
        .op2(ID_immediate),
        .result(ID_BranchAddr)
    );
    controlUnit ControlUnit(
        .funct(ID_Instr[14:12]),
        .opcode(ID_Instr[6:0]),
        .ID_ALUOp(ID_ALUOp),
        .ID_cntl_MemWrite(ID_cntl_MemWrite),
        .ID_cntl_MemRead(ID_cntl_MemRead),
        .ID_cntl_RegWrite(ID_cntl_RegWrite),
        .ID_cntl_Branch(ID_cntl_Branch),
        .ID_sel_jump(ID_sel_jump),
        .ID_sel_MemToReg(ID_sel_MemToReg),
        .ID_sel_ALUSrc(ID_sel_ALUSrc)
    );
    regFile RF(
        .clk(clk),
        .rst_n(reset_n),
        .rs1(ID_Instr[19:15]),
        .rs2(ID_Instr[24:20]),
        .wraddr(WB_WriteRegNum),
        .wrdata(WB_WriteRegData),
        .we(WB_cntl_RegWrite),
        .rdout1(ID_ReadRegData1),
        .rdout2(ID_ReadRegData2),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg5(reg5),
        .reg6(reg6),
        .reg7(reg7),
        .reg8(reg8),
        .reg9(reg9),
        .reg10(reg10)
    );
	assign ID_Forwarded_BranchALUop1 = 	(ID_ForwardA == 2'b00) ? ID_ReadRegData1 : 
    									(ID_ForwardA == 2'b01) ? WB_WriteRegData : 
   										(ID_ForwardA == 2'b10) ? MEM_ALUResult : 32'hxxxx_xxxx;
    assign ID_Forwarded_BranchALUop2 = 	(ID_ForwardB == 2'b00) ? ID_ReadRegData2 : 
    									(ID_ForwardB == 2'b01) ? WB_WriteRegData : 
   										(ID_ForwardB == 2'b10) ? MEM_ALUResult :  32'hxxxx_xxxx;
   	assign ID_JalrAddr = ID_Forwarded_BranchALUop1 + ID_immediate;									
	ID_ForwardingUnit ID_ForwardingUnit(
        .ID_opcode(ID_Instr[6:0]),
        .WB_cntl_RegWrite(WB_cntl_RegWrite),
        .MEM_cntl_RegWrite(MEM_cntl_RegWrite),
        .WB_WriteRegNum(WB_WriteRegNum),
        .MEM_WriteRegNum(MEM_WriteRegNum),
        .EX_ReadRegNum1(ID_Instr[19:15]),
        .EX_ReadRegNum2(ID_Instr[24:20]),
        .ForwardA(ID_ForwardA),
        .ForwardB(ID_ForwardB)
    );
    branchALU BranchALU(
        .ID_opcode(ID_Instr[6:0]),
        .funct(ID_Instr[14:12]),
        .op1(ID_Forwarded_BranchALUop1),
        .op2(ID_Forwarded_BranchALUop2),
        .ExeBranch(ID_ExeBranch)
    );
	
    /* ID/EX register */
    ID_EX ID_EX(
        .clk(clk),
        .reset_n(reset_n),
        .ID_EXFlush(ID_EXFlush),
    	.ID_opcode(ID_Instr[6:0]),
        .ID_PCplus4(ID_PCplus4),
        .ID_BranchAddr(ID_BranchAddr),
        .ID_cntl_MemWrite(ID_cntl_MemWrite),
        .ID_cntl_MemRead(ID_cntl_MemRead),
        .ID_cntl_RegWrite(ID_cntl_RegWrite),
        .ID_sel_MemToReg(ID_sel_MemToReg),
        .ID_sel_ALUSrc(ID_sel_ALUSrc),
        .ID_funct({ID_Instr[30], ID_Instr[14:12]}),
        .ID_ALUOp(ID_ALUOp),
        .ID_ReadRegNum1(ID_Instr[19:15]),
        .ID_ReadRegNum2(ID_Instr[24:20]),
        .ID_WriteRegNum(ID_Instr[11:7]),
        .ID_ReadRegData1(ID_ReadRegData1),
        .ID_ReadRegData2(ID_ReadRegData2),
        .ID_immediate(ID_immediate),
    	.EX_opcode(EX_opcode),
        .EX_PCplus4(EX_PCplus4),
        .EX_BranchAddr(EX_BranchAddr),
        .EX_cntl_MemWrite(EX_cntl_MemWrite),
        .EX_cntl_MemRead(EX_cntl_MemRead),
        .EX_cntl_RegWrite(EX_cntl_RegWrite),
        .EX_sel_MemToReg(EX_sel_MemToReg),
        .EX_sel_ALUSrc(EX_sel_ALUSrc),
        .EX_funct(EX_funct),
        .EX_ALUOp(EX_ALUOp),
        .EX_ReadRegNum1(EX_ReadRegNum1),
        .EX_ReadRegNum2(EX_ReadRegNum2),
        .EX_WriteRegNum(EX_WriteRegNum),
        .EX_ReadRegData1(EX_ReadRegData1),
        .EX_ReadRegData2(EX_ReadRegData2),
        .EX_immediate(EX_immediate)
    );
    
    /* EX STAGE */
    ALUContrl ALUControl(
        .funct(EX_funct),
        .ALUOp(EX_ALUOp),
        .ALUcntl(EX_ALUCntl)
    );
    assign EX_ALUop1 = EX_ReadRegData1;
    assign EX_ALUop2 =  (EX_sel_ALUSrc == 2'b00) ? EX_ReadRegData2 :
    				    (EX_sel_ALUSrc == 2'b01) ? EX_immediate : 
    				    (EX_sel_ALUSrc == 2'b10) ? {27'b0, EX_ReadRegNum2} : 32'h0000_0000;		
    assign EX_Forwarded_ALUop1 = 	(EX_ForwardA == 2'b00) ? EX_ALUop1 : 
    								(EX_ForwardA == 2'b01) ? WB_WriteRegData : 
   									(EX_ForwardA == 2'b10) ? MEM_ALUResult : 32'hxxxx_xxxx;
    assign EX_Forwarded_ALUop2 = 	(EX_ForwardB == 2'b00) ? EX_ALUop2 : 
    								(EX_ForwardB == 2'b01) ? WB_WriteRegData : 
   									(EX_ForwardB == 2'b10) ? MEM_ALUResult :  32'hxxxx_xxxx;
    assign EX_WriteMemData = EX_Forwarded_ALUop2;
    EX_ForwardingUnit EX_ForwardingUnit(
        .EX_opcode(EX_opcode),
        .WB_cntl_RegWrite(WB_cntl_RegWrite),
        .MEM_cntl_RegWrite(MEM_cntl_RegWrite),
        .WB_WriteRegNum(WB_WriteRegNum),
        .MEM_WriteRegNum(MEM_WriteRegNum),
        .EX_ReadRegNum1(EX_ReadRegNum1),
        .EX_ReadRegNum2(EX_ReadRegNum2),
        .ForwardA(EX_ForwardA),
        .ForwardB(EX_ForwardB)
    );
    ALU ALU(
        .funct(EX_funct[2:0]),
        .ALUcntl(EX_ALUCntl),
        .op1(EX_Forwarded_ALUop1),
        .op2(EX_Forwarded_ALUop2),
        .ALUResult(EX_ALUResult)
    );
    
    /* EX/MEM register */
    EX_MEM EX_MEM(
        .clk(clk),
        .reset_n(reset_n),
    	.EX_PCplus4(EX_PCplus4),
        .EX_immediate(EX_immediate),
        .EX_BranchAddr(EX_BranchAddr),
        .EX_cntl_MemWrite(EX_cntl_MemWrite),
        .EX_cntl_MemRead(EX_cntl_MemRead),
        .EX_cntl_RegWrite(EX_cntl_RegWrite),
        .EX_sel_MemToReg(EX_sel_MemToReg),
        .EX_funct(EX_funct[2:0]),
        .EX_ALUResult(EX_ALUResult),
        .EX_WriteMemData(EX_ReadRegData2),
        .EX_WriteRegNum(EX_WriteRegNum),
    	.MEM_PCplus4(MEM_PCplus4),
        .MEM_immediate(MEM_immediate),
        .MEM_BranchAddr(MEM_BranchAddr),
        .MEM_cntl_MemWrite(MEM_cntl_MemWrite),
        .MEM_cntl_MemRead(MEM_cntl_MemRead),
        .MEM_cntl_RegWrite(MEM_cntl_RegWrite),
        .MEM_sel_MemToReg(MEM_sel_MemToReg),
        .MEM_funct(MEM_funct),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_WriteMemData(MEM_WriteMemData),
        .MEM_WriteRegNum(MEM_WriteRegNum)
    );
 	
    /* MEM STAGE */
    assign MEM_WidthControlled_WriteMemData = 	(MEM_funct == 3'b000) ? {24'b0, MEM_WriteMemData[7:0]} : 
    											(MEM_funct == 3'b001) ? {16'b0, MEM_WriteMemData[15:0]} :
    											(MEM_funct == 3'b010) ? MEM_WriteMemData : 32'hxxxx_xxxx;
    dataMem DataMEM(
        .clk(clk),
        .rst_n(reset_n),
        .MemWrite(MEM_cntl_MemWrite),
        .addr(MEM_ALUResult),
        .din(MEM_WidthControlled_WriteMemData),
        .dout(MEM_ReadMemData)
    );
    
    /* MEM/WB register */
	MEM_WB MEM_WB(
        .clk(clk),
        .reset_n(reset_n),
    	.MEM_PCplus4(MEM_PCplus4),
        .MEM_immediate(MEM_immediate),
        .MEM_BranchAddr(MEM_BranchAddr),
        .MEM_cntl_RegWrite(MEM_cntl_RegWrite),
        .MEM_sel_MemToReg(MEM_sel_MemToReg),
        .MEM_funct(MEM_funct),
        .MEM_ReadMemData(MEM_ReadMemData),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_WriteRegNum(MEM_WriteRegNum),
    	.WB_PCplus4(WB_PCplus4),
        .WB_immediate(WB_immediate),
        .WB_BranchAddr(WB_BranchAddr),
        .WB_cntl_RegWrite(WB_cntl_RegWrite),
        .WB_sel_MemToReg(WB_sel_MemToReg),
        .WB_funct(WB_funct),
        .WB_ReadMemData(WB_ReadMemData),
        .WB_ALUResult(WB_ALUResult),
        .WB_WriteRegNum(WB_WriteRegNum)
    );

    /* WB STAGE */
    widthContrl WidthControl(
        .funct3(WB_funct),
        .word(WB_ReadMemData),
        .OutputWord(WB_WidthControlled_ReadMemData)
    );
    assign WB_WriteRegData = 	(WB_sel_MemToReg == 3'b000) ? WB_ALUResult : 
    							(WB_sel_MemToReg == 3'b001) ? WB_WidthControlled_ReadMemData :
    							(WB_sel_MemToReg == 3'b010) ? WB_immediate :
    							(WB_sel_MemToReg == 3'b011) ? WB_BranchAddr :
    							(WB_sel_MemToReg == 3'b100) ? WB_PCplus4 : 32'hxxxx_xxxx;
    
endmodule