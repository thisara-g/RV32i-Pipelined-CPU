https://github.com/bjybs123/Pipelined-RV32I/blob/main/DataMem.v

`timescale 1ns / 1ps

module Adder(
    input [31:0] op1, 
    input [31:0] op2,
    output [31:0] result
    );
    
    assign result = op1 + op2;
    
endmodule