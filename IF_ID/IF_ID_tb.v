`timescale 1ns / 1ps

module IF_ID_tb;

    // Testbench signals
    reg clk;
    reg reset_n;
    reg IF_IDWrite;
    reg IF_IDFlush;
    reg [31:0] IF_PC;
    reg [31:0] IF_PCplus4;
    reg [31:0] IF_Instr;

    wire [31:0] ID_PC;
    wire [31:0] ID_PCplus4;
    wire [31:0] ID_Instr;

    // Instantiate the IF_ID module
    IF_ID uut (
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

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5ns for a 10ns period
    end

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        IF_IDWrite = 0;
        IF_IDFlush = 0;
        IF_PC = 32'h0;
        IF_PCplus4 = 32'h4;
        IF_Instr = 32'hA5A5A5A5;

        // Apply reset
        #10;
        reset_n = 1;

        // Test case 1: IF_IDWrite = 1, IF_IDFlush = 0 (Normal write to IF/ID register)
        #10;
        IF_IDWrite = 1;
        IF_IDFlush = 0;
        IF_PC = 32'h100;
        IF_PCplus4 = 32'h104;
        IF_Instr = 32'h12345678;
        #10;
        // Expected: ID_PC = 0x100, ID_PCplus4 = 0x104, ID_Instr = 0x12345678
        $display("Test case 1: ID_PC=%h, ID_PCplus4=%h, ID_Instr=%h", ID_PC, ID_PCplus4, ID_Instr);

        // Test case 2: IF_IDWrite = 0, IF_IDFlush = 0 (No write to IF/ID register)
        #10;
        IF_IDWrite = 0;
        IF_PC = 32'h200;
        IF_PCplus4 = 32'h204;
        IF_Instr = 32'h87654321;
        #10;
        // Expected: ID_PC, ID_PCplus4, and ID_Instr should not change
        $display("Test case 2: ID_PC=%h, ID_PCplus4=%h, ID_Instr=%h", ID_PC, ID_PCplus4, ID_Instr);

        // Test case 3: IF_IDWrite = 1, IF_IDFlush = 1 (Flush the IF/ID register)
        #10;
        IF_IDWrite = 1;
        IF_IDFlush = 1;
        IF_PC = 32'h300;
        IF_PCplus4 = 32'h304;
        IF_Instr = 32'hABCDEF01;
        #10;
        // Expected: ID_PC = 0, ID_PCplus4 = 0, ID_Instr = 0 (due to flush)
        $display("Test case 3: ID_PC=%h, ID_PCplus4=%h, ID_Instr=%h", ID_PC, ID_PCplus4, ID_Instr);

        // Test case 4: Reset the system (set reset_n to 0)
        #10;
        reset_n = 0;
        #10;
        // Expected: ID_PC, ID_PCplus4, and ID_Instr should reset to 0
        $display("Test case 4: ID_PC=%h, ID_PCplus4=%h, ID_Instr=%h", ID_PC, ID_PCplus4, ID_Instr);

        // Test case 5: Reset is deasserted, and normal writing occurs again
        #10;
        reset_n = 1;
        IF_IDWrite = 1;
        IF_IDFlush = 0;
        IF_PC = 32'h500;
        IF_PCplus4 = 32'h504;
        IF_Instr = 32'hDEADBEEF;
        #10;
        // Expected: ID_PC = 0x500, ID_PCplus4 = 0x504, ID_Instr = 0xDEADBEEF
        $display("Test case 5: ID_PC=%h, ID_PCplus4=%h, ID_Instr=%h", ID_PC, ID_PCplus4, ID_Instr);

        // End the simulation
        $finish;
    end

endmodule
