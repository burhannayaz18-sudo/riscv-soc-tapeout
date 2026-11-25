`timescale 1ns / 1ps

module axis_jammer_wrapper (
    input  wire        aclk,        // AXI Clock
    input  wire        aresetn,     // AXI Reset (Active Low)
    output wire [31:0] m_axis_tdata, // 32-bit packed I/Q data
    output wire        m_axis_tvalid,// Data is valid
    input  wire        m_axis_tready // Receiver is ready
);

    wire signed [15:0] i_out;
    wire signed [15:0] q_out;

    // Instantiate your jammer!
    jammer_tx u_jammer (
        .clk(aclk),
        .reset_n(aresetn),
        .enable(1'b1),      // Hardcoded to always ON for now
        .i_out(i_out),
        .q_out(q_out)
    );

    // Pack I (16-bit) and Q (16-bit) into a single 32-bit word.
    // ADI standard format usually packs I in the lower 16 bits and Q in the upper.
    assign m_axis_tdata = {q_out, i_out};
    
    // Handshake logic: Valid goes high when we have data, AND the receiver is ready.
    assign m_axis_tvalid = m_axis_tready; 

endmodule
