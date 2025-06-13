`timescale 1ns / 1ps


module EX_MEM(
	input clk, 
	input reset_n,
	input [31:0] EX_PCplus4,
	input [31:0] EX_BranchAddr,
	input [31:0] EX_immediate,
	input EX_cntl_MemWrite,
    input EX_cntl_RegWrite,
    input EX_cntl_MemRead,
    input [2:0] EX_sel_MemToReg,      	//000: ALUResult, 001: DMemReadData_width, 010: immediate, 011: branchAddr, 100: PC + 4
    input [2:0] EX_funct,
    input [31:0] EX_ALUResult,
    input [4:0] EX_WriteRegNum,
    input [31:0] EX_WriteMemData,
    output reg [31:0] MEM_PCplus4,
	output reg [31:0] MEM_BranchAddr,
	output reg [31:0] MEM_immediate,
    output reg MEM_cntl_MemWrite,
    output reg MEM_cntl_RegWrite,
    output reg MEM_cntl_MemRead,
    output reg [2:0] MEM_sel_MemToReg,      	//000: ALUResult, 001: DMemReadData_width, 010: immediate, 011: branchAddr, 100: PC + 4
    output reg [2:0] MEM_funct,
    output reg [31:0] MEM_ALUResult,
    output reg [4:0] MEM_WriteRegNum,
    output reg [31:0] MEM_WriteMemData
    );
    
    always @ (posedge clk or negedge reset_n) begin
    	if (!reset_n) begin
    		MEM_PCplus4 <= 0;
    		MEM_BranchAddr <= 0;
    		MEM_immediate <= 0;
    		MEM_cntl_MemWrite <= 0;
    		MEM_cntl_RegWrite <= 0;
    		MEM_cntl_MemRead <= 0;
    		MEM_sel_MemToReg <= 0;
    		MEM_funct <= 0;
    		MEM_ALUResult <= 0;
    		MEM_WriteRegNum <= 0;
    		MEM_WriteMemData <= 0;
    	end
    	else begin
    		MEM_PCplus4 <= EX_PCplus4;
    		MEM_BranchAddr <= EX_BranchAddr;
			MEM_immediate <= EX_immediate;
    		MEM_cntl_MemWrite <= EX_cntl_MemWrite;
    		MEM_cntl_RegWrite <= EX_cntl_RegWrite;
    		MEM_cntl_MemRead <= EX_cntl_MemRead;
    		MEM_sel_MemToReg <= EX_sel_MemToReg;
    		MEM_funct <= EX_funct;
    		MEM_ALUResult <= EX_ALUResult;
    		MEM_WriteRegNum <= EX_WriteRegNum;
    		MEM_WriteMemData <= EX_WriteMemData;
    	end
    end
    
endmodule