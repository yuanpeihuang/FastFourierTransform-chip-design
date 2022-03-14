// ===================================================================
// Module: CTRL2
// 
// This is control-unit for 4th stage Butterfly unit
// Function:
//      1. Determine the input of the Butterfly unit
//      2. Give the exp(-j*2pi*n/N) to Butterfly unit
//      3. Control the input and the mux before/after the shift register
//
// Note that data_out is connected to the port A of the Butterfly unit
//     (flipfloped data_in)
// 
// ===================================================================
module CTRL2(
    input                       clk,
    input                       rst_n,
    input                       valid_i,
    input signed [15:0]         data_in_r,
    input signed [15:0]         data_in_i,
    
    output reg                  valid_o,         
    output reg [1:0]            state,
    output reg signed [15:0]    data_out_r,
    output reg signed [15:0]    data_out_i,
    output reg [1:0]            WN
);
    
    // state parameter
    parameter IDLE      = 2'b00;
    parameter FIRST     = 2'b01;
    parameter SECOND    = 2'b10;
    parameter WAITING   = 2'b11;

    // WN parameter
    parameter ZERO      = 2'b00;
    parameter ONE       = 2'b01;
    parameter TWO       = 2'b10;
    parameter THREE     = 2'b11;

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
                if(count == 2) begin
                    next_state = FIRST;
                    // After 2 cycles, we are going to output g
                    next_valid_o = 1;
                end
            end
            FIRST: begin
                next_count = count + 1;
                if(count == 4) begin
                    // After 4 cycles, we are going to output h
                    next_state = SECOND;
                end
            end
            SECOND: begin
                next_count = count + 1;
                if(count == 6) begin
                    // After 6 cycles, all data have been outputed
                    if(valid_i) begin
                        next_state = FIRST;
                        next_count = 3;
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
        // Send the exp(-j*2*pi*n/4) where n go from 0 to 3
        // This is +1, -1 or 0, so the format will changed to 2bit only
        case(count)
            5:      WN = ZERO; // WN = 00
            6:      WN = ONE;  // WN = 01
            default: WN = ZERO;
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