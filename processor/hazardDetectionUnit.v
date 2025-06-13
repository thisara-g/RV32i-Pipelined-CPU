`timescale 1ns / 1ps

module hazardDetectionUnit(
    input EX_cntl_MemRead,
    input EX_cntl_RegWrite,
    input MEM_cntl_MemRead,
    input [6:0] ID_opcode,
    input [4:0] EX_WriteRegNum,
    input [4:0] MEM_WriteRegNum,
    input [4:0] ID_ReadRegNum1,
    input [4:0] ID_ReadRegNum2,
    input branch_mispredicted,  // Signal indicating branch misprediction
    output reg PCWrite, 
    output reg IF_IDWrite, 
    output reg ID_EXFlush
);

    wire EX_Stall;
    wire Jalr_EX_Stall;
    wire Jalr_MEM_Stall;

    // Load Stall
    assign EX_Stall = ((ID_opcode != 7'b0110111) && (ID_opcode != 7'b0010111) && (ID_opcode != 7'b1101111) && 
                       (EX_cntl_MemRead) && 
                       ((EX_WriteRegNum == ID_ReadRegNum1) || (EX_WriteRegNum == ID_ReadRegNum2))) ? 1'b1 : 1'b0;

    // Stall for JALR comparison on ID stage
    assign Jalr_EX_Stall = ((ID_opcode == 7'b1100111) &&
                            (EX_cntl_MemRead) && 
                            (EX_WriteRegNum == ID_ReadRegNum1)) ? 1'b1 : 1'b0;

    assign Jalr_MEM_Stall = ((ID_opcode == 7'b1100111) &&
                             (MEM_cntl_MemRead) && 
                             (MEM_WriteRegNum == ID_ReadRegNum1)) ? 1'b1 : 1'b0;

    always @(*) begin
        if (branch_mispredicted) begin
            // On branch misprediction, flush the pipeline and stall PC/IF_ID registers
            PCWrite = 1'b1;     // Update PC with correct target
            IF_IDWrite = 1'b0;  // Stall IF/ID registers
            ID_EXFlush = 1'b1;  // Flush ID/EX pipeline register
        end else if (EX_Stall || Jalr_EX_Stall || Jalr_MEM_Stall) begin
            // Handle other hazards like load-use or JALR dependencies
            PCWrite = 1'b0;     // Stall PC
            IF_IDWrite = 1'b0;  // Stall IF/ID registers
            ID_EXFlush = 1'b1;  // Flush ID/EX pipeline register
        end else begin
            // Normal operation
            PCWrite = 1'b1;     // Enable PC write
            IF_IDWrite = 1'b1;  // Enable IF/ID writes
            ID_EXFlush = 1'b0;  // No pipeline flush
        end
    end

endmodule
