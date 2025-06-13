`timescale 1ns / 1ps

module Adder_tb;

    // Testbench signals
    reg [31:0] op1;
    reg [31:0] op2;
    wire [31:0] result;

    // Instantiate the Adder module
    Adder uut (
        .op1(op1),
        .op2(op2),
        .result(result)
    );

    initial begin
        $display("Starting 32-bit Adder testbench...");

        // Test case 1: Small numbers
        op1 = 32'd15; op2 = 32'd10; #10;
        $display("op1: %d, op2: %d, result: %d", op1, op2, result);

        // Test case 2: Larger numbers
        op1 = 32'd100000; op2 = 32'd250000; #10;
        $display("op1: %d, op2: %d, result: %d", op1, op2, result);

        // Test case 3: Maximum values
        op1 = 32'hFFFFFFFF; op2 = 32'hFFFFFFFF; #10;
        $display("op1: %h, op2: %h, result: %h (overflow expected)", op1, op2, result);

        // Test case 4: Mixed positive and negative values (two's complement)
        op1 = 32'd1000; op2 = -32'd2000; #10;
        $display("op1: %d, op2: %d, result: %d", op1, op2, result);

        // Test case 5: Zero addition
        op1 = 32'd0; op2 = 32'd12345; #10;
        $display("op1: %d, op2: %d, result: %d", op1, op2, result);

        $display("32-bit Adder testbench completed.");
        $stop;
    end

endmodule
