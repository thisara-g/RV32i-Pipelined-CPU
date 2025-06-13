`timescale 1ns / 1ps

module dataMem(
    input       clk,              // Clock signal
    input       rst_n,            // Active-low reset
    input       MemWrite,         // Memory write enable
    input [31:0] addr,            // Memory address
    input [31:0] din,             // Data input (to be written)
    output [31:0] dout            // Data output (read from memory)
);

    // Memory declaration: 2D array with 8-bit cells, 256 locations (1KB of memory for simplicity)
    reg [7:0] mem [0:63];

    // Reset logic to initialize all memory locations to zero
    integer i; // Loop variable for initialization
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 64; i = i + 1) begin
                mem[i] <= 8'b0;
            end
        end else if (MemWrite) begin
            // Writing data to memory (4 bytes at once, little-endian order)
            {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]} <= din;
        end
    end

    // Continuous assignment for reading data (4 bytes, little-endian order)
    assign dout = {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]};



    // Read the memory contents from a file (only works in simulation/synthesis tool)
   /* initial begin
        $readmemh("memory_init.hex", mem);  // Load memory contents from an external hex file
    end*/


endmodule

