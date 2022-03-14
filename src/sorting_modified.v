module SORTING(
    clk,
    rst_n,
    start_sorting,
    out_r,
    out_i,
    answer,
    seq
);
/*
*****************************
*    [0] output ->  [0]    *
*    [1] output ->  [16]    *
*    [2] output ->  [8]     *
*    [3] output ->  [24]    *                                              
*    [4] output ->  [4]     *
*    [5] output ->  [20]    *
*    [6] output ->  [12]    *
*    [7] output ->  [28]    *
*    [8] output ->  [2]     *
*    [9] output ->  [18]    *
*    [10] output ->  [10]    *
*    [11] output ->  [26]   *
*    [12] output ->  [6]    *
*    [13] output ->  [22]   *                                              
*    [14] output ->  [14]   *
*    [15] output ->  [30]   *
*    [16] output ->  [1]    *
*    [17] output ->  [17]   *
*    [18] output ->  [9]    *
*    [19] output ->  [25]   *
*    [20] output ->  [5]    *
*    [21] output ->  [21]   *
*    [22] output ->  [13]   *
*    [23] output ->  [29]   *                                              
*    [24] output ->  [3]    *
*    [25] output ->  [19]   *
*    [26] output ->  [11]   *
*    [27] output ->  [27]   *
*    [28] output ->  [7]    *
*    [29] output ->  [23]   *
*    [30] output ->  [15]   *
*    [31] output ->  [31]   *
*****************************
*/

input                 clk, rst_n, start_sorting;
input  [16:0]         out_r;
input  [16:0]         out_i;
output [16:0]         answer;
output reg            seq;

// Wire & Reg declaration
integer i, j;

// flipflop - count & finish
reg [8:0] count, next_count;
reg next_finish;
reg [16:0] answer_moved;
reg start, next_start;

// flipflop - result
reg [16:0] result[0:63];
reg [16:0] next_result_r[0:31];
reg [16:0] next_result_i[0:31];


// Combinational part

assign answer = answer_moved;

always@(*) begin
    // default
    next_count = count;
    next_finish = seq;
    next_start = start;

    // Logic
    if(start_sorting || start) begin
        next_count = count + 1; 
        next_start = 1;
    end

    case(count)
        32: answer_moved = result[0];
        33: answer_moved = result[1];
        34: answer_moved = result[2];
        35: answer_moved = result[3];
        36: answer_moved = result[4];
        37: answer_moved = result[5];
        38: answer_moved = result[6];
        39: answer_moved = result[7];
        40: answer_moved = result[8];
        41: answer_moved = result[9];
        42: answer_moved = result[10];
        43: answer_moved = result[11];
        44: answer_moved = result[12];
        45: answer_moved = result[13];
        46: answer_moved = result[14];
        47: answer_moved = result[15];
        48: answer_moved = result[16];
        49: answer_moved = result[17];
        50: answer_moved = result[18];
        51: answer_moved = result[19];
        52: answer_moved = result[20];
        53: answer_moved = result[21];
        54: answer_moved = result[22];
        55: answer_moved = result[23];
        56: answer_moved = result[24];
        57: answer_moved = result[25];
        58: answer_moved = result[26];
        59: answer_moved = result[27];
        60: answer_moved = result[28];
        61: answer_moved = result[29];
        62: answer_moved = result[30];
        63: answer_moved = result[31];
        64: answer_moved = result[32];
        65: answer_moved = result[33];
        66: answer_moved = result[34];
        67: answer_moved = result[35];
        68: answer_moved = result[36];
        69: answer_moved = result[37];
        70: answer_moved = result[38];
        71: answer_moved = result[39];
        72: answer_moved = result[40];
        73: answer_moved = result[41];
        74: answer_moved = result[42];
        75: answer_moved = result[43];
        76: answer_moved = result[44];
        77: answer_moved = result[45];
        78: answer_moved = result[46];
        79: answer_moved = result[47];
        80: answer_moved = result[48];
        81: answer_moved = result[49];
        82: answer_moved = result[50];
        83: answer_moved = result[51];
        84: answer_moved = result[52];
        85: answer_moved = result[53];
        86: answer_moved = result[54];
        87: answer_moved = result[55];
        88: answer_moved = result[56];
        89: answer_moved = result[57];
        90: answer_moved = result[58];
        91: answer_moved = result[59];
        92: answer_moved = result[60];
        93: answer_moved = result[61];
        94: answer_moved = result[62];
        95: answer_moved = result[63];
        default: begin
            answer_moved = 0;
        end    
    endcase

    if(count == 31) next_finish = 1;
    if(count == 95) begin
        next_finish = 0;
        next_start = 0;
        next_count = 0;
    end
