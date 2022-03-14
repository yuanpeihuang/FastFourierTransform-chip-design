// ===================================================================
// Module: STAGE3

// Combine CTRL4, radix2, SR4

// ===================================================================
`include "CTRL4.v"
`include "SR4.v"
`include "BUTTERFLY_R2_3.v"

module STAGE3(
    input                   clk,
    input                   rst_n,
    input                   valid_i,
    input signed [14:0]     data_in_r,
    input signed [14:0]     data_in_i,

    output                  valid_o,
    output signed [15:0]    data_out_r,
    output signed [15:0]    data_out_i
);
    // Wire Reg declaration
    reg  [14:0] data_in_r_r, data_in_i_r;
    reg  valid_i_r;
    
    wire [1:0] state_bus;
    wire [7:0] WN_r_bus, WN_i_bus;
    wire [15:0] SR_r_bus, SR_i_bus;
    wire [15:0] FB_r_bus, FB_i_bus;
    wire [14:0] data_r_bus, data_i_bus;
    
    CTRL4 Control_unit(
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid_i_r),
        .data_in_r(data_in_r_r),
        .data_in_i(data_in_i_r),

        .valid_o(valid_o),
        .state(state_bus),
        .data_out_r(data_r_bus),
        .data_out_i(data_i_bus),
        .WN_r(WN_r_bus),
        .WN_i(WN_i_bus)
    );
    
    SR4 shiftregister(
        .clk(clk),
        .rst_n(rst_n),
        .in_r(SR_r_bus),
        .in_i(SR_i_bus),
        
        .out_r(FB_r_bus),
        .out_i(FB_i_bus)
    );

    BUTTERFLY_R2_3 butterfly(
        .state(state_bus),
        .A_r(data_r_bus),
        .A_i(data_i_bus),
        .B_r(FB_r_bus),
        .B_i(FB_i_bus),
        .WN_r(WN_r_bus),
        .WN_i(WN_i_bus),
        
        .out_r(data_out_r),
        .out_i(data_out_i),
        .SR_r(SR_r_bus),
        .SR_i(SR_i_bus)
    );

    // Make sure that all inputs sending into sub-modules are flipfloped.
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_in_r_r <= 0;
            data_in_i_r <= 0;
            valid_i_r <= 0;
        end
        else begin
            data_in_r_r <= data_in_r;
            data_in_i_r <= data_in_i;
            valid_i_r <= valid_i;
        end
    end

endmodule