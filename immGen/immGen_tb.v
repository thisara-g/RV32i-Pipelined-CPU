`timescale 1ns / 1ps

module immGen_tb;

    // Testbench signals
    reg [31:0] currInstr;
    wire [31:0] immediate;

    // Instantiate the immGen module
    immGen uut (
        .currInstr(currInstr),
        .immediate(immediate)
    );

    // Test procedure
    initial begin
        $display("Starting immGen testbench...");

        // Test 1: LUI (U-Type)
        currInstr = 32'b00000000000000000001000010110111;  // LUI: imm[31:12] = 0x0010
        #10;
        $display("Test 1 (LUI): currInstr = %h, immediate = %h", currInstr, immediate);

        // Test 2: JAL (J-Type)
        currInstr = 32'b11111111111111111111000011101111;  // JAL: imm = -2
        #10;
        $display("Test 2 (JAL): currInstr = %h, immediate = %h", currInstr, immediate);

        // Test 3: BEQ (B-Type)
        currInstr = 32'b11111111111100001000011101100011;  // BEQ: imm = -4
        #10;
        $display("Test 3 (BEQ): currInstr = %h, immediate = %h", currInstr, immediate);

        // Test 4: LW (I-Type)
        currInstr = 32'b00000000010000001000000010000011;  // LW: imm = 4
        #10;
        $display("Test 4 (LW): currInstr = %h, immediate = %h", currInstr, immediate);

        // Test 5: SW (S-Type)
        currInstr = 32'b11111110000000000001001010100011;  // SW: imm = -32
        #10;
        $display("Test 5 (SW): currInstr = %h, immediate = %h", currInstr, immediate);

        // Test 6: ADDI (I-Type)
        currInstr = 32'b00000000000100001000000010010011;  // ADDI: imm = 1
        #10;
        $display("Test 6 (ADDI): currInstr = %h, immediate = %h", currInstr, immediate);

        // End simulation
        $finish;
    end

endmodule
