// ===================================================================
// Module: CTRL8
// 
// This is control-unit for 2nd stage Butterfly unit
// Function:
//      1. Determine the input of the Butterfly unit
//      2. Give the exp(-j*2pi*n/N) to Butterfly unit
//      3. Control the input and the mux before/after the shift register
//
// Note that data_out is connected to the port A of the Butterfly unit
//     (flipfloped data_in)
// 
// ===================================================================
module CTRL8(
    input                       clk,
    input                       rst_n,
    input                       valid_i,
    input signed [13:0]         data_in_r,
    input signed [13:0]         data_in_i,
    
    output reg                  valid_o,         
    output reg [1:0]            state,
    output reg signed [13:0]    data_out_r,
    output reg signed [13:0]    data_out_i,
    output reg signed [7:0]     WN_r,
    output reg signed [7:0]     WN_i
);
    
    // state parameter
    parameter IDLE      = 2'b00;
    parameter FIRST     = 2'b01;
    parameter SECOND    = 2'b10;
    parameter WAITING   = 2'b11;

    // Wire-Reg declaration
    reg [8:0] count, next_count;
    reg [1:0] next_state;
    reg next_valid_o;
    
    // Combinational part - state logic
    always@(*) begin
        next_count = count;
        next_state = state;
        next_valid_o = valid_o;
        case(state)
            IDLE: begin
                next_count = 0;
                if(valid_i) begin
                    next_state = WAITING;
                    next_count = 1;
                end
            end
            WAITING: begin
                next_count = count + 1;
                if(count == 8) begin
                    next_state = FIRST;
                    // After 8 cycles, we are going to output g
                    next_valid_o = 1;
                end
            end
            FIRST: begin
                next_count = count + 1;
                if(count == 16) begin
                    // After 16 cycles, we are going to output h
                    next_state = SECOND;
                end
            end
            SECOND: begin
                next_count = count + 1;
                if(count == 24) begin
                    // After 24 cycles, all data have been outputed
                    if(valid_i) begin
                        next_state = FIRST;
                        next_count = 9;
                    end
                    else begin
                        next_state = IDLE;
                        next_count = 0;
                        next_valid_o = 0;
                    end
                end
            end
        endcase
    end

    // Combinational part - WN logic
    always@(*) begin
        // Send the exp(-j*2*pi*n/16) where n go from 0 to 15
        // format: 10bit (2 integer, 6 fractional)
        case(count)
            17: begin
                WN_r = 8'b01000000;
                WN_i = 8'b00000000;
            end
            18: begin
                WN_r = 8'b00111011;
                WN_i = 8'b11100111;
            end
            19: begin
                WN_r = 8'b00101101;
                WN_i = 8'b11010010;
            end
            20: begin
                WN_r = 8'b00011000;
                WN_i = 8'b11000100;
            end
            21: begin
                WN_r = 8'b00000000;
                WN_i = 8'b11000000;
            end
            22: begin
                WN_r = 8'b11100111;
                WN_i = 8'b11000100;
            end
            23: begin
                WN_r = 8'b11010010;
                WN_i = 8'b11010010;
            end
            24: begin
                WN_r = 8'b11000100;
                WN_i = 8'b11100111;
            end
            default: begin
                WN_r = 8'b00000000;
                WN_i = 8'b00000000;
            end
        endcase
    end

    // Sequential part
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
            count <= 0;
            data_out_r <= 0;
            data_out_i <= 0;
            valid_o <= 0;
        end
        else begin
            state <= next_state;
            count <= next_count;
            data_out_r <= data_in_r;
            data_out_i <= data_in_i;
            valid_o <= next_valid_o;
        end
    end
endmodule