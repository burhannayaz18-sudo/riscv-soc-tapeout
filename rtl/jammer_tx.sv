`timescale 1ns / 1ps

module jammer_tx #(
    parameter int DAC_WIDTH = 16,
    parameter int FAC       = 200, 
    parameter int SEQ_LEN   = 50,  
    parameter int Q_OFFSET  = 1    
)(
    input  logic clk,
    input  logic reset_n,
    input  logic enable,
    output logic signed [DAC_WIDTH-1:0] i_out,
    output logic signed [DAC_WIDTH-1:0] q_out
);

    logic [15:0] fac_cnt; 
    logic [5:0]  sym_idx; 

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            fac_cnt <= 0;
            sym_idx <= 0;
        end else if (enable) begin
            if (fac_cnt == FAC - 1) begin
                fac_cnt <= 0;
                if (sym_idx == SEQ_LEN - 1) begin
                    sym_idx <= 0; 
                end else begin
                    sym_idx <= sym_idx + 1;
                end
            end else begin
                fac_cnt <= fac_cnt + 1;
            end
        end
    end

    logic bit_val;
    always_comb begin
        if (sym_idx < 30) begin
            bit_val = 1'b1;       
        end else if (sym_idx < 40) begin
            bit_val = 1'b0;       
        end else if (sym_idx < 45) begin
            bit_val = 1'b1;       
        end else begin
            bit_val = 1'b0;       
        end
    end

    localparam signed [DAC_WIDTH-1:0] MAX_VAL = 16'sh7FFF; 
    localparam signed [DAC_WIDTH-1:0] ZERO_VAL = 16'sh0000; 

    always_comb begin
        if (bit_val) begin
            i_out = MAX_VAL;
        end else begin
            i_out = ZERO_VAL;
        end
        q_out = Q_OFFSET; 
    end

endmodule
