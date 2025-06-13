`timescale 1ns / 1ps

module MEM_WB_tb;

    // Testbench signals
    reg clk;
    reg reset_n;
    reg [31:0] MEM_PCplus4;
    reg [31:0] MEM_BranchAddr;
    reg [31:0] MEM_immediate;
    reg MEM_cntl_RegWrite;
    reg [2:0] MEM_sel_MemToReg;
    reg [2:0] MEM_funct;
    reg [31:0] MEM_ReadMemData;
    reg [31:0] MEM_ALUResult;
    reg [4:0] MEM_WriteRegNum;

    wire [31:0] WB_PCplus4;
    wire [31:0] WB_BranchAddr;
    wire [31:0] WB_immediate;
    wire WB_cntl_RegWrite;
    wire [2:0] WB_sel_MemToReg;
    wire [2:0] WB_funct;
    wire [31:0] WB_ReadMemData;
    wire [31:0] WB_ALUResult;
    wire [4:0] WB_WriteRegNum;

    // Instantiate the MEM_WB module
    MEM_WB uut (
        .clk(clk),
        .reset_n(reset_n),
        .MEM_PCplus4(MEM_PCplus4),
        .MEM_BranchAddr(MEM_BranchAddr),
        .MEM_immediate(MEM_immediate),
        .MEM_cntl_RegWrite(MEM_cntl_RegWrite),
        .MEM_sel_MemToReg(MEM_sel_MemToReg),
        .MEM_funct(MEM_funct),
        .MEM_ReadMemData(MEM_ReadMemData),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_WriteRegNum(MEM_WriteRegNum),
        .WB_PCplus4(WB_PCplus4),
        .WB_BranchAddr(WB_BranchAddr),
        .WB_immediate(WB_immediate),
        .WB_cntl_RegWrite(WB_cntl_RegWrite),
        .WB_sel_MemToReg(WB_sel_MemToReg),
        .WB_funct(WB_funct),
        .WB_ReadMemData(WB_ReadMemData),
        .WB_ALUResult(WB_ALUResult),
        .WB_WriteRegNum(WB_WriteRegNum)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5ns for a 10ns period
    end

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        MEM_PCplus4 = 32'h0;
        MEM_BranchAddr = 32'h0;
        MEM_immediate = 32'h0;
        MEM_cntl_RegWrite = 0;
        MEM_sel_MemToReg = 3'b000;
        MEM_funct = 3'b000;
        MEM_ReadMemData = 32'h0;
        MEM_ALUResult = 32'h0;
        MEM_WriteRegNum = 5'b00000;

        // Apply reset
        #10;
        reset_n = 1;

        // Test case 1: Write valid data to MEM_WB register
        #10;
        MEM_PCplus4 = 32'h100;
        MEM_BranchAddr = 32'h200;
        MEM_immediate = 32'h300;
        MEM_cntl_RegWrite = 1;
        MEM_sel_MemToReg = 3'b001;
        MEM_funct = 3'b010;
        MEM_ReadMemData = 32'hABCD1234;
        MEM_ALUResult = 32'h56789ABC;
        MEM_WriteRegNum = 5'b00001;

        #10;
        // Expected: WB_PCplus4 = 0x100, WB_BranchAddr = 0x200, WB_immediate = 0x300,
        //           WB_cntl_RegWrite = 1, WB_sel_MemToReg = 3'b001, WB_funct = 3'b010,
        //           WB_ReadMemData = 0xABCD1234, WB_ALUResult = 0x56789ABC, WB_WriteRegNum = 1
        $display("Test case 1: WB_PCplus4=%h, WB_BranchAddr=%h, WB_immediate=%h", WB_PCplus4, WB_BranchAddr, WB_immediate);
        $display("Test case 1: WB_cntl_RegWrite=%b, WB_sel_MemToReg=%b, WB_funct=%b", WB_cntl_RegWrite, WB_sel_MemToReg, WB_funct);
        $display("Test case 1: WB_ReadMemData=%h, WB_ALUResult=%h, WB_WriteRegNum=%d", WB_ReadMemData, WB_ALUResult, WB_WriteRegNum);

        // Test case 2: Reset the system (set reset_n to 0)
        #10;
        reset_n = 0;
        #10;
        // Expected: All WB signals should reset to 0
        $display("Test case 2: WB_PCplus4=%h, WB_BranchAddr=%h, WB_immediate=%h", WB_PCplus4, WB_BranchAddr, WB_immediate);
        $display("Test case 2: WB_cntl_RegWrite=%b, WB_sel_MemToReg=%b, WB_funct=%b", WB_cntl_RegWrite, WB_sel_MemToReg, WB_funct);
        $display("Test case 2: WB_ReadMemData=%h, WB_ALUResult=%h, WB_WriteRegNum=%d", WB_ReadMemData, WB_ALUResult, WB_WriteRegNum);

        // Test case 3: Apply new values after reset
        #10;
        reset_n = 1;
        MEM_PCplus4 = 32'h400;
        MEM_BranchAddr = 32'h500;
        MEM_immediate = 32'h600;
        MEM_cntl_RegWrite = 1;
        MEM_sel_MemToReg = 3'b010;
        MEM_funct = 3'b011;
        MEM_ReadMemData = 32'hDEF01234;
        MEM_ALUResult = 32'hFEDCBA98;
        MEM_WriteRegNum = 5'b00010;

        #10;
        // Expected: WB_PCplus4 = 0x400, WB_BranchAddr = 0x500, WB_immediate = 0x600,
        //           WB_cntl_RegWrite = 1, WB_sel_MemToReg = 3'b010, WB_funct = 3'b011,
        //           WB_ReadMemData = 0xDEF01234, WB_ALUResult = 0xFEDCBA98, WB_WriteRegNum = 2
        $display("Test case 3: WB_PCplus4=%h, WB_BranchAddr=%h, WB_immediate=%h", WB_PCplus4, WB_BranchAddr, WB_immediate);
        $display("Test case 3: WB_cntl_RegWrite=%b, WB_sel_MemToReg=%b, WB_funct=%b", WB_cntl_RegWrite, WB_sel_MemToReg, WB_funct);
        $display("Test case 3: WB_ReadMemData=%h, WB_ALUResult=%h, WB_WriteRegNum=%d", WB_ReadMemData, WB_ALUResult, WB_WriteRegNum);

        // End the simulation
        $finish;
    end

endmodule
