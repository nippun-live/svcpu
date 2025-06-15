module testbench();
timeunit 10ns;	// This is the amount of time represented by #1 
timeprecision 1ns;

	logic clk;
	logic reset;

	logic run_i;
	logic continue_i;
	logic [15:0] sw_i;

	logic [15:0] led_o;
	logic [7:0]  hex_seg_left;
	logic [3:0]  hex_grid_left;
	logic [7:0]  hex_seg_right;
	logic [3:0]  hex_grid_right;
	
	processor_top processor(.*);

	initial begin: CLOCK_INITIALIZATION
		clk = 0;//1;
	end 

	always begin : CLOCK_GENERATION
		#1 clk = ~clk;
	end
    
	initial begin: TEST_VECTORS
	   //IO TEST 1
//	   reset <= 1'b1;
//	   sw_i = 16'h0003;
//	   repeat (50) @(posedge clk);
//	   run_i = 1'b1;
//	   continue_i = 1'b0;;
//	   repeat (10) @(posedge clk);
	   
//	   reset = 1'b0;
//	   repeat (50) @(posedge clk);
	   
//	   repeat (10) @(posedge clk);
//	   run_i = 1'b0;
//	   repeat (50) @(posedge clk);
	   
//	   reset = 1'b0;
//	   repeat (8)@(posedge clk);
	   
//	   run_i = 1'b1;
//	   repeat (8) @(posedge clk);
	   
//	   run_i = 1'b0;
//	   repeat (50) @(posedge clk);
	  // IO TEST 1 END
	   
	   //IO TEST 2
//       reset <= 1'b1;
//	   sw_i = 16'h0014;
//	   repeat (50) @(posedge clk);
//	   run_i = 1'b1;
//	   continue_i = 1'b0;;
//	   repeat (10) @(posedge clk);
	   
//	   sw_i = 16'h0001;
//	   continue_i = 1'b1;
//	   reset = 1'b0;
//	   repeat (50) @(posedge clk);
	   
//	   sw_i = 16'h0000;
//	   repeat (10) @(posedge clk);
//	   run_i = 1'b0;
//	   continue_i = 1'b1;
//	   repeat (50) @(posedge clk);
//	   reset = 1'b0;
//	   repeat (8)@(posedge clk);
	   
    //IO TEST 2 END
    
    //COUNT TEST BENCH
    
       reset <= 1'b1;
       run_i = 1'b0;
	   continue_i = 1'b0;
	   repeat (20) @(posedge clk);
	   reset <= 1'b0;
	   sw_i = 16'h005a;
	   repeat (50) @(posedge clk);
	   reset = 1'b0;
	   run_i = 1'b1;
	   continue_i = 1'b0;;
	   repeat (10) @(posedge clk);
	   run_i = 1'b0;
	   repeat (200) @(posedge clk);
	   sw_i = 16'h0003;
	   continue_i = 1'b1;
	   
	   repeat (50) @(posedge clk);
	   continue_i = 1'b0;
	   
	   repeat (100) @(posedge clk);
	   sw_i = 16'h4;
	   run_i = 1'b0;
	   continue_i = 1'b1;
	   repeat (50) @(posedge clk);
	   continue_i = 1'b0;
	   repeat (1000) @(posedge clk);
//	   continue_i = 1'b1;
//	   repeat (50) @(posedge clk);
//	   continue_i = 1'b0;
//	   repeat (50) @(posedge clk);
//	   continue_i = 1'b1;
//	   repeat (50) @(posedge clk);
//	   continue_i = 1'b0;
//	   repeat (50) @(posedge clk);
//	   reset = 1'b0;
//	   repeat (8)@(posedge clk);
	   
    
	   $finish(); //this task will end the simulation if the Vivado settings are properly configured
end

endmodule