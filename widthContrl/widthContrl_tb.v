`timescale 1ns / 1ps

module widthContrl_tb;

    // Testbench signals
    reg [2:0] funct;
    reg [31:0] word;
    wire [31:0] OutputWord;

    // Instantiate the widthContrl module
    widthContrl uut (
        .funct3(funct),
        .word(word),
        .OutputWord(OutputWord)
    );

    // Test procedure
    initial begin
        // Test 1: Signed Byte
        word = 32'hFFFFFF85;  // -123 in signed 8-bit
        funct = 3'b000;
        #10;
        $display("Test 1 (Signed Byte): word = %h, OutputWord = %h", word, OutputWord);

        // Test 2: Signed Halfword
        word = 32'hFFFF8001;  // -32767 in signed 16-bit
        funct = 3'b001;
        #10;
        $display("Test 2 (Signed Halfword): word = %h, OutputWord = %h", word, OutputWord);

        // Test 3: Word
        word = 32'h12345678;  // Arbitrary value
        funct = 3'b010;
        #10;
        $display("Test 3 (Word): word = %h, OutputWord = %h", word, OutputWord);

        // Test 4: Unsigned Byte
        word = 32'h00000085;  // 133 in unsigned 8-bit
        funct = 3'b100;
        #10;
        $display("Test 4 (Unsigned Byte): word = %h, OutputWord = %h", word, OutputWord);

        // Test 5: Unsigned Halfword
        word = 32'h00008001;  // 32769 in unsigned 16-bit
        funct = 3'b101;
        #10;
        $display("Test 5 (Unsigned Halfword): word = %h, OutputWord = %h", word, OutputWord);

        // Test 6: Invalid funct
        word = 32'hAABBCCDD;
        funct = 3'b111;  // Invalid funct
        #10;
        $display("Test 6 (Invalid funct): word = %h, OutputWord = %h", word, OutputWord);

        // End simulation
        $finish;
    end

endmodule
