// ====================================================================
// Module: BUTTERFLY_R2_5                                              
// 
// This is Butterfly-unit for doing radix2-FFT. where B is connected
// to the output of the shift-register (single path delay) and that A 
// is connected to the data input. 
// 
// Note: Only contain the combinational part, so the next stage should
// add the flipflop to its input to ensure the existence of full 
// access time
// 
// A             : 10-bit  integer, 7-bit fractional
// B, SR         : 11-bit  integer, 7-bit fractional (extension)
// WN            : (1+0j)
// out           : 11-bit  integer, 6-bit fractional 
// ===================================================================
module BUTTERFLY_R2_5(
    input [1:0]                 state,
    input signed [16:0]         A_r,
    input signed [16:0]         A_i,
    input signed [17:0]         B_r,
    input signed [17:0]         B_i,
    
    output reg signed [16:0]    out_r,
    output reg signed [16:0]    out_i,
    output reg signed [17:0]    SR_r,
    output reg signed [17:0]    SR_i
);
    // state parameter
    parameter IDLE      = 2'b00;
    parameter FIRST     = 2'b01;
    parameter SECOND    = 2'b10;
    parameter WAITING   = 2'b11;
    
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
                SR_r = {A_r[16], A_r};
                SR_i = {A_i[16], A_i};
            end
            
            // In first state, add the delayed-data with input data and output it (g)
            // Also, subtract the delayed-data from input data and 
            // let it delay for N/2 cycle (send it to shift register)
            FIRST: begin
                out_r = $signed({A_r[16], A_r}) + B_r[17:0];
                out_i = $signed({A_i[16], A_i}) + B_i[17:0];
                SR_r = B_r - $signed({A_r[16], A_r}); // B:from delay, A: from input
                SR_i = B_i - $signed({A_i[16], A_i});
            end

            // In second state, multiply delayed-data (h1~hN) with corresponding W (
            // W^0~W^(N-1)/2 and output it
            SECOND: begin
                out_r = B_r[16:0];
                out_i = B_i[16:0];
                SR_r = {A_r[16], A_r};
                SR_i = {A_i[16], A_i};
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