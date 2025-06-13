`timescale 1ns / 1ps

module EX_ForwardingUnit_tb;

    // Inputs
    reg [6:0] EX_opcode;
    reg WB_cntl_RegWrite;
    reg MEM_cntl_RegWrite;
    reg [4:0] WB_WriteRegNum;
    reg [4:0] MEM_WriteRegNum;
    reg [4:0] EX_ReadRegNum1;
    reg [4:0] EX_ReadRegNum2;

    // Outputs
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    // Instantiate the EX_ForwardingUnit
    EX_ForwardingUnit uut (
        .EX_opcode(EX_opcode),
        .WB_cntl_RegWrite(WB_cntl_RegWrite),
        .MEM_cntl_RegWrite(MEM_cntl_RegWrite),
        .WB_WriteRegNum(WB_WriteRegNum),
        .MEM_WriteRegNum(MEM_WriteRegNum),
        .EX_ReadRegNum1(EX_ReadRegNum1),
        .EX_ReadRegNum2(EX_ReadRegNum2),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    initial begin
        $display("Time\tEX_opcode\tWB_RegWrite\tMEM_RegWrite\tWB_WriteRegNum\tMEM_WriteRegNum\tEX_ReadRegNum1\tEX_ReadRegNum2\tForwardA\tForwardB");
        $monitor("%4dns\t%b\t\t%b\t\t%b\t\t%d\t\t%d\t\t%d\t\t%d\t\t%b\t%b",
                 $time, EX_opcode, WB_cntl_RegWrite, MEM_cntl_RegWrite, WB_WriteRegNum, MEM_WriteRegNum, 
                 EX_ReadRegNum1, EX_ReadRegNum2, ForwardA, ForwardB);

        // Initialize Inputs
        WB_cntl_RegWrite = 0; MEM_cntl_RegWrite = 0;
        WB_WriteRegNum = 0; MEM_WriteRegNum = 0;
        EX_ReadRegNum1 = 0; EX_ReadRegNum2 = 0;
        EX_opcode = 7'b0110011; // R-Type Instruction
        #10;

        // Test Case 1: No forwarding (no write-backs in WB or MEM)
        WB_cntl_RegWrite = 0; MEM_cntl_RegWrite = 0;
        WB_WriteRegNum = 5'd1; MEM_WriteRegNum = 5'd2;
        EX_ReadRegNum1 = 5'd3; EX_ReadRegNum2 = 5'd4;
        #10;

        // Test Case 2: ForwardA from WB
        WB_cntl_RegWrite = 1; MEM_cntl_RegWrite = 0;
        WB_WriteRegNum = 5'd3; MEM_WriteRegNum = 5'd2;
        EX_ReadRegNum1 = 5'd3; EX_ReadRegNum2 = 5'd4;
        #10;

        // Test Case 3: ForwardB from WB
        WB_cntl_RegWrite = 1; MEM_cntl_RegWrite = 0;
        WB_WriteRegNum = 5'd4; MEM_WriteRegNum = 5'd2;
        EX_ReadRegNum1 = 5'd3; EX_ReadRegNum2 = 5'd4;
        #10;

        // Test Case 4: ForwardA from MEM
        WB_cntl_RegWrite = 0; MEM_cntl_RegWrite = 1;
        WB_WriteRegNum = 5'd3; MEM_WriteRegNum = 5'd3;
        EX_ReadRegNum1 = 5'd3; EX_ReadRegNum2 = 5'd4;
        #10;

        // Test Case 5: ForwardB from MEM
        WB_cntl_RegWrite = 0; MEM_cntl_RegWrite = 1;
        WB_WriteRegNum = 5'd4; MEM_WriteRegNum = 5'd4;
        EX_ReadRegNum1 = 5'd3; EX_ReadRegNum2 = 5'd4;
        #10;

        // Test Case 6: ForwardA and ForwardB from both MEM and WB
        WB_cntl_RegWrite = 1; MEM_cntl_RegWrite = 1;
        WB_WriteRegNum = 5'd3; MEM_WriteRegNum = 5'd3;
        EX_ReadRegNum1 = 5'd3; EX_ReadRegNum2 = 5'd4;
        #10;

        $finish;
    end

endmodule
