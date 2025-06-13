`timescale 1ns / 1ps

module branchTarget (
    input wire [31:0] currentPC,       // Current Program Counter (PC)
    input wire [31:0] currInstr,       // Next instruction to check
    input wire predict_taken,          // Branch prediction outcome (0 = not taken, 1 = taken)
    output reg [31:0] targetPC         // Calculated PC target if branch is predicted taken
);



    wire [6:0] opcode;


    assign opcode = currInstr[6:0];           // Extract opcode (bits [6:0])

    always @(*) begin
        if (predict_taken) begin
            // Check if the instruction is a branch instruction
            if (opcode == 7'b1100011) begin
                // If it is a branch, calculate the target address
                // Sign-extend the immediate and shift left by 1 bit
                targetPC = currentPC + $signed({currInstr[31], currInstr[7], currInstr[30:25], currInstr[11:8], 20'b0}) >>> 19;
            end else begin
                // If it's not a branch, no change in targetPC
                targetPC = currentPC + 4;  // PC + 4 to fetch the next sequential instruction
            end
        end else begin
            // If branch is not predicted to be taken, continue with next sequential instruction
            targetPC = currentPC + 4;
        end
    end

endmodule
