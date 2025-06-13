`timescale 1ns / 1ps

module ALU_tb;

    // Inputs
    reg [2:0] funct;
    reg [31:0] op1;
    reg [31:0] op2;
    reg [3:0] ALUcntl;

    // Outputs
    wire [31:0] ALUResult;

    // Instantiate the ALU module
    ALU uut (
        .funct(funct),
        .op1(op1),
        .op2(op2),
        .ALUcntl(ALUcntl),
        .ALUResult(ALUResult)
    );

    initial begin
        $display("Time\tALUcntl\tfunct\top1\t\top2\t\tALUResult");
        $monitor("%4dns\t%b\t%b\t%h\t%h\t%h", $time, ALUcntl, funct, op1, op2, ALUResult);

        // Test Logical AND
        ALUcntl = 4'b0000; funct = 3'b000; op1 = 32'hFFFF_FFFF; op2 = 32'h5555_5555;
        #10; // Expect ALUResult = 32'h5555_5555

        // Test Logical OR
        ALUcntl = 4'b0001; funct = 3'b000; op1 = 32'hAAAA_AAAA; op2 = 32'h5555_5555;
        #10; // Expect ALUResult = 32'hFFFF_FFFF

        // Test Logical XOR
        ALUcntl = 4'b0010; funct = 3'b000; op1 = 32'hAAAA_AAAA; op2 = 32'h5555_5555;
        #10; // Expect ALUResult = 32'hFFFF_FFFF

        // Test Logical Shift Left
        ALUcntl = 4'b0011; funct = 3'b000; op1 = 32'h0000_0001; op2 = 32'd4;
        #10; // Expect ALUResult = 32'h0000_0010

        // Test Logical Shift Right
        ALUcntl = 4'b0100; funct = 3'b000; op1 = 32'h0000_0010; op2 = 32'd1;
        #10; // Expect ALUResult = 32'h0000_0001

        // Test Arithmetic Shift Right
        ALUcntl = 4'b0101; funct = 3'b000; op1 = 32'h8000_0000; op2 = 32'd1;
        #10; // Expect ALUResult = 32'hC000_0000

        // Test Addition
        ALUcntl = 4'b0110; funct = 3'b000; op1 = 32'd10; op2 = 32'd20;
        #10; // Expect ALUResult = 32'd30

        // Test Subtraction
        ALUcntl = 4'b0111; funct = 3'b000; op1 = 32'd20; op2 = 32'd10;
        #10; // Expect ALUResult = 32'd10

        // Test Branch - Less Than
        ALUcntl = 4'b0111; funct = 3'b010; op1 = 32'd10; op2 = 32'd20;
        #10; // Expect ALUResult = 32'h0000_0001 (op1 < op2)

        // Test Branch - Greater Than
        ALUcntl = 4'b0111; funct = 3'b010; op1 = 32'd20; op2 = 32'd10;
        #10; // Expect ALUResult = 32'h0000_0000 (op1 >= op2)

        // End simulation
        $finish;
    end

endmodule
