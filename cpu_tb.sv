module cpu_tb;
reg clk, reset, err; 
reg [15:0] read_data;
wire [15:0] datapath_out;
wire [1:0] mem_cmd;
wire [8:0] mem_addr;

cpu DUT(clk,reset,read_data,datapath_out,mem_cmd,mem_addr);

initial forever begin
    clk = 0; #5;
    clk = 1; #5;
  end

initial begin

	err= 1'b0;

	reset = 1'b1; #10;
	reset = 1'b0;

	

	@(posedge DUT.PC or negedge DUT.PC); //loads in the instuction to MOV R0, #7

	read_data = 16'b1101000000000111;

	@(posedge DUT.PC or negedge DUT.PC); //loads in the instuction to MOV R1, #2

	read_data = 16'b1101000100000010;

	@(posedge DUT.PC or negedge DUT.PC); //loads in the instuction to ADD R2, R1, R0, LSL#1

	read_data = 16'b1010000101001000;

	@(posedge DUT.PC or negedge DUT.PC);
	
end

endmodule
