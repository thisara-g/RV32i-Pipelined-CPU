`timescale 1ns / 1ps

module EX_MEM_tb;

    // Testbench signals
    reg clk;
    reg reset_n;
    reg [31:0] EX_PCplus4;
    reg [31:0] EX_BranchAddr;
    reg [31:0] EX_immediate;
    reg EX_cntl_MemWrite;
    reg EX_cntl_RegWrite;
    reg EX_cntl_MemRead;
    reg [2:0] EX_sel_MemToReg;
    reg [2:0] EX_funct;
    reg [31:0] EX_ALUResult;
    reg [4:0] EX_WriteRegNum;
    reg [31:0] EX_WriteMemData;

    wire [31:0] MEM_PCplus4;
    wire [31:0] MEM_BranchAddr;
    wire [31:0] MEM_immediate;
    wire MEM_cntl_MemWrite;
    wire MEM_cntl_RegWrite;
    wire MEM_cntl_MemRead;
    wire [2:0] MEM_sel_MemToReg;
    wire [2:0] MEM_funct;
    wire [31:0] MEM_ALUResult;
    wire [4:0] MEM_WriteRegNum;
    wire [31:0] MEM_WriteMemData;

    // Instantiate the EX_MEM module
    EX_MEM uut (
        .clk(clk),
        .reset_n(reset_n),
        .EX_PCplus4(EX_PCplus4),
        .EX_BranchAddr(EX_BranchAddr),
        .EX_immediate(EX_immediate),
        .EX_cntl_MemWrite(EX_cntl_MemWrite),
        .EX_cntl_RegWrite(EX_cntl_RegWrite),
        .EX_cntl_MemRead(EX_cntl_MemRead),
        .EX_sel_MemToReg(EX_sel_MemToReg),
        .EX_funct(EX_funct),
        .EX_ALUResult(EX_ALUResult),
        .EX_WriteRegNum(EX_WriteRegNum),
        .EX_WriteMemData(EX_WriteMemData),
        .MEM_PCplus4(MEM_PCplus4),
        .MEM_BranchAddr(MEM_BranchAddr),
        .MEM_immediate(MEM_immediate),
        .MEM_cntl_MemWrite(MEM_cntl_MemWrite),
        .MEM_cntl_RegWrite(MEM_cntl_RegWrite),
        .MEM_cntl_MemRead(MEM_cntl_MemRead),
        .MEM_sel_MemToReg(MEM_sel_MemToReg),
        .MEM_funct(MEM_funct),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_WriteRegNum(MEM_WriteRegNum),
        .MEM_WriteMemData(MEM_WriteMemData)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 ns
    end

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        EX_PCplus4 = 32'h00000000;
        EX_BranchAddr = 32'h00000000;
        EX_immediate = 32'h00000000;
        EX_cntl_MemWrite = 0;
        EX_cntl_RegWrite = 0;
        EX_cntl_MemRead = 0;
        EX_sel_MemToReg = 3'b000;
        EX_funct = 3'b000;
        EX_ALUResult = 32'h00000000;
        EX_WriteRegNum = 5'b00000;
        EX_WriteMemData = 32'h00000000;

        // Apply reset
        reset_n = 0;
        #10;
        reset_n = 1;

        // Test case 1: Normal data transfer (no control signals set)
        EX_PCplus4 = 32'h0000_1000;
        EX_BranchAddr = 32'h0000_2000;
        EX_immediate = 32'h0000_3000;
        EX_cntl_MemWrite = 1;
        EX_cntl_RegWrite = 1;
        EX_cntl_MemRead = 1;
        EX_sel_MemToReg = 3'b001;
        EX_funct = 3'b010;
        EX_ALUResult = 32'hdead_beef;
        EX_WriteRegNum = 5'b00001;
        EX_WriteMemData = 32'hface_cafe;

        #10;

        // Check if MEM stage values match EX stage values
        $display("MEM_PCplus4: %h, Expected: %h", MEM_PCplus4, EX_PCplus4);
        $display("MEM_BranchAddr: %h, Expected: %h", MEM_BranchAddr, EX_BranchAddr);
        $display("MEM_immediate: %h, Expected: %h", MEM_immediate, EX_immediate);
        $display("MEM_cntl_MemWrite: %b, Expected: %b", MEM_cntl_MemWrite, EX_cntl_MemWrite);
        $display("MEM_cntl_RegWrite: %b, Expected: %b", MEM_cntl_RegWrite, EX_cntl_RegWrite);
        $display("MEM_cntl_MemRead: %b, Expected: %b", MEM_cntl_MemRead, EX_cntl_MemRead);
        $display("MEM_sel_MemToReg: %b, Expected: %b", MEM_sel_MemToReg, EX_sel_MemToReg);
        $display("MEM_funct: %b, Expected: %b", MEM_funct, EX_funct);
        $display("MEM_ALUResult: %h, Expected: %h", MEM_ALUResult, EX_ALUResult);
        $display("MEM_WriteRegNum: %h, Expected: %h", MEM_WriteRegNum, EX_WriteRegNum);
        $display("MEM_WriteMemData: %h, Expected: %h", MEM_WriteMemData, EX_WriteMemData);

        // Test case 2: Reset the module and verify outputs again
        reset_n = 0;
        #10;
        reset_n = 1;

        // Test case 3: Change control signals and verify behavior
        EX_cntl_MemWrite = 0;
        EX_cntl_RegWrite = 1;
        EX_sel_MemToReg = 3'b010;

        #10;

        // Check if MEM stage values match EX stage values after control signal change
        $display("MEM_PCplus4: %h, Expected: %h", MEM_PCplus4, EX_PCplus4);
        $display("MEM_BranchAddr: %h, Expected: %h", MEM_BranchAddr, EX_BranchAddr);
        $display("MEM_immediate: %h, Expected: %h", MEM_immediate, EX_immediate);
        $display("MEM_cntl_MemWrite: %b, Expected: %b", MEM_cntl_MemWrite, EX_cntl_MemWrite);
        $display("MEM_cntl_RegWrite: %b, Expected: %b", MEM_cntl_RegWrite, EX_cntl_RegWrite);
        $display("MEM_sel_MemToReg: %b, Expected: %b", MEM_sel_MemToReg, EX_sel_MemToReg);

        // End simulation
        $finish;
    end

endmodule
