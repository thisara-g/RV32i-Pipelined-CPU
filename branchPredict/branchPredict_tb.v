`timescale 1ns / 1ps

module branchPredict_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg branch_taken;
    reg branch_request;
    wire predict_taken;

    // Instantiate the branch predictor module
    branchPredict uut (
        .clk(clk),
        .reset(reset),
        .branch_taken(branch_taken),
        .branch_request(branch_request),
        .predict_taken(predict_taken)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Testbench sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        branch_taken = 0;
        branch_request = 0;

        // Reset the branch predictor
        #10 reset = 0;

        // Test Case 1: Branch not taken repeatedly
        #10 branch_request = 1; branch_taken = 0;
        #10 branch_request = 0; // Wait for next clock
        #10 branch_request = 1; branch_taken = 0;
        #10 branch_request = 0;
        
        // Test Case 2: Branch taken once, then not taken
        #10 branch_request = 1; branch_taken = 1;
        #10 branch_request = 0;
        #10 branch_request = 1; branch_taken = 0;
        #10 branch_request = 0;

        // Test Case 3: Branch taken repeatedly
        #10 branch_request = 1; branch_taken = 1;
        #10 branch_request = 0;
        #10 branch_request = 1; branch_taken = 1;
        #10 branch_request = 0;

        // Test Case 4: Alternating branch outcomes
        #10 branch_request = 1; branch_taken = 1;
        #10 branch_request = 0;
        #10 branch_request = 1; branch_taken = 0;
        #10 branch_request = 0;
        #10 branch_request = 1; branch_taken = 1;
        #10 branch_request = 0;
        #10 branch_request = 1; branch_taken = 0;
        #10 branch_request = 0;

        // End of simulation
        #20 $finish;
    end

    // Monitor state and prediction
    initial begin
        $monitor("Time=%0d | Reset=%b | Branch Request=%b | Branch Taken=%b | Predict Taken=%b", 
                 $time, reset, branch_request, branch_taken, predict_taken);
    end
endmodule
