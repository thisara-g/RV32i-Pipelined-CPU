`timescale 1ns / 1ps

module processor_tb;

    // Testbench signals
    reg clk;
    reg reset_n;

    // Instantiate the processor module
    processor uut (
        .clk(clk),
        .reset_n(reset_n)
    );

    // Generate clock signal
    always begin
        #5 clk = ~clk;  // Toggle clk every 5ns
    end

    // Initialize signals and apply test cases
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;

        // Apply reset
        #10 reset_n = 1;  // Release reset after 10ns


        // Add further test cases if needed
        #15000;
        
        $finish;  // End simulation
    end

    // Add monitor to observe signals
    initial begin
        $monitor("At time %t, PC: %h, Instr: %h", $time, uut.IF_PC, uut.IF_Instr);
    end

    initial begin
        $dumpfile("processor_tb.vcd");
        $dumpvars(0, processor_tb);
    end

endmodule
