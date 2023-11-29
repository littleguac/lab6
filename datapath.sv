module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads,
 	writenum, write, mdata, sximm8, sximm5, PC, C, N, V, Z );

	input write, loada, loadb, asel, bsel, loadc, loads, clk;
	input [1:0] vsel;
	input [2:0] readnum, writenum;
	input [1:0] shift, ALUop;

	input [15:0] mdata;
	input [15:0] sximm8;
	input [7:0] PC;
	input [15:0] sximm5;
	output [15:0] C; //initializes the inputs and outputs
	output reg N,V,Z;
	
	reg [15:0] data_in;
	wire [15:0] data_out;

	reg oppsign;
	reg diff;

	wire [15:0] regA;
	wire [15:0] in;
	wire [15:0] sout;
	wire [15:0] Ain;
	wire [15:0] Bin;
	wire Z_in;
	wire [15:0] out;  //internal signals

	always_comb begin

	case(vsel)

	2'b00 : data_in = C;

 	2'b01 : data_in = {8'b00000000,PC};

	2'b10 : data_in = sximm8;

	2'b11 : data_in = mdata;

	default : data_in = 16'bxxxxxxxxxxxxxxxx;

	endcase

	end
	

	 

	regfile REGFILE(data_in,writenum,write,readnum,clk,data_out); //initializing regfile module

	vDFFE1 #(16) A(clk,loada,data_out,regA); //initializes register for A input to ALU

	vDFFE1 #(16) B(clk,loadb,data_out,in);   //initializes register for B input to ALU

	shifter U1(in,shift,sout); //initializes shifter module

	assign Ain = asel ? 16'b0000000000000000 : regA; //multiplexer for A

	assign Bin = bsel ? sximm5 : sout; //multiplexer for B

	ALU U2(Ain,Bin,ALUop,out,Zin); //the arithmetic Unit

	vDFFE1 #(16) D(clk,loadc,out,C); //register for output

	vDFFE2 status(clk,loads,Zin,Z); //register for Z
	
	always @(posedge clk) begin

	if(ALUop == 2'b01 & loads == 1) begin

	


	if(out[15] == 1'b1) begin
	N = 1'b1;
	end 

	else begin
	N = 1'b0;
	end 

	if(Ain[15] != Bin[15])begin //checks if the inputs are the same sign 
		oppsign = 1'b1;
    end else begin
		oppsign = 1'b0;
	end
	if(out[15] == Bin[15])begin //checks if the inputs and outputs are different signs
		diff = 1'b1;
    end else begin
		diff = 1'b0;
	end

    if(oppsign && diff)begin //overflow register
		V = 1'b1;
    end else begin
		V = 1'b0;
	end

	end

	else begin
		
		
	
	end

		

	end

	

	

endmodule


module vDFFE1(clk, en, in, out); //module for register with load enable
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule

module vDFFE2(clk, en, in, out); //module for register with load enable
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule


