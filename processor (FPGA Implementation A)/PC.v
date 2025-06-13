`timescale 1ns / 1ps

module PC(
    input clk,
    input reset_n,
    input PCWrite,
    input [31:0] nextPC,
    output reg [31:0] IF_PC
    );
    
    always @ (posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            IF_PC <= 0;
        end
        else begin
        	if (PCWrite) begin
            	IF_PC <= nextPC;
            end
            else begin
            	IF_PC <= IF_PC;
            end
        end
    end
    
endmodule