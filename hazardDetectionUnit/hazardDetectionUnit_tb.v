`timescale 1ns / 1ps

module hazardDetectionUnit_tb;

    // Testbench signals
    reg EX_cntl_MemRead;
    reg EX_cntl_RegWrite;
    reg MEM_cntl_MemRead;
    reg [6:0] ID_opcode;
    reg [4:0] EX_WriteRegNum;
    reg [4:0] MEM_WriteRegNum;
    reg [4:0] ID_ReadRegNum1;
    reg [4:0] ID_ReadRegNum2;

    wire PCWrite;
    wire IF_IDWrite;
    wire ID_EXFlush;

    // Instantiate the hazardDetectionUnit
    hazardDetectionUnit uut (
        .EX_cntl_MemRead(EX_cntl_MemRead),
        .EX_cntl_RegWrite(EX_cntl_RegWrite),
        .MEM_cntl_MemRead(MEM_cntl_MemRead),
        .ID_opcode(ID_opcode),
        .EX_WriteRegNum(EX_WriteRegNum),
        .MEM_WriteRegNum(MEM_WriteRegNum),
        .ID_ReadRegNum1(ID_ReadRegNum1),
        .ID_ReadRegNum2(ID_ReadRegNum2),
        .PCWrite(PCWrite),
        .IF_IDWrite(IF_IDWrite),
        .ID_EXFlush(ID_EXFlush)
    );

    // Test procedure
    initial begin
        // Initialize signals
        EX_cntl_MemRead = 0;
        EX_cntl_RegWrite = 0;
        MEM_cntl_MemRead = 0;
        ID_opcode = 7'b0000000;  // No specific opcode initially
        EX_WriteRegNum = 5'b00000;
        MEM_WriteRegNum = 5'b00000;
        ID_ReadRegNum1 = 5'b00000;
        ID_ReadRegNum2 = 5'b00000;

        // Test case 1: No hazards, normal operation
        #10;
        ID_opcode = 7'b0000000;  // No hazard, should not stall
        EX_cntl_MemRead = 0;
        MEM_cntl_MemRead = 0;

        // Check outputs (should be 3'b110: PCWrite=1, IF_IDWrite=1, ID_EXFlush=0)
        #10;
        $display("Test case 1 (No hazards): PCWrite=%b, IF_IDWrite=%b, ID_EXFlush=%b", PCWrite, IF_IDWrite, ID_EXFlush);

        // Test case 2: Load hazard (EX stage MemRead)
        EX_cntl_MemRead = 1;
        EX_WriteRegNum = 5'b00001;
        ID_ReadRegNum1 = 5'b00001; // EX and ID stages accessing the same register

        #10;
        // Check outputs (should stall)
        $display("Test case 2 (Load hazard): PCWrite=%b, IF_IDWrite=%b, ID_EXFlush=%b", PCWrite, IF_IDWrite, ID_EXFlush);

        // Test case 3: Branch hazard (EX stage with RegWrite)
        ID_opcode = 7'b1100011; // Branch instruction (opcode for branch)
        EX_cntl_RegWrite = 1;
        EX_WriteRegNum = 5'b00001;
        ID_ReadRegNum1 = 5'b00001; // EX stage writes to register 1, and ID stage reads from it

        #10;
        // Check outputs (should stall)
        $display("Test case 3 (Branch hazard): PCWrite=%b, IF_IDWrite=%b, ID_EXFlush=%b", PCWrite, IF_IDWrite, ID_EXFlush);

        // Test case 4: JALR hazard (EX stage MemRead)
        ID_opcode = 7'b1100111;  // JALR instruction
        EX_cntl_MemRead = 1;
        EX_WriteRegNum = 5'b00001;
        ID_ReadRegNum1 = 5'b00001; // EX stage MemRead on the same register used by JALR in ID stage

        #10;
        // Check outputs (should stall)
        $display("Test case 4 (JALR hazard): PCWrite=%b, IF_IDWrite=%b, ID_EXFlush=%b", PCWrite, IF_IDWrite, ID_EXFlush);

        // Test case 5: No hazard with branch and memory read
        ID_opcode = 7'b1100011; // Branch opcode
        EX_cntl_RegWrite = 0;    // No write back in EX
        MEM_cntl_MemRead = 0;    // No MemRead in MEM stage
        EX_WriteRegNum = 5'b00000;
        MEM_WriteRegNum = 5'b00000;

        #10;
        // Check outputs (no stall, should proceed)
        $display("Test case 5 (No hazard with branch): PCWrite=%b, IF_IDWrite=%b, ID_EXFlush=%b", PCWrite, IF_IDWrite, ID_EXFlush);

        // Test case 6: JALR hazard with MEM read
        ID_opcode = 7'b1100111; // JALR instruction
        MEM_cntl_MemRead = 1;    // MEM stage reads memory
        MEM_WriteRegNum = 5'b00001; // Same register being written in MEM

        #10;
        // Check outputs (should stall)
        $display("Test case 6 (JALR hazard with MEM read): PCWrite=%b, IF_IDWrite=%b, ID_EXFlush=%b", PCWrite, IF_IDWrite, ID_EXFlush);

        // End simulation
        $finish;
    end

endmodule
