// ===================================================================
// Module: FFT (top)

// This is the 32-point FFT circuits
// This module uses signed fixed point representation
// input: 8-bit(integer part: 5-bit/ fractional part: 3-bit) 
// output: 18-bit(integer part: 10-bit/ fractional part: 8-bit)  

// pipelined design: all inputs and outputs are tramsmitted one by one
// ===================================================================

`include "STAGE1.v"
`include "STAGE2.v"
`include "STAGE3.v"
`include "STAGE4.v"
`include "STAGE5.v"
`include "sorting_modified.v"

/*
input  : 5  + 6 bit 
output : 11 + 6 bit
*/

module FFT(
    input                   clk,
    input                   rst_n,
    input                   valid_i,
    input signed [10:0]      x_r,
    
    output                  finish,
    output signed [16:0]    answer
);
    wire [0:3] valid_o_bus;
    wire [13:0] data_r_bus_1, data_i_bus_1;
    wire [14:0] data_r_bus_2, data_i_bus_2;
    wire [15:0] data_r_bus_3, data_i_bus_3;
    wire [16:0] data_r_bus_4, data_i_bus_4;
    wire [16:0] X_r, X_i;
    wire         done;
    // wire [13:0] data_r_bus_1, data_i_bus_1;

    STAGE1 stg1(
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid_i),
        .data_in_r(x_r),
        .data_in_i(11'd0),

        .valid_o(valid_o_bus[0]),
        .data_out_r(data_r_bus_1),
        .data_out_i(data_i_bus_1)
    );

    STAGE2 stg2(
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid_o_bus[0]),
        .data_in_r(data_r_bus_1),
        .data_in_i(data_i_bus_1),

        .valid_o(valid_o_bus[1]),
        .data_out_r(data_r_bus_2),
        .data_out_i(data_i_bus_2)
    );

    STAGE3 stg3(
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid_o_bus[1]),
        .data_in_r(data_r_bus_2),
        .data_in_i(data_i_bus_2),

        .valid_o(valid_o_bus[2]),
        .data_out_r(data_r_bus_3),
        .data_out_i(data_i_bus_3)
    );


    STAGE4 stg4(
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid_o_bus[2]),
        .data_in_r(data_r_bus_3),
        .data_in_i(data_i_bus_3),

        .valid_o(valid_o_bus[3]),
        .data_out_r(data_r_bus_4),
        .data_out_i(data_i_bus_4)
    );

    STAGE5 stg5(
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid_o_bus[3]),
        .data_in_r(data_r_bus_4),
        .data_in_i(data_i_bus_4),

        .valid_o(done),
        .data_out_r(X_r),
        .data_out_i(X_i)
    );
    SORTING sort(
        .clk(clk),
        .rst_n(rst_n),
        .start_sorting(done),
        .out_r(X_r),
        .out_i(X_i),
        .answer(answer),
        .seq(finish)
);



endmodule