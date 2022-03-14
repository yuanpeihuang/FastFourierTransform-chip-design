`timescale 1ns/10ps
`define CYCLE    10           	         // Modify your clock period here

`include "STAGE1.v"             

// simulation commmand: ncverilog stage1_tb.v +access+r

module STAGE1_tb;
    
    integer i, j, f;
    reg clk, rst_n, valid, stop;
    reg [29:0] before_ff [0:31];
    reg [14:0] data_in_r, data_in_i;
    wire [15:0] data_out_i, data_out_r;
    wire finish;

    STAGE3 test(
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid),
        .data_in_r(data_in_r),
        .data_in_i(data_in_i),

        .valid_o(finish),
        .data_out_r(data_out_r),
        .data_out_i(data_out_i)
    );     

    initial	begin
        $readmemb ("stage2_o.txt",  before_ff);
        f = $fopen("stage3_o.txt","w");
    end

    initial begin
        clk         = 1'b1;
        rst_n         = 1'b1;  
        valid       = 1'b0;
        stop        = 1'b0;
        i           = 0;
        j           = 0;
        #2.5 rst_n=1'b0;         
        #2.5 rst_n=1'b1;

    end

    always begin #(`CYCLE/2) clk = ~clk; end

    initial begin
        $dumpfile("stage3");
        $dumpvars;
    end

    always @(negedge clk)begin
        if(i < 32) begin
            valid = 1; 
            data_in_r = before_ff[i][29:15];
            data_in_i = before_ff[i][14:0];
            i = i+1;      
        end
        else if(i < 42) begin
            data_in_r = 0;
            i = i+1;
        end
        else begin
            data_in_r = 0;
            stop = 1;
        end
    end

    always @(negedge clk)begin
        if(finish) begin
            $fwrite(f,"%b_%b\n", data_out_r, data_out_i);
            $display("Output %0d: Real->%b / Img->%b", j , data_out_r, data_out_i);
            j = j + 1;
        end

    end

    always @(posedge stop)begin
        $fclose(f);
        $finish;
    end

    // always @(posedge clk)begin
        
    //     if(dataout !== out_temp && out_temp!==16'h0000) begin
    //         $display("ERROR at %d:output %h !=expect %h ",pattern_num-2, dataout, out_temp);
    // 	    $fdisplay(out_f,"ERROR at %d:output %h !=expect %h ",pattern_num-2, dataout, out_temp);
    //         err = err + 1 ;
    //     end
    //     pattern_num = pattern_num + 1; 
    //     if(pattern_num === OUT_LENGTH)  over = 1'b1;
    // end

    // initial begin
    //       @(posedge stop)      
    //       if(over) begin
    //          $display("---------------------------------------------\n");
    //          if (err == 0)  begin
    //             $display("All data have been generated successfully!\n");
    // 			$display("You will get 80 score in this RTL!\n");
    //             $display("-------------------PASS-------------------\n");
    //          end
    //          else begin
    //             $display("There are %d errors!\n", err);
    // 			$display("You will get %d score in this RTL!\n", 80-err);
    // 		 end
    //             $display("---------------------------------------------\n");
    //       end
    //       else begin
    //         $display("---------------------------------------------\n");
    //         $display("Error!!! There is no any data output ...!\n");
    //         $display("-------------------FAIL-------------------\n");
    //         $display("---------------------------------------------\n");
    //       end
    //       $finish;
    // end
   
endmodule









