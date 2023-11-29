
module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
input [3:0] KEY;
input [9:0] SW;
output [9:0] LEDR;
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b10

wire [1:0] mem_cmd;
wire [8:0] mem_addr;
wire [15:0] read_data;
wire [15:0] write_data;
reg out1;
wire out2;
reg out3;
wire out4;
reg msel;
wire [15:0] dout;
wire clk;
reg module_1_out;
reg module_2_out;

assign clk = ~KEY[0];
assign reset = ~KEY[1];

	always_comb begin
	
	if(mem_cmd == `MREAD) begin
		out1 = 1'b1;
	end

	else begin
		out1 = 1'b0;
	end

	end

	always_comb begin
	
	if(mem_cmd == `MWRITE) begin
		out3 = 1'b1;
	end

	else begin
		out3 = 1'b0;
	end

	end



	always_comb begin
	
	if(mem_addr[8] == 1'b0) begin
		msel = 1'b1;
	end

	else begin
		msel = 1'b0;
	end

	end

	

	assign out2 = out1 & msel;

	assign out4 = out3 & msel;

	assign read_data = out2 ? dout : {16{1'bz}};

	
		
	cpu CPU(clk,reset,read_data,write_data,mem_cmd,mem_addr);
	

	RAM MEM(clk,mem_addr[7:0],mem_addr[7:0],out4,write_data,dout);

	
	//always_comb begin

	//if(mem_cmd == `MREAD & mem_addr == 9'h140) begin
	//	module_1_out = 1'b1;
	//end

	//else begin
	//	module_1_out = 1'b0;
	//end
	//
	//end

	//assign read_data[15:8] = module_1_out ? 8'h00 : {8{1'bz}};
	//assign read_data[7:0] = module_1_out ? SW[7:0] : {8{1'bz}};

	

	//always_comb begin
	
	//if(mem_cmd == `MWRITE & mem_addr == 9'h100) begin
	//	module_2_out = 1'b1;
	//end

	//else begin
	//	module_2_out = 1'b0;
	//end
	
	//end

	//vDFFE_LED #(8) dut_LED(clk, module_2_out, write_data[7:0], LEDR[7:0]);

	
endmodule



// To ensure Quartus uses the embedded MLAB memory blocks inside the Cyclone
// V on your DE1-SoC we follow the coding style from in Altera's Quartus II
// Handbook (QII5V1 2015.05.04) in Chapter 12, ?Recommended HDL Coding Style?
//
// 1. "Example 12-11: Verilog Single Clock Simple Dual-Port Synchronous RAM 
//     with Old Data Read-During-Write Behavior" 
// 2. "Example 12-29: Verilog HDL RAM Initialized with the readmemb Command"

module RAM(clk,read_address,write_address,write,din,dout);
  parameter data_width = 16; 
  parameter addr_width = 8;
  parameter filename = "data.txt";

  input clk;
  input [addr_width-1:0] read_address, write_address;
  input write;
  input [data_width-1:0] din;
  output [data_width-1:0] dout;
  reg [data_width-1:0] dout;

  reg [data_width-1:0] mem [2**addr_width-1:0];

  initial $readmemb(filename, mem);

  always @ (posedge clk) begin
    if (write)
      mem[write_address] <= din;
    dout <= mem[read_address]; // dout doesn't get din in this clock cycle 
                               // (this is due to Verilog non-blocking assignment "<=")
  end 
endmodule

module vDFFE_LED(clk, en, in, out); //module for register with load enable
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule

