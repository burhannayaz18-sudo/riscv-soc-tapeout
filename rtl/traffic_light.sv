`timescale 1ns / 1ps
module traffic_light (
    input  logic clk,
    input  logic reset_n,
    input  logic enable,
    output logic [2:0] lights
);
    typedef enum logic [1:0] {GREEN, YELLOW, RED} state_t;
    state_t current_state, next_state;

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) current_state <= GREEN;
        else          current_state <= next_state;
    end

    always_comb begin
        next_state = current_state;
        if (enable) begin
            case (current_state)
                GREEN:  next_state = YELLOW;
                YELLOW: next_state = RED;
                RED:    next_state = GREEN;
                default: next_state = GREEN;
            endcase
        end
    end

    always_comb begin
        case (current_state)
            GREEN:  lights = 3'b001;
            YELLOW: lights = 3'b010;
            RED:    lights = 3'b100;
            default: lights = 3'b001;
        endcase
    end
endmodule
