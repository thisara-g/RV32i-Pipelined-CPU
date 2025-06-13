`timescale 1ns / 1ps

module processor_tb;

    // Testbench signals
    reg clk;
    reg reset_n;
    wire reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10;

    // Instantiate the processor module
    processor uut (
        .clk(clk),
        .reset_n(reset_n),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg5(reg5),
        .reg6(reg6),
        .reg7(reg7),
        .reg8(reg8),
        .reg9(reg9),
        .reg10(reg10)
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
        #2500;
        
        $finish;  // End simulation
    end

    // Add monitor to observe signals
    initial begin
        $monitor("At time %t, reg1: %b, reg2: %b, reg3: %b, reg4: %b, reg5: %b, reg6: %b, reg7: %b, reg8: %b, reg9: %b, reg10: %b", 
                 $time, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10);
    end

    // VCD file generation for waveform viewing
    initial begin
        $dumpfile("processor_tb.vcd");
        $dumpvars(0, processor_tb);
    end

endmodule

