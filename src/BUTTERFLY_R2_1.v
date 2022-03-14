// ====================================================================
// Module: BUTTERFLY_R2_1                                                 
// 
// This is Butterfly-unit for doing radix2-FFT. where B is connected
// to the output of the shift-register (single path delay) and that A 
// is connected to the data input. 
// 
// Note: Only contain the combinational part, so the next stage should
// add the flipflop to its input to ensure the existence of full 
// access time
// 
// A             : 5-bit  integer, 6-bit fractional
// B, SR         : 6-bit  integer, 6-bit fractional (extension)
// WN            : 2-bit  integer, 6-bit fractional
// out           : 7-bit  integer, 7-bit fractional 
// ===================================================================
module BUTTERFLY_R2_1(
    input [1:0]                 state,
    input signed [10:0]          A_r,
    input signed [10:0]          A_i,
    input signed [11:0]          B_r,
    input signed [11:0]          B_i,
    input signed [7:0]          WN_r,
    input signed [7:0]          WN_i,
    
    output reg signed [13:0]    out_r,
    output reg signed [13:0]    out_i,
    output reg signed [11:0]     SR_r,
    output reg signed [11:0]     SR_i
);
    // state parameter
    parameter IDLE      = 2'b00;
    parameter FIRST     = 2'b01;
    parameter SECOND    = 2'b10;
    parameter WAITING   = 2'b11;
    
    // Wire-Reg declaration
    wire signed [19:0] mul13, mul24, mul14, mul23;
    wire signed [20:0] tempA, tempB;
    wire signed [11:0] A_ext_r, A_ext_i;
    wire signed [12:0] ApB_r, ApB_i;
    wire signed [12:0] AmB_r, AmB_i;

    // Combinational part
    assign A_ext_r = {A_r[10], A_r};
    assign A_ext_i = {A_i[10], A_i};
    assign ApB_r = A_ext_r + B_r;
    assign ApB_i = A_ext_i + B_i;
    assign AmB_r = B_r - A_ext_r;
    assign AmB_i = B_i - A_ext_i;
    
    assign mul13 = B_r * WN_r;
    assign mul24 = B_i * WN_i;
    assign mul14 = B_r * WN_i;
    assign mul23 = B_i * WN_r;
    
    assign tempA = mul13 - mul24;
    assign tempB = mul14 + mul23;
    
    always@(*) begin
        case(state)          
            IDLE: begin
                out_r = 0;
                out_i = 0;
                SR_r = 0;
                SR_i = 0;
            end

            // In waiting state, we directly let A delay for N/2 cycle.
            WAITING: begin
                out_r = 0;
                out_i = 0;
                SR_r = A_ext_r;
                SR_i = A_ext_i;
            end
            
            // In first state, add the delayed-data with input data and output it (g)
            // Also, subtract the delayed-data from input data and 
            // let it delay for N/2 cycle (send it to shift register)
            FIRST: begin
                out_r = {ApB_r[12:0], 1'b0};
                out_i = {ApB_i[12:0], 1'b0};
                SR_r = AmB_r[11:0]; // B:from delay, A: from input
                SR_i = AmB_i[11:0];
            end

            // In second state, multiply delayed-data (h1~hN) with corresponding W (
            // W^0~W^(N-1)/2 and output it
            SECOND: begin
                out_r = {tempA[18:5]};
                out_i = {tempB[18:5]};
                SR_r = A_ext_r;
                SR_i = A_ext_i;
            end
            
            default: begin
                out_r = 0;
                out_i = 0;
                SR_r = 0;
                SR_i = 0;
            end

        endcase
    end

endmodule