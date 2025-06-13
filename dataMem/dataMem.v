`timescale 1ns / 1ps

module dataMem(
    input       clk,
    input       MemWrite,
    input [31:0] addr,
    input [31:0] din,
    output [31:0] dout
);

    // Memory declaration: 2D array with 8-bit cells, 1M locations (for simplicity)
    reg [7:0] mem [0:1048575]; // 1M words of 8-bit memory

    // Read the memory contents from a file (only works in simulation/synthesis tool)
    initial begin
        $readmemh("memory_init.hex", mem);  // Load memory contents from an external hex file
    end

    // Synchronous write and read logic
    always @ (posedge clk) begin
        if (MemWrite) begin
            // Writing data to memory (4 bytes at once)
            {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]} <= din;
        end
        // Read data from memory
        
    end

    assign dout = {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]};

endmodule

