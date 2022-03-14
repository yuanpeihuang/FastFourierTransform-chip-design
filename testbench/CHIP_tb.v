`timescale 1ns/10ps
`define CYCLE    10           	         // Modify your clock period here
`define TIME_OUT 1500            

`ifdef RTL
    `include "FFT.v"
`endif

`ifdef SYN
    `include "FFT_syn.v"
    // `include "tsmc13.v"
    `define SDF
    `define SDFFILE "FFT_syn.sdf"
`endif

`ifdef APR
    `include "CHIP.v"
    `define SDF
    `define SDFFILE  "CHIP.sdf"	// sdf file
`endif

// simulation (you can adjust the T to change the test data)
// RTL: ncverilog CHIP_tb.v +define+RTL+T1 +access+r
// SYN: ncverilog CHIP_tb.v +define+SYN+T1 fsa0m_a_generic_core_21.lib.src +access+r
// APR: ncverilog CHIP_tb.v +define+APR+T1  -v fsa0m_a_generic_core_21.lib.src fsa0m_a_t33_generic_io_21.lib.src



module CHIP_tb;
    
    integer i, j, f, err;
    reg clk, rst_n, valid, stop;
    reg [10:0] before_ff [0:31];
    reg [16:0] after_ff [0:63];
    reg [10:0] data_in_r;
    wire [16:0] data_out;
    wire finish;

    FFT chip0(
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid),
        .x_r(data_in_r),
    
        .finish(finish),
        .answer(data_out)
    );   

    `ifdef SDF
        initial $sdf_annotate(`SDFFILE, chip0);
    `endif
    
    `ifdef T1
        initial	begin
            $readmemb ("input_1.txt",  before_ff);
            $readmemb ("golden_1.txt",  after_ff);
        end
    `endif

    `ifdef T2
        initial	begin
            $readmemb ("input_2.txt",  before_ff);
            $readmemb ("golden_2.txt",  after_ff);
        end
    `endif

    `ifdef T3
        initial	begin
            $readmemb ("input_3.txt",  before_ff);
            $readmemb ("golden_3.txt",  after_ff);
        end
    `endif

    `ifdef T4
        initial	begin
            $readmemb ("input_4.txt",  before_ff);
            $readmemb ("golden_4.txt",  after_ff);
        end
    `endif

    `ifdef T5
        initial	begin
            $readmemb ("input_5.txt",  before_ff);
            $readmemb ("golden_5.txt",  after_ff);
        end
    `endif

    `ifdef T6
        initial	begin
            $readmemb ("input_6.txt",  before_ff);
            $readmemb ("golden_6.txt",  after_ff);
        end
    `endif

    `ifdef T7
        initial	begin
            $readmemb ("input_7.txt",  before_ff);
            $readmemb ("golden_7.txt",  after_ff);
        end
    `endif

    `ifdef T8
        initial	begin
            $readmemb ("input_8.txt",  before_ff);
            $readmemb ("golden_8.txt",  after_ff);
        end
    `endif


    `ifdef T9
        initial	begin
            $readmemb ("input_9.txt",  before_ff);
            $readmemb ("golden_9.txt",  after_ff);
        end
    `endif

    `ifdef T10
        initial	begin
            $readmemb ("input_10.txt",  before_ff);
            $readmemb ("golden_10.txt",  after_ff);
        end
    `endif

    initial begin
        f = $fopen("fft_o.txt","w");
        clk         = 1'b1;
        rst_n         = 1'b1;  
        valid       = 1'b0;
        stop        = 1'b0;
        i           = 0;
        j           = 0;
        err         = 0;
        #2.5 rst_n=1'b0;         
        #2.5 rst_n=1'b1;

    end

    always begin #(`CYCLE/2) clk = ~clk; end

    initial begin
        $fsdbDumpfile("CHIP.fsdb");
        $fsdbDumpvars(0, CHIP_tb, "+mda");
    end

    initial begin
        $dumpfile("CHIP.vcd");
        $dumpvars();
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
            // $display("Output %0d: %b ", j , data_out);
            
            // allow some error in last bit
            if((after_ff[j] != data_out)) begin
                if(j < 32)
                    $display("There is an error at NO.%d Real part; expected: %b / golden: %b" , j, data_out, after_ff[j]);
                else
                    $display("There is an error at NO.%d Imag part; expected: %b / golden: %b" , j-32, data_out, after_ff[j]);
                err = err + 1;
            end
            j = j + 1;
        end
        if(j > 63) begin
            if(!err) begin
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
            end
            else begin
                $display("AAAAA, There are total %d errors in your design", err);
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
            end

            $fclose(f);
            $finish;
        end
    end
   
endmodule