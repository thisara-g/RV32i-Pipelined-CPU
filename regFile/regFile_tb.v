`timescale 1ns / 1ps

module regFile_tb;

    // Testbench signals
    reg clk;
    reg we;
    reg [4:0] rs1, rs2, wraddr;
    reg [31:0] wrdata;
    wire [31:0] rdout1, rdout2;

    // Instantiate the regfile module
    regFile uut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .wraddr(wraddr),
        .wrdata(wrdata),
        .rdout1(rdout1),
        .rdout2(rdout2)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 100 MHz clock (10ns period)
    end

    // Initial testbench procedure
    initial begin
        // Initial values
        clk = 0;
        we = 0;
        rs1 = 0;
        rs2 = 0;
        wraddr = 0;
        wrdata = 0;

        // Test case 1: Write to register 1
        $display("Test 1: Write 32'h1234_5678 to register 1");
        we = 1;          // Enable write
        wraddr = 5'd1;   // Write to register 1
        wrdata = 32'h1234_5678; // Data to write
        #10;             // Wait for 1 clock cycle

        // Test case 2: Read from register 1
        $display("Test 2: Read from register 1");
        rs1 = 5'd1;      // Read from register 1
        #10;
        $display("rdout1 = %h", rdout1);  // Expect 32'h1234_5678

        // Test case 3: Write to register 2
        $display("Test 3: Write 32'h8765_4321 to register 2");
        wraddr = 5'd2;   // Write to register 2
        wrdata = 32'h8765_4321; // Data to write
        #10;             // Wait for 1 clock cycle

        // Test case 4: Read from register 2
        $display("Test 4: Read from register 2");
        rs2 = 5'd2;      // Read from register 2
        #10;
        $display("rdout2 = %h", rdout2);  // Expect 32'h8765_4321

        // Test case 5: Try writing to register 0 (x0) (should not be allowed)
        $display("Test 5: Write 32'hABCD_EF01 to register 0 (x0)");
        wraddr = 5'd0;   // Try writing to register 0
        wrdata = 32'hABCD_EF01; // Data to write
        rs1 = 5'd0;
        #10;             // Wait for 1 clock cycle
        $display("rdout1 (x0) = %h", rdout1); // Should still be 0

        // Test case 6: Write and Read from register 3
        $display("Test 6: Write and Read from register 3");
        wraddr = 5'd3;   // Write to register 3
        wrdata = 32'h5555_5555; // Data to write
        #10;             // Wait for 1 clock cycle
        rs1 = 5'd3;      // Read from register 3
        #10;
        $display("rdout1 (register 3) = %h", rdout1);  // Expect 32'h5555_5555

        // End simulation
        $finish;
    end

endmodule
