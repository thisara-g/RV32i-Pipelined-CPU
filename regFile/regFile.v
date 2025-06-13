`timescale 1ns / 1ps


module regFile(
    input clk,                      // Clock signal
    input we,                       // Write enable signal
    input [4:0] rs1, rs2, wraddr,   // 5-bit registers for source and destination
    input [31:0] wrdata,            // Data to write to the register file
    output wire [31:0] rdout1, rdout2    // Output read data
);

    reg [31:0] x [31:0];                 // 32 general-purpose registers, 32-bit wide
    
    // Assigning read outputs based on register addresses
    assign rdout1 = (we && (rs1 == wraddr)) ? wrdata : x[rs1];
    assign rdout2 = (we && (rs2 == wraddr)) ? wrdata : x[rs2];

    // Synchronous write enable functionality (no reset required as per the request)
    always @(posedge clk) begin
        x[0] <= 32'b0;
        if (we && wraddr != 5'b0) begin    // Write enabled and prevent writing to register 0 (x0)
            x[wraddr] <= wrdata;          // Write data to the register
        end
    end

endmodule

