`timescale 1ns / 1ps

module widthContrl(
    input [2:0] funct3,
    input [31:0] word,
    output [31:0] OutputWord
    );
    
    /* signed operand 1 */
    wire signed [31:0] singed_word;
    
    wire signed [31:0] singed_byte;
    wire signed [31:0] singed_halfword;
    
    assign singed_word = word;
    
    assign singed_byte = (singed_word << 24) >>> 24;
    assign singed_halfword = (singed_word << 16) >>> 16;
    
    assign OutputWord = (funct3 == 3'b000) ? singed_byte : 
                        (funct3 == 3'b001) ? singed_halfword :
                        (funct3 == 3'b010) ? word : 
                        (funct3 == 3'b100) ? {24'b0, word[7:0]} :
                        (funct3 == 3'b101) ? {16'b0, word[15:0]} :32'hxxxx_xxxx;    
endmodule