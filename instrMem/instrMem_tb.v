`timescale 1ns / 1ps

module instrMem_tb;

    // Inputs
    reg [31:0] iaddr;

    // Outputs
    wire [31:0] dout;

    // Instantiate the module under test
    instrMem uut (
        .iaddr(iaddr),
        .dout(dout)
    );

    // Test procedure
    initial begin
        $display("Starting InstrMem Testbench");
        
        // Monitor changes
        $monitor("Time: %0t | iaddr: %h | dout: %b", $time, iaddr, dout);

        // Test a few addresses
        iaddr = 32'h00000000; #10; // Address 0
        iaddr = 32'h00000004; #10; // Address 1
        iaddr = 32'h00000008; #10; // Address 2
        iaddr = 32'h0000000C; #10; // Address 3
        iaddr = 32'h00000010; #10; // Address 4
        iaddr = 32'h00000014; #10; // Address 5
        iaddr = 32'h00000018; #10; // Address 6
        iaddr = 32'h0000001C; #10; // Address 7
        iaddr = 32'h00000020; #10; // Address 8
        iaddr = 32'h00000024; #10; // Address 9
        iaddr = 32'h00000028; #10; // Address 10

        // Test default case (address outside defined range)
        iaddr = 32'h00000400; #10; // Out of range
        iaddr = 32'hFFFFFFFC; #10; // Out of range

        $display("Testbench completed");
        $finish;
    end

endmodule
