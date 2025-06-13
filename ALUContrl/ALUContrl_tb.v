`timescale 1ns / 1ps

module ALUContrl_tb;

    // Inputs
    reg [3:0] funct;
    reg [3:0] ALUOp;

    // Outputs
    wire [3:0] ALUcntl;

    // Instantiate the ALUContrl module
    ALUContrl uut (
        .funct(funct),
        .ALUOp(ALUOp),
        .ALUcntl(ALUcntl)
    );

    initial begin
        $display("Time\tALUOp\tfunct\tALUcntl");
        $monitor("%4dns\t%b\t%b\t%b", $time, ALUOp, funct, ALUcntl);

        // Test Case 1: Load (ADD operation)
        ALUOp = 4'b0000; funct = 4'b0000;
        #10; // Expect ALUcntl = 4'b0110 (ADD)

        // Test Case 2: ADDI (Immediate Addition)
        ALUOp = 4'b0001; funct = 4'b0000;
        #10; // Expect ALUcntl = 4'b0110 (ADD)

        // Test Case 3: SLLI (Logical Shift Left Immediate)
        ALUOp = 4'b0001; funct = 4'b0001;
        #10; // Expect ALUcntl = 4'b0011 (LSL)

        // Test Case 4: XORI (XOR Immediate)
        ALUOp = 4'b0001; funct = 4'b0100;
        #10; // Expect ALUcntl = 4'b0010 (XOR)

        // Test Case 5: SRLI (Logical Shift Right Immediate)
        ALUOp = 4'b0001; funct = 4'b0101;
        #10; // Expect ALUcntl = 4'b0100 (RSL)

        // Test Case 6: SRAI (Arithmetic Shift Right Immediate)
        ALUOp = 4'b0001; funct = 4'b1101;
        #10; // Expect ALUcntl = 4'b0101 (RSA)

        // Test Case 7: AND (Register AND operation)
        ALUOp = 4'b0100; funct = 4'b0111;
        #10; // Expect ALUcntl = 4'b0000 (AND)

        // Test Case 8: SUB (Register Subtraction)
        ALUOp = 4'b0100; funct = 4'b1000;
        #10; // Expect ALUcntl = 4'b0111 (SUB)

        // Test Case 9: SLT (Set Less Than)
        ALUOp = 4'b0100; funct = 4'b0010;
        #10; // Expect ALUcntl = 4'b0111 (SUB, with branching behavior)

        // Test Case 10: Default (Invalid ALUOp)
        ALUOp = 4'b1111; funct = 4'b0000;
        #10; // Expect ALUcntl = 4'bxxxx (undefined)

        // End simulation
        $finish;
    end

endmodule
