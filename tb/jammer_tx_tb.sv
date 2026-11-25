`timescale 1ns / 1ps

module jammer_tx_tb;
    // Testbench signals
    logic clk;
    logic reset_n;
    logic enable;
    logic signed [15:0] i_out;
    logic signed [15:0] q_out;

    // Instantiate the Device Under Test (DUT)
    jammer_tx dut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .i_out(i_out),
        .q_out(q_out)
    );

    // Clock Generation (10ns period = 100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus Block
    initial begin
        // 1. Initialize inputs
        reset_n = 0;
        enable = 0;

        // 2. Apply reset for 20ns
        #20;
        reset_n = 1; // Release reset

        // 3. Turn on the jammer
        enable = 1;

        // 4. Run simulation long enough to see the transitions.
        // Remember: 1 symbol = 200 clock cycles. 
        // 200 cycles * 10ns = 2000ns per symbol.
        // We need to run for at least 30 symbols (60,000ns) to see the first drop to zero.
        #80000; 

        $display("Simulation complete at time %0t", $time);
        $finish;
    end

    // Waveform Dumper
    initial begin
        $dumpfile("tb/jammer_tx_tb.vcd");
        $dumpvars(0, jammer_tx_tb);
    end
endmodule
