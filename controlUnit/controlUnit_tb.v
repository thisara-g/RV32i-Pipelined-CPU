`timescale 1ns / 1ps

module controlUnit_tb;

    // Inputs
    reg [2:0] funct;
    reg [6:0] opcode;

    // Outputs
    wire ID_cntl_MemWrite;
    wire ID_cntl_MemRead;
    wire ID_cntl_RegWrite;
    wire ID_cntl_Branch;
    wire [2:0] ID_sel_MemToReg;
    wire [1:0] ID_sel_ALUSrc;
    wire [1:0] ID_sel_jump;
    wire [3:0] ID_ALUOp;

    // Instantiate the ControlUnit module
    controlUnit uut (
        .funct(funct),
        .opcode(opcode),
        .ID_cntl_MemWrite(ID_cntl_MemWrite),
        .ID_cntl_MemRead(ID_cntl_MemRead),
        .ID_cntl_RegWrite(ID_cntl_RegWrite),
        .ID_cntl_Branch(ID_cntl_Branch),
        .ID_sel_MemToReg(ID_sel_MemToReg),
        .ID_sel_ALUSrc(ID_sel_ALUSrc),
        .ID_sel_jump(ID_sel_jump),
        .ID_ALUOp(ID_ALUOp)
    );

    initial begin
        $display("Time\tOpcode\tFunct\tMemWrite\tMemRead\tRegWrite\tBranch\tMemToReg\tALUSrc\tJump\tALUOp");
        $monitor("%4dns\t%b\t%b\t%b\t\t%b\t%b\t\t%b\t%b\t\t%b\t%b\t%b", 
                 $time, opcode, funct, ID_cntl_MemWrite, ID_cntl_MemRead, ID_cntl_RegWrite, ID_cntl_Branch, 
                 ID_sel_MemToReg, ID_sel_ALUSrc, ID_sel_jump, ID_ALUOp);

        // Test Case 1: Load Instruction (opcode = 000_0011)
        opcode = 7'b000_0011; funct = 3'b000;
        #10;

        // Test Case 2: Immediate ALU Operation (opcode = 001_0011, funct = 3'b000)
        opcode = 7'b001_0011; funct = 3'b000;
        #10;

        // Test Case 3: Immediate ALU Operation (Shift, opcode = 001_0011, funct = 3'b001)
        opcode = 7'b001_0011; funct = 3'b001;
        #10;

        // Test Case 4: Store Instruction (opcode = 010_0011)
        opcode = 7'b010_0011; funct = 3'b000;
        #10;

        // Test Case 5: Register-Register ALU Operation (opcode = 011_0011)
        opcode = 7'b011_0011; funct = 3'b000;
        #10;

        // Test Case 6: Branch Equal (opcode = 110_0011, funct = 3'b000)
        opcode = 7'b110_0011; funct = 3'b000;
        #10;

        // Test Case 7: Jump and Link Register (opcode = 110_0111)
        opcode = 7'b110_0111; funct = 3'b000;
        #10;

        // Test Case 8: Jump and Link (opcode = 110_1111)
        opcode = 7'b110_1111; funct = 3'b000;
        #10;

        $finish;
    end

endmodule
