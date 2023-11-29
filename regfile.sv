module regfile(data_in,writenum,write,readnum,clk,data_out);
input [15:0] data_in;
input [2:0] writenum, readnum;
input write, clk;
output reg [15:0] data_out;

//defines all of the internal signals
wire [7:0] decoder_1;
wire [7:0] decoder_2;
wire [7:0] regload;
reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7;

	//3:8 decoder module with the writenum, transforming to one hot
	Dec3_8 dut_dec1(writenum, decoder_1);
	//assigning if each register should be written into depending on writenum and write signals
	assign regload[0] = decoder_1[0] & write;
	assign regload[1] = decoder_1[1] & write;
	assign regload[2] = decoder_1[2] & write;
	assign regload[3] = decoder_1[3] & write;
	assign regload[4] = decoder_1[4] & write;
	assign regload[5] = decoder_1[5] & write;
	assign regload[6] = decoder_1[6] & write;
	assign regload[7] = decoder_1[7] & write;

	//initializing 8 instanes of the regsiter with load enable to make up the complete regfile
	vDFFE_0 #(16) dut_0(clk, regload[0], data_in, R0);
	vDFFE_1 #(16) dut_1(clk, regload[1], data_in, R1);
	vDFFE_2 #(16) dut_2(clk, regload[2], data_in, R2);
	vDFFE_3 #(16) dut_3(clk, regload[3], data_in, R3);
	vDFFE_4 #(16) dut_4(clk, regload[4], data_in, R4);
	vDFFE_5 #(16) dut_5(clk, regload[5], data_in, R5);
	vDFFE_6 #(16) dut_6(clk, regload[6], data_in, R6);
	vDFFE_7 #(16) dut_7(clk, regload[7], data_in, R7);	

	//initializing a second instance of the 3:8 decoder module for readnum
	Dec3_8 dut_dec2(readnum, decoder_2);

	always_comb begin

	case(decoder_2)
		//depending on the value of readnum, loads a register into data_out 
	8'b00000001 : data_out = R0;
	8'b00000010 : data_out = R1;
	8'b00000100 : data_out = R2;
	8'b00001000 : data_out = R3;
	8'b00010000 : data_out = R4;
	8'b00100000 : data_out = R5;
	8'b01000000 : data_out = R6;	
	8'b10000000 : data_out = R7;

	default : data_out = 16'bxxxxxxxxxxxxxxxx;

	endcase

	end

endmodule



module Dec3_8(in, out); //3:8 decoder module

	input [2:0] in;
	output [7:0] out;

	wire [7:0] out = 1 << in;

endmodule

module vDFFE_0(clk, en, in, out); //register with load enable module
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule

module vDFFE_1(clk, en, in, out);
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule

module vDFFE_2(clk, en, in, out);
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule

module vDFFE_3(clk, en, in, out);
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule

module vDFFE_4(clk, en, in, out);
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule

module vDFFE_5(clk, en, in, out);
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule

module vDFFE_6(clk, en, in, out);
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule

module vDFFE_7(clk, en, in, out);
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule





