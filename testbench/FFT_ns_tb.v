`timescale 1ns/10ps
`define CYCLE    10           	         // Modify your clock period here
`define TIME_OUT 1500

`include "FFT.v"             

// simulation commmand: ncverilog FFT_ns_tb.v +access+r

module FFT_ns_tb;
    
    integer i, j, f;
    reg clk, rst_n, valid, stop;
    reg [10:0] before_ff [0:31];
    reg [10:0] data_in_r;
    wire [16:0] data_out;
    wire finish;

    FFT fft(
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid),
        .x_r(data_in_r),
    
        .finish(finish),
        .answer(data_out)
    );   

    initial	begin
        $readmemb ("input_11bit_1.txt",  before_ff);
        f = $fopen("fft_ns_o.txt","w");
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
        $fsdbDumpfile("FFT_ns.fsdb");
        $fsdbDumpvars(0, FFT_ns_tb, "+mda");
    end

    initial #(`TIME_OUT) begin
        $display("Time_out! AAAAAA");
        $display("⠄⠄⠄⠄⠄⠄⠄⠈⠉⠁⠈⠉⠉⠙⠿⣿⣿⣿⣿⣿");
        $display("⠄⠄⠄⠄⠄⠄⠄⠄⣀⣀⣀⠄⠄⠄⠄⠄⠹⣿⣿⣿");
        $display("⠄⠄⠄⠄⠄⢐⣲⣿⣿⣯⠭⠉⠙⠲⣄⡀⠄⠈⢿⣿");
        $display("⠐⠄⠄⠰⠒⠚⢩⣉⠼⡟⠙⠛⠿⡟⣤⡳⡀⠄⠄⢻");
        $display("⠄⠄⢀⣀⣀⣢⣶⣿⣦⣭⣤⣭⣵⣶⣿⣿⣏⠄⠄⣿");
        $display("⠄⣼⣿⣿⣿⡉⣿⣀⣽⣸⣿⣿⣿⣿⣿⣿⣿⡆⣀⣿");
        $display("⢠⣿⣿⣿⠿⠟⠛⠻⢿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣼");
        $display("⠄⣿⣿⣿⡆⠄⠄⠄⠄⠳⡈⣿⣿⣿⣿⣿⣿⣿⣿⣿");
        $display("⠄⢹⣿⣿⡇⠄⠄⠄⠄⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿");
        $display("⠄⠄⢿⣿⣷⣨⣽⣭⢁⣡⣿⣿⠟⣩⣿⣿⣿⠿⠿⠟");
        $display("⠄⠄⠈⡍⠻⣿⣿⣿⣿⠟⠋⢁⣼⠿⠋⠉⠄⠄⠄⠄");
        $display("⠄⠄⠄⠈⠴⢬⣙⣛⡥⠴⠂⠄⠄⠄⠄⠄⠄⠄⠄.");
        $finish;
    end

    always @(negedge clk)begin
        if(i < 32) begin
            valid = 1; 
            data_in_r = before_ff[i];
            i = i+1;      
        end
        else begin
            data_in_r = 0;
            valid = 0;
        end
    end

    always @(posedge clk) begin
        if(finish) begin
            $fwrite(f,"%b\n", data_out);
            $display("Output %0d: %b ", j , data_out);
            j = j + 1;
        end
        if(j > 63) begin
            $fclose(f);
            $display("Finishing Fast fourier transform!");
            $display("⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠉⠱⠀⠀⠀⠀⠀⠀");
            $display("⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠁⠀⢀⠁⠀⠀⠀⠀⠀⠀");
            $display("⠀⠀⠀⠀⠀⠀⠀⠀⠰⠂⠰⠄⢸⠀⠀⠀⠀⠀⠀⠀");
            $display("⡄⠄⡀⠀⠀⠀⢀⠊⣈⢊⠁⡄⢸⠀⠀⠀⠀⠀⢀⢀");
            $display("⢁⠀⠈⠢⡀⠀⢘⢀⡹⡈⡠⠁⠈⠀⠀⠀⠔⠈⠀⡘");
            $display("⠀⢂⠀⠀⠀⢑⠌⢢⣤⣴⣶⡏⠀⡢⠊⠀⠀⠀⠐⠀");
            $display("⠀⠀⠢⠀⢀⠊⠠⣟⣉⡩⠉⠀⠈⠀⠀⠀⢁⠊⠀⠀");
            $display("⠀⠀⠀⠱⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡐⠁⠀⠀⠀");
            $display("⠀⠀⢠⡁⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢁⠀⠀⠀⠀");
            $display("⠀⠀⢸⣷⣄⡀⢂⠀⠀⠀⠀⠀⠀⣀⣤⣾⠀⠀⠀⠀");
            $display("⠀⠀⠀⢿⣿⣿⣷⣶⣶⣶⣶⣶⣿⣿⣿⡏⠀⠀⠀");⠀
            $display("⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀");
            $display("⠀⠀⠀⠈⡟⠛⢿⠋⠉⠹⠿⣿⡿⠿⠂⠀⠀⠀⠀");⠀
            $display("⠀⠀⠀⠀⠐⠀⠂⠀⠀⠀⠐⢄⡀⠂⠀⠀⠀⠀⠀⠀");
            $finish;
        end
    end
   
endmodule