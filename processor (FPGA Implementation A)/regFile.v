`timescale 1ns / 1ps

module regFile(
    input clk,                      // Clock signal
    input rst_n,                    // Active-low reset
    input we,                       // Write enable signal
    input [4:0] rs1, rs2, wraddr,   // 5-bit registers for source and destination
    input [31:0] wrdata,            // Data to write to the register file
    output wire [31:0] rdout1, rdout2, // Output read data
    output reg1,
    output reg2,
    output reg3,
    output reg4,
    output reg5,
    output reg6,
    output reg7,
    output reg8,
    output reg9,
    output reg10
);

    // 32 general-purpose registers, 32-bit wide
    reg [31:0] x [31:0];

    // Assigning read outputs based on register addresses
    assign rdout1 = (we && (rs1 == wraddr)) ? wrdata : x[rs1];
    assign rdout2 = (we && (rs2 == wraddr)) ? wrdata : x[rs2];

    // Assign reg1 to reg10 based on conditions
    assign reg1 = (x[1] == 32'h0) ? 1'b1 : 1'b0;
    assign reg2 = (x[2] == 32'h0) ? 1'b1 : 1'b0;
    assign reg3 = (x[3] == 32'h0) ? 1'b1 : 1'b0;
    assign reg4 = (x[4] == 32'h00000009) ? 1'b1 : 1'b0;
    assign reg5 = (x[5] == 32'h00000020) ? 1'b1 : 1'b0;
    assign reg6 = (x[6] == 32'h0000001C) ? 1'b1 : 1'b0;
    assign reg7 = (x[7] == 32'h0) ? 1'b1 : 1'b0;
    assign reg8 = (x[8] == 32'h0) ? 1'b1 : 1'b0;
    assign reg9 = (x[9] == 32'h0) ? 1'b1 : 1'b0;
    assign reg10 = (x[10] == 32'h0) ? 1'b1 : 1'b0;

    // Synchronous write and reset handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers to 0
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                x[i] <= 32'b0;
            end
        end else if (we && wraddr != 5'b0) begin
            // Write data to the register, ignoring x[0] (constant zero register)
            x[wraddr] <= wrdata;
        end
    end

endmodule

