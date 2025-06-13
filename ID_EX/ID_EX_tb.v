`timescale 1ns / 1ps

module ID_EX_tb;

    // Testbench signals
    reg clk;
    reg reset_n;
    reg ID_EXFlush;
    reg [6:0] ID_opcode;
    reg [31:0] ID_PCplus4;
    reg [31:0] ID_BranchAddr;
    reg ID_cntl_MemWrite;
    reg ID_cntl_MemRead;
    reg ID_cntl_RegWrite;
    reg [2:0] ID_sel_MemToReg;
    reg [1:0] ID_sel_ALUSrc;
    reg [3:0] ID_funct;
    reg [3:0] ID_ALUOp;
    reg [4:0] ID_ReadRegNum1;
    reg [4:0] ID_ReadRegNum2;
    reg [4:0] ID_WriteRegNum;
    reg [31:0] ID_ReadRegData1;
    reg [31:0] ID_ReadRegData2;
    reg [31:0] ID_immediate;

    wire [6:0] EX_opcode;
    wire [31:0] EX_PCplus4;
    wire [31:0] EX_BranchAddr;
    wire EX_cntl_MemWrite;
    wire EX_cntl_MemRead;
    wire EX_cntl_RegWrite;
    wire [2:0] EX_sel_MemToReg;
    wire [1:0] EX_sel_ALUSrc;
    wire [3:0] EX_funct;
    wire [3:0] EX_ALUOp;
    wire [4:0] EX_ReadRegNum1;
    wire [4:0] EX_ReadRegNum2;
    wire [4:0] EX_WriteRegNum;
    wire [31:0] EX_ReadRegData1;
    wire [31:0] EX_ReadRegData2;
    wire [31:0] EX_immediate;

    // Instantiate the ID_EX module
    ID_EX uut (
        .clk(clk),
        .reset_n(reset_n),
        .ID_EXFlush(ID_EXFlush),
        .ID_opcode(ID_opcode),
        .ID_PCplus4(ID_PCplus4),
        .ID_BranchAddr(ID_BranchAddr),
        .ID_cntl_MemWrite(ID_cntl_MemWrite),
        .ID_cntl_MemRead(ID_cntl_MemRead),
        .ID_cntl_RegWrite(ID_cntl_RegWrite),
        .ID_sel_MemToReg(ID_sel_MemToReg),
        .ID_sel_ALUSrc(ID_sel_ALUSrc),
        .ID_funct(ID_funct),
        .ID_ALUOp(ID_ALUOp),
        .ID_ReadRegNum1(ID_ReadRegNum1),
        .ID_ReadRegNum2(ID_ReadRegNum2),
        .ID_WriteRegNum(ID_WriteRegNum),
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

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 ns
    end

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        ID_EXFlush = 0;
        ID_opcode = 7'b0000000;
        ID_PCplus4 = 32'h00000004;
        ID_BranchAddr = 32'h00000008;
        ID_cntl_MemWrite = 0;
        ID_cntl_MemRead = 0;
        ID_cntl_RegWrite = 0;
        ID_sel_MemToReg = 3'b000;
        ID_sel_ALUSrc = 2'b00;
        ID_funct = 4'b0000;
        ID_ALUOp = 4'b0000;
        ID_ReadRegNum1 = 5'b00001;
        ID_ReadRegNum2 = 5'b00010;
        ID_WriteRegNum = 5'b00011;
        ID_ReadRegData1 = 32'h00000010;
        ID_ReadRegData2 = 32'h00000020;
        ID_immediate = 32'h00000030;

        // Reset the system
        #10;
        reset_n = 1;

        // Test case 1: No flush, normal data transfer
        #10;
        ID_opcode = 7'b0000001;  // A random opcode
        ID_PCplus4 = 32'h00000004;
        ID_BranchAddr = 32'h00000008;
        ID_cntl_MemWrite = 1;
        ID_cntl_MemRead = 1;
        ID_cntl_RegWrite = 1;
        ID_sel_MemToReg = 3'b001;
        ID_sel_ALUSrc = 2'b01;
        ID_funct = 4'b1010;
        ID_ALUOp = 4'b1011;
        ID_ReadRegNum1 = 5'b00001;
        ID_ReadRegNum2 = 5'b00010;
        ID_WriteRegNum = 5'b00011;
        ID_ReadRegData1 = 32'h00000010;
        ID_ReadRegData2 = 32'h00000020;
        ID_immediate = 32'h00000030;

        #10; // Check the outputs (should match the inputs)
        $display("Test case 1: EX_opcode=%b, EX_PCplus4=%h, EX_BranchAddr=%h, EX_cntl_MemWrite=%b, EX_cntl_MemRead=%b, EX_cntl_RegWrite=%b", 
                  EX_opcode, EX_PCplus4, EX_BranchAddr, EX_cntl_MemWrite, EX_cntl_MemRead, EX_cntl_RegWrite);

        // Test case 2: Flush the pipeline
        ID_EXFlush = 1;
        #10;
        // Check if the outputs are reset (should be all zeros)
        $display("Test case 2 (Flush): EX_opcode=%b, EX_PCplus4=%h, EX_BranchAddr=%h, EX_cntl_MemWrite=%b, EX_cntl_MemRead=%b, EX_cntl_RegWrite=%b", 
                  EX_opcode, EX_PCplus4, EX_BranchAddr, EX_cntl_MemWrite, EX_cntl_MemRead, EX_cntl_RegWrite);

        // Test case 3: Re-enable normal operation after flush
        ID_EXFlush = 0;
        ID_opcode = 7'b0000010;  // Another random opcode
        ID_PCplus4 = 32'h0000000C;
        ID_BranchAddr = 32'h00000010;
        ID_cntl_MemWrite = 0;
        ID_cntl_MemRead = 0;
        ID_cntl_RegWrite = 1;
        ID_sel_MemToReg = 3'b100;
        ID_sel_ALUSrc = 2'b00;
        ID_funct = 4'b1111;
        ID_ALUOp = 4'b1110;
        ID_ReadRegNum1 = 5'b00011;
        ID_ReadRegNum2 = 5'b00100;
        ID_WriteRegNum = 5'b00101;
        ID_ReadRegData1 = 32'h00000040;
        ID_ReadRegData2 = 32'h00000050;
        ID_immediate = 32'h00000060;

        #10;
        // Check the outputs (should match the inputs again)
        $display("Test case 3: EX_opcode=%b, EX_PCplus4=%h, EX_BranchAddr=%h, EX_cntl_MemWrite=%b, EX_cntl_MemRead=%b, EX_cntl_RegWrite=%b", 
                  EX_opcode, EX_PCplus4, EX_BranchAddr, EX_cntl_MemWrite, EX_cntl_MemRead, EX_cntl_RegWrite);

        // End the simulation
        $finish;
    end

endmodule
