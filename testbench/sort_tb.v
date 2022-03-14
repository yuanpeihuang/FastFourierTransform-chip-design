`timescale 1ns/10ps
`define CYCLE    10

module SORT_tb;

integer i, j, f;
    reg clk, rst, start, finish, stop;
    reg          [17:0] before [0:31];
    reg  signed  [9:0] input_r;
    reg  signed  [7:0] input_i;
    reg  signed  [9:0] gold_r[0:31];
    reg  signed  [7:0] gold_i[0:31];
    wire signed  [9:0] output_r;
    wire signed  [7:0] output_i;


    SORTING test(
    .clk(clk),
    .rst(rst),
    .start_sorting(start),
    .out_r(input_r),
    .out_i(input_i),
    .answer_r(output_r),
    .answer_i(output_i)
    );

    initial	begin
        f = $fopen("sorting_result.txt","w");
    end

    initial begin
        clk         = 1'b1;
        input_r     = 0;
        input_i     = 0;
        stop        = 1'b0;
        finish      = 1'b0;
        rst         = 1'b1;  
        start       = 1'b0;
        #2.5 rst=1'b0;         
        #2.5 rst=1'b1;
        start       = 1'b1;

    end

    always begin #(`CYCLE/2) clk = ~clk; end

    initial begin
        $dumpfile("sort.fsdb");
        $dumpvars;
    end

    always @(negedge clk)begin
        if(i < 32) begin
            start = 1; 
            input_r <= input_r + 1'b1;
            input_i <= input_i + 1'b1;
            i = i+1;      
        end
        else begin
            finish = 1'b1;
        end
        
    end

    always @(negedge clk)begin
        if(finish) begin
            $fwrite(f,"%b/%b\n", output_r, output_i);
            i = i+1; 
        end
        else if (i > 63) stop = 1'b1;

    end

    always @(posedge stop)begin
        $fclose(f);
        $finish;
    end
endmodule