`timescale 1ns / 1ps
module traffic_light_tb;
    logic clk, reset_n, enable;
    logic [2:0] lights;

    traffic_light dut (.clk(clk), .reset_n(reset_n), .enable(enable), .lights(lights));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset_n = 0; enable = 0;
        #20; reset_n = 1;
        @(posedge clk); enable = 1;
        @(posedge clk); enable = 0;
        #50; enable = 1;
        @(posedge clk); enable = 0;
        #50; enable = 1;
        @(posedge clk); enable = 0;
        #50;
        $display("Simulation complete!");
        $finish;
    end

    initial begin
        $dumpfile("tb/traffic_light_tb.vcd");
        $dumpvars(0, traffic_light_tb);
    end
endmodule