end

// result logic
always@(*) begin
    for (i = 0; i < 32; i = i+1) begin
        next_result_r[i] = result[i];
        next_result_i[i] = result[i+32];
    end
    case(count)
        0 : begin
            if(start_sorting) begin
                next_result_r[0] = out_r;
                next_result_i[0] = out_i;
            end
        end
        1 : begin
            next_result_r[16] = out_r;
            next_result_i[16] = out_i;
        end
        2 : begin
            next_result_r[8] = out_r;
            next_result_i[8] = out_i;
        end
        3 : begin
            next_result_r[24] = out_r;
            next_result_i[24] = out_i;
        end
        4 : begin
            next_result_r[4] = out_r;
            next_result_i[4] = out_i;
        end
        5 : begin
            next_result_r[20] = out_r;
            next_result_i[20] = out_i;
        end
        6 : begin
            next_result_r[12] = out_r;
            next_result_i[12] = out_i;
        end
        7 : begin
            next_result_r[28] = out_r;
            next_result_i[28] = out_i;
        end
        8 : begin
            next_result_r[2] = out_r;
            next_result_i[2] = out_i;
        end
        9 : begin
            next_result_r[18] = out_r;
            next_result_i[18] = out_i;
        end
        10 : begin
            next_result_r[10] = out_r;
            next_result_i[10] = out_i;
        end
        11 : begin
            next_result_r[26] = out_r;
            next_result_i[26] = out_i;
        end
        12 : begin
            next_result_r[6] = out_r;
            next_result_i[6] = out_i;
        end
        13 : begin
            next_result_r[22] = out_r;
            next_result_i[22] = out_i;
        end
        14 : begin
            next_result_r[14] = out_r;
            next_result_i[14] = out_i;
        end
        15 : begin
            next_result_r[30] = out_r;
            next_result_i[30] = out_i;
        end
        16 : begin
            next_result_r[1] = out_r;
            next_result_i[1] = out_i;
        end
        17 : begin
            next_result_r[17] = out_r;
            next_result_i[17] = out_i;
        end
        18 : begin
            next_result_r[9] = out_r;
            next_result_i[9] = out_i;
        end
        19 : begin
            next_result_r[25] = out_r;
            next_result_i[25] = out_i;
        end
        20 : begin
            next_result_r[5] = out_r;
            next_result_i[5] = out_i;
        end
        21 : begin
            next_result_r[21] = out_r;
            next_result_i[21] = out_i;
        end
        22 : begin
            next_result_r[13] = out_r;
            next_result_i[13] = out_i;
        end
        23 : begin
            next_result_r[29] = out_r;
            next_result_i[29] = out_i;
        end
        24 : begin
            next_result_r[3] = out_r;
            next_result_i[3] = out_i;
        end
        25 : begin
            next_result_r[19] = out_r;
            next_result_i[19] = out_i;
        end
        26 : begin
            next_result_r[11] = out_r;
            next_result_i[11] = out_i;
        end
        27 : begin
            next_result_r[27] = out_r;
            next_result_i[27] = out_i;
        end
        28 : begin
            next_result_r[7] = out_r;
            next_result_i[7] = out_i;
        end
        29 : begin
            next_result_r[23] = out_r;
            next_result_i[23] = out_i;
        end
        30 : begin
            next_result_r[15] = out_r;
            next_result_i[15] = out_i;
        end
        31 : begin
            next_result_r[31] = out_r;
            next_result_i[31] = out_i;
        end
        default: begin
            for (i = 0; i < 32; i = i+1) begin
                next_result_r[i] = result[i];
                next_result_i[i] = result[i+32];
            end
        end
    endcase
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        count <= 0;
        seq <= 0;
        start <= 0;
        for (i = 0; i < 32; i = i+1) begin
            result[i] <= 0;
            result[i+32] <= 0;
        end
    end
    else begin
        count <= next_count;
        seq <= next_finish;
        start <= next_start;
        for (i = 0; i < 32; i = i+1) begin
            result[i] <= next_result_r[i];
            result[i+32] <= next_result_i[i];
        end
    end
end

endmodule