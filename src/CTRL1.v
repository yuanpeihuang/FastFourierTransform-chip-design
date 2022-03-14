// ===================================================================
// Module: CTRL1
// 
// This is control-unit for 5th stage Butterfly unit
// Function:
//      1. Determine the input of the Butterfly unit
//      2. Give the exp(-j*2pi*n/N) to Butterfly unit
//      3. Control the input and the mux before/after the shift register
//
// Note that data_out is connected to the port A of the Butterfly unit
//     (flipfloped data_in)
// 
// ===================================================================
module CTRL1(
    input                       clk,
    input                       rst_n,
    input                       valid_i,
    input signed [16:0]         data_in_r,
    input signed [16:0]         data_in_i,
    
    output reg                  valid_o,         
    output reg [1:0]            state,
    output reg signed [16:0]    data_out_r,
    output reg signed [16:0]    data_out_i
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
                if(count == 1) begin
                    next_state = FIRST;
                    // After 1 cycles, we are going to output g
                    next_valid_o = 1;
                end
            end
            FIRST: begin
                next_count = count + 1;
                if(count == 2) begin
                    // After 2 cycles, we are going to output h
                    next_state = SECOND;
                end
            end
            SECOND: begin
                next_count = count + 1;
                if(count == 3) begin
                    // After 3 cycles, all data have been outputed
                    if(valid_i) begin
                        next_state = FIRST;
                        next_count = 2;
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