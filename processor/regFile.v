`timescale 1ns / 1ps


module regFile(
    input clk,                      // Clock signal
    input we,                       // Write enable signal
    input [4:0] rs1, rs2, wraddr,   // 5-bit registers for source and destination
    input [31:0] wrdata,            // Data to write to the register file
    output wire [31:0] rdout1, rdout2    // Output read data
 /*   output reg1,
    output reg2,
    output reg3,
    output reg4,
    output reg5,
    output reg6,
    output reg7,
    output reg8,
    output reg9,
    output reg10*/
);

    reg [31:0] x [31:0];                 // 32 general-purpose registers, 32-bit wide

/*
    assign reg1 = (x[1] == )? 1'b1 : 1'b0;
    assign reg2 = (x[2] == )? 1'b1 : 1'b0;
    assign reg3 = (x[3] == )? 1'b1 : 1'b0;
    assign reg4 = (x[4] == )? 1'b1 : 1'b0;
    assign reg5 = (x[5] == )? 1'b1 : 1'b0;
    assign reg6 = (x[6] == )? 1'b1 : 1'b0;
    assign reg7 = (x[7] == )? 1'b1 : 1'b0;
    assign reg8 = (x[8] == )? 1'b1 : 1'b0;
    assign reg9 = (x[9] == )? 1'b1 : 1'b0;
    assign reg10 = (x[10] == )? 1'b1 : 1'b0;

    
  */  
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

