module cpu_tb;

	
reg clk, reset, s, load, err;
reg [15:0] in;
reg [15:0] out;
wire N, V, Z, w;

	cpu DUT(clk,reset,s,load,in,out,N,V,Z,w);

	wire [15:0] R0 = DUT.DP.REGFILE.R0;
 	wire [15:0] R1 = DUT.DP.REGFILE.R1;
  	wire [15:0] R2 = DUT.DP.REGFILE.R2;
  	wire [15:0] R3 = DUT.DP.REGFILE.R3;
  	wire [15:0] R4 = DUT.DP.REGFILE.R4;
  	wire [15:0] R5 = DUT.DP.REGFILE.R5;
  	wire [15:0] R6 = DUT.DP.REGFILE.R6;
  	wire [15:0] R7 = DUT.DP.REGFILE.R7;

	task check2; //task for checking the values stored in all of the registers

	input [15:0] expected_R0;
	input [15:0] expected_R1;
	input [15:0] expected_R2;
	input [15:0] expected_R3;
	input [15:0] expected_R4;
	input [15:0] expected_R5;
	input [15:0] expected_R6;
	input [15:0] expected_R7;

	begin

	if (R0 !== expected_R0) begin 
      		err = 1'b1; 
      		$display("ERROR R0 is %b, expected %b", R0, expected_R0);  
    	end

	if (R1 !== expected_R1) begin 
      		err = 1'b1; 
      		$display("ERROR R1 is %b, expected %b", R1, expected_R1);  
    	end

	if (R2 !== expected_R2) begin 
      		err = 1'b1; 
      		$display("ERROR R2 is %b, expected %b", R2, expected_R2);  
    	end

	if (R3 !== expected_R3) begin 
      		err = 1'b1; 
      		$display("ERROR R3 is %b, expected %b", R3, expected_R3);  
    	end

	if (R4 !== expected_R4) begin 
      		err = 1'b1; 
      		$display("ERROR R4 is %b, expected %b", R4, expected_R4);  
    	end

	if (R5 !== expected_R5) begin 
      		err = 1'b1; 
      		$display("ERROR R5 is %b, expected %b", R5, expected_R5);  
    	end

	if (R6 !== expected_R6) begin 
      		err = 1'b1; 
      		$display("ERROR R6 is %b, expected %b", R6, expected_R6);  
    	end

	if (R7 !== expected_R7) begin 
      		err = 1'b1; 
      		$display("ERROR R7 is %b, expected %b", R7, expected_R7);  
    	end

	end

	endtask

	

	initial begin

	clk = 1'b0; #5;

	forever begin
		
		clk = 1'b1; #5;
		clk = 1'b0; #5;

	end

	end

	initial begin
    	    err = 0;
	    reset = 1; s = 0; load = 0; in = 16'b0;
	    #10;
	    reset = 0; 
	    #10;
	
	    in = 16'b1101000000000111;
	    load = 1;
	    #10;
	    load = 0;
	    s = 1;
	    #10
	    s = 0;
	    @(posedge w); // wait for w to go high again
	    #10;
	    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
	      err = 1;
	      $display("FAILED: MOV R0, #7");
	      $stop;
	    end

	@(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1101000100000010;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'h2) begin
      err = 1;
      $display("FAILED: MOV R1, #2");
      $stop;
    end

	if (~err) $display("INTERFACE OK");
    $stop;
  end
endmodule
	
