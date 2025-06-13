`timescale 1ns / 1ps

module IF_ID(
    input clk, 
    input reset_n,
    input IF_IDWrite,
    input IF_IDFlush,
    input       [31:0] IF_PC,
    input		[31:0] IF_PCplus4,
    input       [31:0] IF_Instr,
    input predict_taken,
    output reg  [31:0] ID_PC,
    output reg 	[31:0] ID_PCplus4,
    output reg [31:0] ID_Instr,
    output reg ID_predict_taken
    );
    
    always @ (posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ID_PC <= 0;
            ID_PCplus4 <= 0;
            ID_Instr <= 0;
        end
        else begin
            ID_predict_taken <= predict_taken;
            if (IF_IDWrite) begin
            	if (IF_IDFlush) begin
            		ID_PC <= 0;
            		ID_Instr <= 0;
            		ID_PCplus4 <= 0;
        		end
        		else begin
            		ID_PC <= IF_PC;
            		ID_Instr <= IF_Instr;	
            		ID_PCplus4 <= IF_PCplus4;	
        		end
        	end
        	else begin
            	ID_PC <= ID_PC;
            	ID_PCplus4 <= ID_PCplus4;
            	ID_Instr <= ID_Instr;
        	end
        end
    end
    
endmodule