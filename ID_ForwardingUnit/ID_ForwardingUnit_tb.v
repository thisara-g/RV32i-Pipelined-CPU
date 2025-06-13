`timescale 1ns / 1ps

module ID_ForwardingUnit_tb;

    // Testbench signals
    reg [6:0] ID_opcode;
    reg WB_cntl_RegWrite;
    reg MEM_cntl_RegWrite;
    reg [4:0] WB_WriteRegNum;
    reg [4:0] MEM_WriteRegNum;
    reg [4:0] EX_ReadRegNum1;
    reg [4:0] EX_ReadRegNum2;

    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    // Instantiate the ID_ForwardingUnit module
    ID_ForwardingUnit uut (
        .ID_opcode(ID_opcode),
        .WB_cntl_RegWrite(WB_cntl_RegWrite),
        .MEM_cntl_RegWrite(MEM_cntl_RegWrite),
        .WB_WriteRegNum(WB_WriteRegNum),
        .MEM_WriteRegNum(MEM_WriteRegNum),
        .EX_ReadRegNum1(EX_ReadRegNum1),
        .EX_ReadRegNum2(EX_ReadRegNum2),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    // Test procedure
    initial begin
        // Initialize signals
        ID_opcode = 7'b0000000;
        WB_cntl_RegWrite = 0;
        MEM_cntl_RegWrite = 0;
        WB_WriteRegNum = 5'b00000;
        MEM_WriteRegNum = 5'b00000;
        EX_ReadRegNum1 = 5'b00000;
        EX_ReadRegNum2 = 5'b00000;

        // Test case 1: No forwarding required
        #10;
        ID_opcode = 7'b1100011;  // Branch opcode
        EX_ReadRegNum1 = 5'b00001;
        EX_ReadRegNum2 = 5'b00010;
        WB_cntl_RegWrite = 0;
        MEM_cntl_RegWrite = 0;
        WB_WriteRegNum = 5'b00000;
        MEM_WriteRegNum = 5'b00000;
        #10;
        // Expect ForwardA = 00, ForwardB = 00 (No forwarding)
        $display("Test case 1: ForwardA=%b, ForwardB=%b", ForwardA, ForwardB);

        // Test case 2: Forward from WB to A (EX_ReadRegNum1 matches WB_WriteRegNum)
        #10;
        WB_cntl_RegWrite = 1;
        MEM_cntl_RegWrite = 0;
        WB_WriteRegNum = 5'b00001;  // Match EX_ReadRegNum1
        MEM_WriteRegNum = 5'b00000;
        #10;
        // Expect ForwardA = 01 (Forward from WB)
        $display("Test case 2: ForwardA=%b, ForwardB=%b", ForwardA, ForwardB);

        // Test case 3: Forward from MEM to A (EX_ReadRegNum1 matches MEM_WriteRegNum)
        #10;
        WB_cntl_RegWrite = 0;
        MEM_cntl_RegWrite = 1;
        WB_WriteRegNum = 5'b00000;
        MEM_WriteRegNum = 5'b00001;  // Match EX_ReadRegNum1
        #10;
        // Expect ForwardA = 10 (Forward from MEM)
        $display("Test case 3: ForwardA=%b, ForwardB=%b", ForwardA, ForwardB);

        // Test case 4: Forward from WB to B (EX_ReadRegNum2 matches WB_WriteRegNum)
        #10;
        WB_cntl_RegWrite = 1;
        MEM_cntl_RegWrite = 0;
        WB_WriteRegNum = 5'b00010;  // Match EX_ReadRegNum2
        MEM_WriteRegNum = 5'b00000;
        #10;
        // Expect ForwardA = 00, ForwardB = 01 (Forward from WB)
        $display("Test case 4: ForwardA=%b, ForwardB=%b", ForwardA, ForwardB);

        // Test case 5: Forward from MEM to B (EX_ReadRegNum2 matches MEM_WriteRegNum)
        #10;
        WB_cntl_RegWrite = 0;
        MEM_cntl_RegWrite = 1;
        WB_WriteRegNum = 5'b00000;
        MEM_WriteRegNum = 5'b00010;  // Match EX_ReadRegNum2
        #10;
        // Expect ForwardA = 00, ForwardB = 10 (Forward from MEM)
        $display("Test case 5: ForwardA=%b, ForwardB=%b", ForwardA, ForwardB);

        // Test case 6: Forward from both WB and MEM to A
        #10;
        WB_cntl_RegWrite = 1;
        MEM_cntl_RegWrite = 1;
        WB_WriteRegNum = 5'b00001;  // Match EX_ReadRegNum1
        MEM_WriteRegNum = 5'b00001; // Match EX_ReadRegNum1 as well
        #10;
        // Expect ForwardA = 10 (Priority to MEM over WB)
        $display("Test case 6: ForwardA=%b, ForwardB=%b", ForwardA, ForwardB);

        // Test case 7: Forward from both WB and MEM to B
        #10;
        WB_cntl_RegWrite = 1;
        MEM_cntl_RegWrite = 1;
        WB_WriteRegNum = 5'b00010;  // Match EX_ReadRegNum2
        MEM_WriteRegNum = 5'b00010; // Match EX_ReadRegNum2 as well
        #10;
        // Expect ForwardA = 00, ForwardB = 10 (Priority to MEM over WB)
        $display("Test case 7: ForwardA=%b, ForwardB=%b", ForwardA, ForwardB);

        // End the simulation
        $finish;
    end

endmodule
