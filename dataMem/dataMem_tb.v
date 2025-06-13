`timescale 1ns / 1ps

module dataMem_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg MemWrite;
    reg [31:0] addr;
    reg [31:0] din;
    wire [31:0] dout;

    // Instantiate the DataMem module
    dataMem uut (
        .clk(clk),
        .MemWrite(MemWrite),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 100 MHz clock (10ns period)
    end

    // Initialize testbench signals
    initial begin
        // Initial values
        clk = 0;
        reset = 0;
        MemWrite = 0;
        addr = 0;
        din = 0;

        // Reset the memory
        reset = 1;
        #10;
        reset = 0;

        // Writing values to memory (write enabled by MemWrite signal)
        $display("Writing values to memory...");

        MemWrite = 1;  // Enable write

        // Write 32'hA5A5_A5A5 to address 0x00000000
        addr = 32'h00000000;
        din = 32'hA5A5_A5A5;
        #10;  // Wait for 1 clock cycle

        // Write 32'h1234_5678 to address 0x00000004
        addr = 32'h00000004;
        din = 32'h1234_5678;
        #10;

        // Write 32'hDEAD_BEEF to address 0x00000008
        addr = 32'h00000008;
        din = 32'hDEAD_BEEF;
        #10;

        // Disable write for next test
        MemWrite = 0;

        // Now reading back the written values to check correctness
        $display("Reading values from memory...");

        addr = 32'h00000000;  // Address 0
        #10;
        $display("mem[0] = %h, Expected = A5A5_A5A5", dout);

        addr = 32'h00000004;  // Address 4
        #10;
        $display("mem[4] = %h, Expected = 1234_5678", dout);

        addr = 32'h00000008;  // Address 8
        #10;
        $display("mem[8] = %h, Expected = DEAD_BEEF", dout);

        // Write new values to check if it overwrites previous values
        MemWrite = 1;

        // Write 32'h1111_2222 to address 0x00000000 (overwrite previous value)
        addr = 32'h00000000;
        din = 32'h1111_2222;
        #10;

        // Write 32'h3333_4444 to address 0x00000004 (overwrite previous value)
        addr = 32'h00000004;
        din = 32'h3333_4444;
        #10;

        // Disable write for next test
        MemWrite = 0;

        // Now reading back the overwritten values
        $display("Reading overwritten values...");

        addr = 32'h00000000;  // Address 0
        #10;
        $display("mem[0] = %h, Expected = 1111_2222", dout);

        addr = 32'h00000004;  // Address 4
        #10;
        $display("mem[4] = %h, Expected = 3333_4444", dout);

        // End the simulation
        $finish;
    end

endmodule

