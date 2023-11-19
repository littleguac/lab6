module cpu(clk,reset,s,load,in,out,N,V,Z,w);
input clk, reset, s, load;
input [15:0] in;
output [15:0] out;
output reg N, V, Z, w;

`define Wait 5'b00000
`define decode 5'b00001
`define write 5'b00010
`define getA1 5'b00100
`define getB1 5'b01000
`define add1 5'b10000
`define writereg1 5'b00011

reg [2:0] nsel;
wire [2:0] opcode;
wire [1:0] op;
wire [1:0] ALUop;
wire [15:0] sximm5;
wire [15:0] sximm8;
wire [1:0] shift;
wire [2:0] readnum;
wire [2:0] writenum;
wire [15:0] mdata;
wire [7:0] PC;

wire [15:0] instruct_out;
reg [4:0] present_state;

reg write, loada, loadb, asel, bsel, loadc, loads;
reg [1:0] vsel;


	assign mdata =16'b0000000000000000;
	assign PC = 8'b00000000;


	vDFFE #(16) instruction_register(clk, load, in, instruct_out);

	instructiondecoder instruction_decoder(instruct_out, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum);

	always_ff @(posedge clk) begin

		if(reset) begin

			present_state = `Wait;
			//write = 1'b0;
			//loada = 1'b0;
			//loadb = 1'b0;
			//asel = 1'b0;
			//bsel = 1'b0;
			//loadc = 1'b0;
			//loads = 1'b0;
			//vsel = 2'b10;

		end

		

		

		else begin

		case(present_state)

		`Wait : if(s == 1'b1 & opcode == 3'b110) begin
			present_state = `decode;
			end

			else if(s == 1'b1 & opcode == 3'b101) begin
			present_state = `getA1;
			end

			else begin
			present_state = `Wait;
			end

		`decode : if(op == 2'b10) begin
			  present_state = `write;
			  end

			  else if(op == 2'b00) begin
			  present_state = `getA1;
			  end

			  else begin
			  present_state = `Wait;
			  end

		`write : present_state = `Wait;
	
		`getA1 :	present_state = `getB1; 

		`getB1 :	present_state = `add1;

		`add1 : 	present_state = `writereg1;

		`writereg1 : 	present_state = `Wait;

		default : present_state = 5'bxxxxx;

		endcase

	

		

		case(present_state)

		`Wait : begin
			write <= 1'b0;
			loada <= 1'b0;
			loadb <= 1'b0;
			asel <= 1'b0;
			bsel <= 1'b0;
			loadc <= 1'b0;
			loads <= 1'b0;
			vsel <= 2'b10;
			nsel <= 3'b000;
			w <= 1'b1;
			end

		`decode :	begin
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b000;
				w <= 1'b0;
				end

		`write :	begin
				write <= 1'b1;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b100;
				w <= 1'b0;
				end

		`getA1 :	begin
				write = 1'b0;
				loada = 1'b1;
				loadb = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				vsel = 2'b10;
				nsel = 3'b001;
				w = 1'b0;
				end

		`getB1 :	begin
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b1;
				asel = 1'b0;
				bsel = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				vsel = 2'b10;
				nsel = 3'b010;
				w = 1'b0;
				end

		`add1 :		begin
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
				loadc = 1'b1;
				loads = 1'b0;
				vsel = 2'b10;
				nsel = 3'b000;
				w = 1'b0;
				end

		`writereg1 :	begin
				write = 1'b1;
				loada = 1'b0;
				loadb = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				vsel = 2'b00;
				nsel = 3'b100;
				w = 1'b0;
				end

		

		default :	begin
				write = 1'bx;
				loada = 1'bx;
				loadb = 1'bx;
				asel = 1'bx;
				bsel = 1'bx;
				loadc = 1'bx;
				loads = 1'bx;
				vsel = 2'bxx;
				nsel = 3'bxxx;
				w = 1'b0;
				end

		endcase
		



		end

	end

	datapath DP(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads,
 	writenum, write, mdata, sximm8, sximm5, PC, out, N, V, Z );
	

		

		
		 

		

			

		
		

		

	


	

	

	



endmodule

module vDFFE(clk, en, in, out); //module for register with load enable
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule


