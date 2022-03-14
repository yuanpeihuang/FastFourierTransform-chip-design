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

integer               i, j, next_j;
input                 clk, rst_n, start_sorting;                  
reg                   sort, next_sort, finish, n_seq;
reg            [4:0]  count, next_count;
input  signed  [16:0] out_r;
input  signed  [16:0] out_i;
output reg signed  [16:0] answer;
output reg            seq;
reg    signed  [16:0] result[0:63];
reg    signed  [16:0] prev_out_r;
reg    signed  [16:0] prev_out_i;
reg    signed  [16:0] next_result_r[0:31];
reg    signed  [16:0] next_result_i[0:31];



always@(*) begin
    next_sort = sort;
    n_seq = seq;
    if(seq) begin
        next_j = j;
    end
    if(next_sort) begin
        next_count = count;
        case(next_count)
            5'd0 : begin
                next_result_r[0] = prev_out_r;
                next_result_i[0] = prev_out_i;
            end
            5'd1 : begin
                next_result_r[16] = prev_out_r;
                next_result_i[16] = prev_out_i;
            end
            5'd2 : begin
                next_result_r[8] = prev_out_r;
                next_result_i[8] = prev_out_i;
            end
            5'd3 : begin
                next_result_r[24] = prev_out_r;
                next_result_i[24] = prev_out_i;
            end
            5'd4 : begin
                next_result_r[4] = prev_out_r;
                next_result_i[4] = prev_out_i;
            end
            5'd5 : begin
                next_result_r[20] = prev_out_r;
                next_result_i[20] = prev_out_i;
            end
            5'd6 : begin
                next_result_r[12] = prev_out_r;
                next_result_i[12] = prev_out_i;
            end
            5'd7 : begin
                next_result_r[28] = prev_out_r;
                next_result_i[28] = prev_out_i;
            end
            5'd8 : begin
                next_result_r[2] = prev_out_r;
                next_result_i[2] = prev_out_i;
            end
            5'd9 : begin
                next_result_r[18] = prev_out_r;
                next_result_i[18] = prev_out_i;
            end
            5'd10 : begin
                next_result_r[10] = prev_out_r;
                next_result_i[10] = prev_out_i;
            end
            5'd11 : begin
                next_result_r[26] = prev_out_r;
                next_result_i[26] = prev_out_i;
            end
            5'd12 : begin
                next_result_r[6] = prev_out_r;
                next_result_i[6] = prev_out_i;
            end
            5'd13 : begin
                next_result_r[22] = prev_out_r;
                next_result_i[22] = prev_out_i;
            end
            5'd14 : begin
                next_result_r[14] = prev_out_r;
                next_result_i[14] = prev_out_i;
            end
            5'd15 : begin
                next_result_r[30] = prev_out_r;
                next_result_i[30] = prev_out_i;
            end
            5'd16 : begin
                next_result_r[1] = prev_out_r;
                next_result_i[1] = prev_out_i;
            end
            5'd17 : begin
                next_result_r[17] = prev_out_r;
                next_result_i[17] = prev_out_i;
            end
            5'd18 : begin
                next_result_r[9] = prev_out_r;
                next_result_i[9] = prev_out_i;
            end
            5'd19 : begin
                next_result_r[25] = prev_out_r;
                next_result_i[25] = prev_out_i;
            end
            5'd20 : begin
                next_result_r[5] = prev_out_r;
                next_result_i[5] = prev_out_i;
            end
            5'd21 : begin
                next_result_r[21] = prev_out_r;
                next_result_i[21] = prev_out_i;
            end
            5'd22 : begin
                next_result_r[13] = prev_out_r;
                next_result_i[13] = prev_out_i;
            end
            5'd23 : begin
                next_result_r[29] = prev_out_r;
                next_result_i[29] = prev_out_i;
            end
            5'd24 : begin
                next_result_r[3] = prev_out_r;
                next_result_i[3] = prev_out_i;
            end
            5'd25 : begin
                next_result_r[19] = prev_out_r;
                next_result_i[19] = prev_out_i;
            end
            5'd26 : begin
                next_result_r[11] = prev_out_r;
                next_result_i[11] = prev_out_i;
            end
            5'd27 : begin
                next_result_r[27] = prev_out_r;
                next_result_i[27] = prev_out_i;
            end
            5'd28 : begin
                next_result_r[7] = prev_out_r;
                next_result_i[7] = prev_out_i;
            end
            5'd29 : begin
                next_result_r[23] = prev_out_r;
                next_result_i[23] = prev_out_i;
            end
            5'd30 : begin
                next_result_r[15] = prev_out_r;
                next_result_i[15] = prev_out_i;
            end
            5'd31 : begin
                next_result_r[31] = prev_out_r;
                next_result_i[31] = prev_out_i;
                next_sort = 0;
                n_seq = 1'b1;
            end
        endcase
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        prev_out_r <= 0;
        prev_out_i <= 0;
        for (i = 0; i < 31; i = i+1) begin
            result[i] <= 0;
        end
        sort <= 0;
        j <= 0;
        answer <= 0;
        count <= 0;
        seq <= 0;
    end
    else begin
        prev_out_r <= out_r;
        prev_out_i <= out_i;
        seq <= n_seq;
        for (i = 0; i < 32; i = i+1) begin
            result[i] <= next_result_r[i];
            result[i+32] <= next_result_i[i];
        end
        sort <= next_sort;
        if(n_seq) begin
            answer <= result[j];
            j <= next_j + 1;
        end
        if(start_sorting)count <= next_count + 1;
    end
end
// always@(posedge clk) begin
//     if(seq)begin
//         if (j < 32) begin
//         answer = result_r[j];
//         end
//         else if(j < 64) begin
//         answer = result_i[j - 32];
//         end
//         j = j + 1;
//     end
//     if(j == 64)begin
//         finish = 1'b1;
//     end
// end
endmodule