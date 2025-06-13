`timescale 1ns / 1ps

module branchPredict (
    input wire clk,
    input wire reset_n,
    input wire branch_taken,       // Actual branch outcome
    input wire branch_request,     // Is a branch being predicted
    output reg predict_taken       // Predicted outcome
);

    // Predictor states
    reg [1:0] state;

    // State encoding
    localparam STRONGLY_NOT_TAKEN = 2'b00;
    localparam WEAKLY_NOT_TAKEN   = 2'b01;
    localparam WEAKLY_TAKEN       = 2'b10;
    localparam STRONGLY_TAKEN     = 2'b11;

    always @(*) begin

        case (state)
                STRONGLY_NOT_TAKEN: predict_taken = 0;
                WEAKLY_NOT_TAKEN:   predict_taken = 0;
                WEAKLY_TAKEN:       predict_taken = 1;
                STRONGLY_TAKEN:     predict_taken = 1;
        endcase
    end
    

    // Prediction logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= STRONGLY_NOT_TAKEN;  // Initialize to strongly not taken
        end else if (branch_request) begin

            // Update state based on actual branch outcome
            if (branch_taken) begin
                // Branch was taken
                case (state)
                    STRONGLY_NOT_TAKEN: state <= WEAKLY_NOT_TAKEN;
                    WEAKLY_NOT_TAKEN:   state <= WEAKLY_TAKEN;
                    WEAKLY_TAKEN:       state <= STRONGLY_TAKEN;
                    STRONGLY_TAKEN:     state <= STRONGLY_TAKEN;
                endcase
            end else begin
                // Branch was not taken
                case (state)
                    STRONGLY_NOT_TAKEN: state <= STRONGLY_NOT_TAKEN;
                    WEAKLY_NOT_TAKEN:   state <= STRONGLY_NOT_TAKEN;
                    WEAKLY_TAKEN:       state <= WEAKLY_NOT_TAKEN;
                    STRONGLY_TAKEN:     state <= WEAKLY_TAKEN;
                endcase
            end
        end
    end
endmodule
