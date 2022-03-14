`timescale 1ns/10ps
`define CYCLE    10           	         // Modify your clock period here

`define b_ff  "./before_ff.dat"       
`define g_r   "./golden_r.dat"      
`define g_i   "./golden_i.dat"          

module FFT;

parameter DATA_LENGTH   = 32;

reg   clk;
reg   reset;
reg   finish;
reg   valid;    
reg   err;    


reg   [18:0]  after_ff_r [0:DATA_LENGTH-1];
reg   [18:0]  after_ff_i [0:DATA_LENGTH-1];
reg   [13:0]  before_ff  [0:DATA_LENGTH-1];
reg   [18:0]  golden_r   [0:DATA_LENGTH-1];
reg   [18:0]  golden_i   [0:DATA_LENGTH-1];

   FFT FFT_0( .clk_p_i(clk), .reset_n_i(reset), .data_i(before_ff), .data_o_r(after_ff_r), .data_o_i(after_ff_i), .finish(finish), .valid(valid));          

initial	$readmemh (`b_ff,  before_ff);
initial	$readmemh (`g_r,   golden_r);
initial	$readmemh (`g_i,   golden_i);

initial begin
   clk         = 1'b1;
   reset       = 1'b1;
   finish        = 1'b0;  
   valid        = 1'b0;
   err         = 0;  
#2.5 reset=1'b0;                            // system reset
#2.5 reset=1'b1;

end

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	$dumpfile("fft.fsdb");
	$dumpvars;

   out_f = $fopen("out.dat");
   if (out_f == 0) begin
        $display("Output file open error !");
        $finish;
   end
end


always @(negedge clk)begin
    if (i < OUT_LENGTH) begin
		 if(i < DATA_LENGTH)begin
          cmd      = cmd_mem[i];
          datain1  = image1_mem[i];
	       datain2  = image2_mem[i];
	    end
		 out_temp = out_mem[i];
	    i = i+1;      
    end
    else                                       
       stop = 1 ;      
end

always @(posedge clk)begin
    
    if(dataout !== out_temp && out_temp!==16'h0000) begin
        $display("ERROR at %d:output %h !=expect %h ",pattern_num-2, dataout, out_temp);
	    $fdisplay(out_f,"ERROR at %d:output %h !=expect %h ",pattern_num-2, dataout, out_temp);
        err = err + 1 ;
    end
    pattern_num = pattern_num + 1; 
    if(pattern_num === OUT_LENGTH)  over = 1'b1;
end

initial begin
      @(posedge stop)      
      if(over) begin
         $display("---------------------------------------------\n");
         if (err == 0)  begin
            $display("All data have been generated successfully!\n");
			$display("You will get 80 score in this RTL!\n");
            $display("-------------------PASS-------------------\n");
         end
         else begin
            $display("There are %d errors!\n", err);
			$display("You will get %d score in this RTL!\n", 80-err);
		 end
            $display("---------------------------------------------\n");
      end
      else begin
        $display("---------------------------------------------\n");
        $display("Error!!! There is no any data output ...!\n");
        $display("-------------------FAIL-------------------\n");
        $display("---------------------------------------------\n");
      end
      $finish;
end
   
endmodule









