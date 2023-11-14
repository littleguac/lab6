module cpu(clk,reset,s,load,in,out,N,V,Z,w);
input clk, reset, s, load;
input [15:0] in;
output [15:0] out;
output N ,V, X, w;
wire [15:0] instruct_out

vDFFE #(16) C(.clk(clk), 
                .en(load), 
                .in(in), 
                .out(instruct_out));

datapath datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads,
 	writenum, write, datapath_in, Z_out, datapath_out);


endmodule



module vDFFE(clk, en, in, out);
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule