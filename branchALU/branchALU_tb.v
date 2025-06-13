`timescale 1ns / 1ps

module branchALU_tb;

    // Inputs
    reg [6:0] ID_opcode;
    reg [2:0] funct;
    reg [31:0] op1;
    reg [31:0] op2;

    // Output
    wire ExeBranch;

    // Instantiate the branchALU module
    branchALU uut (
        .ID_opcode(ID_opcode),
        .funct(funct),
        .op1(op1),
        .op2(op2),
        .ExeBranch(ExeBranch)
    );

    initial begin
        $display("Time\tID_opcode\tfunct\t\top1\t\top2\t\tExeBranch");
        $monitor("%4dns\t%b\t\t%b\t%h\t%h\t%b", $time, ID_opcode, funct, op1, op2, ExeBranch);

        // Test Case 1: BEQ (op1 == op2)
        ID_opcode = 7'b1100011; funct = 3'b000;
        op1 = 32'h0000_0005; op2 = 32'h0000_0005;
        #10; // Expect ExeBranch = 1

        // Test Case 2: BEQ (op1 != op2)
        ID_opcode = 7'b1100011; funct = 3'b000;
        op1 = 32'h0000_0005; op2 = 32'h0000_0004;
        #10; // Expect ExeBranch = 0

        // Test Case 3: BNE (op1 != op2)
        ID_opcode = 7'b1100011; funct = 3'b001;
        op1 = 32'h0000_0005; op2 = 32'h0000_0004;
        #10; // Expect ExeBranch = 1

        // Test Case 4: BLT (op1 < op2)
        ID_opcode = 7'b1100011; funct = 3'b100;
        op1 = 32'hFFFFFFFE; op2 = 32'h0000_0001;
        #10; // Expect ExeBranch = 1

        // Test Case 5: BLT (op1 >= op2)
        ID_opcode = 7'b1100011; funct = 3'b100;
        op1 = 32'h0000_0005; op2 = 32'h0000_0004;
        #10; // Expect ExeBranch = 0

        // Test Case 6: BGE (op1 >= op2)
        ID_opcode = 7'b1100011; funct = 3'b101;
        op1 = 32'h0000_0005; op2 = 32'h0000_0005;
        #10; // Expect ExeBranch = 1

        // Test Case 7: BLTU (Unsigned op1 < op2)
        ID_opcode = 7'b1100011; funct = 3'b110;
        op1 = 32'h0000_0002; op2 = 32'h0000_0005;
        #10; // Expect ExeBranch = 1

        // Test Case 8: BLTU (Unsigned op1 >= op2)
        ID_opcode = 7'b1100011; funct = 3'b110;
        op1 = 32'h0000_000A; op2 = 32'h0000_0005;
        #10; // Expect ExeBranch = 0

        // Test Case 9: BGEU (Unsigned op1 >= op2)
        ID_opcode = 7'b1100011; funct = 3'b111;
        op1 = 32'h0000_000A; op2 = 32'h0000_0005;
        #10; // Expect ExeBranch = 1

        // Test Case 10: Invalid opcode
        ID_opcode = 7'b1111111; funct = 3'b000;
        op1 = 32'h0000_0000; op2 = 32'h0000_0000;
        #10; // Expect ExeBranch = 0

        $finish;
    end

endmodule
