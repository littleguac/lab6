module cpu(clk,reset,read_data,datapath_out,mem_cmd,mem_addr);
input clk, reset; 
input [15:0] read_data;
output [15:0] datapath_out;
reg load_ir;
output reg [1:0] mem_cmd;
output reg [8:0] mem_addr;
reg reset_pc;
reg load_pc;
reg addr_sel;
reg load_addr;


`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b10


`define Wait 5'b00000
`define decode 5'b00001
`define write 5'b00010
`define getA1 5'b00100
`define getB1 5'b01000
`define add1 5'b10000
`define writereg1 5'b00011
`define getA0 5'b00110
`define getB0 5'b01100
`define add0 5'b11000
`define add2 5'b11100
`define RST 5'b11110
`define IF1 5'b11111
`define IF2 5'b11101
`define updatePC 5'b11011
`define getA3 5'b10111
`define getB3 5'b01111
`define add3 5'b10100
`define LDR 5'b10010
`define load_data 5'b10011
`define HALT 5'b00011

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
wire [8:0] next_pc;
reg [8:0] add;
wire [8:0] PC;
wire N,V,Z;
wire [8:0] data;


wire [15:0] instruct_out;
reg [4:0] present_state;

reg write, loada, loadb, asel, bsel, loadc, loads;
reg [1:0] vsel;


	assign mdata = read_data;


	vDFFE #(16) instruction_register(clk, load_ir, read_data, instruct_out); // a load eneabler that stores the instructions

	instruction_decoder Dut(instruct_out, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum); // this module decodes the instruction into the various inputs needed by the data path

		

	always_ff @(posedge clk) begin

		if(reset) begin // if reset is 1, then the fsm goes back to wait

			present_state = `RST;
			//write = 1'b0;
			//loada = 1'b0;
			//loadb = 1'b0;
			//asel = 1'b0;
			//bsel = 1'b0;
			//loadc = 1'b0;
			//loads = 1'b0;
			//vsel = 2'b10;

		end

		

		

		else 

		case(present_state)

		`RST : 		present_state = `IF1;

		`IF1 : 		present_state = `IF2;

		`IF2 :		present_state = `updatePC;

		`updatePC :	present_state = `decode;

		`decode : if(opcode == 3'b110 & op == 2'b10) begin // if op is 10, fsm moves to write for the function MOV with constant
			  present_state = `write;
			  end

			  else if(opcode == 3'b110 &op == 2'b00) begin  // if op is 00, fsm moves to write for the function MOV with another register
			  present_state = `getA0;
			  end

			  else if( opcode == 3'b101 & op !== 2'b11) begin // if s is 1, opcode is 101, and op is not 11, fsm moves to state getA1 
			  present_state = `getA1;
			  end

			  else if( opcode == 3'b101 & op == 2'b11) begin // if s is 1, opcode is 101, and op is 11, fsm moves to state getA0, which is for MVN
			  present_state = `getA0;
			  end

			  else if( opcode == 3'b011 | opcode == 3'b100) begin
			  present_state = `getA3;
			  end

			  else if( opcode == 3'b111) begin
			  present_state = `HALT;
			  end

			  else begin // if s is not 1, the fsm moves back to wait
			  present_state = `IF1;
			  end

		`write : present_state = `IF1; // from write go back to wait
	
		`getA1 :	present_state = `getB1; // from A1 the fsm will move to B1

		`getA3 :	present_state = `getB3;

		`getB3 :	present_state = `add3;

		`add3 : 	present_state = `load_data;

		`load_data :		present_state = `LDR;

		`getA0 :	present_state = `getB0; // from A0 the fsm will move to B0

		`getB0 :	present_state = `add0; // from B0 the fsm will move to add0

		`add0 : 	present_state = `writereg1; // from add0 the fsm moves to writereg1

		`getB1 :	if(op == 2'b01) begin // from B1 the fsm will move to add2, if op is 01, for the function CMP
				present_state = `add2;
				end

				else begin // from B1 the fsm will move to add1, if op is not 01, for the other alu functions
				present_state = `add1;
				end

		`add1 : 	present_state = `writereg1; // from add0 the fsm moves to writereg1

		`add2 :		present_state = `IF1; // from add2 the fsm moves to wait

		`writereg1 : 	present_state = `IF1; // from writereg1 the fsm moves back to wait

		`LDR : 		present_state = `IF1;

		`HALT :		present_state = `HALT;

		default : present_state = 5'bxxxxx;

		endcase

	

		

		case(present_state)

		`RST	 :	begin // output when the state is decode, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b000;
				reset_pc <= 1'b1;
				load_pc <= 1'b1;
				addr_sel <= 1'b0;
				mem_cmd <= `MNONE;
				load_ir <= 1'b0;
				load_addr <= 1'b0;
				end

		`IF1	 :	begin // output when the state is decode, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b000;
				reset_pc <= 1'b0;
				load_pc <= 1'b0;
				addr_sel <= 1'b1;
				mem_cmd <= `MREAD;
				load_ir <= 1'b0;
				load_addr <= 1'b0;
				end

		`IF2	 :	begin // output when the state is decode, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b000;
				reset_pc <= 1'b0;
				load_pc <= 1'b0;
				addr_sel <= 1'b1;
				mem_cmd <= `MREAD;
				load_ir <= 1'b1;
				load_addr <= 1'b0;
				end

		`updatePC	 :	begin // output when the state is decode, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b000;
				reset_pc <= 1'b0;
				load_pc <= 1'b1;
				addr_sel <= 1'b0;
				mem_cmd <= `MNONE;
				load_ir <= 1'b0;
				load_addr <= 1'b0;
				end


		`decode :	begin // output when the state is decode, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b000;
				reset_pc <= 1'b0;
				load_pc <= 1'b0;
				addr_sel <= 1'b0;
				mem_cmd <= `MNONE;
				load_ir <= 1'b0;
				load_addr <= 1'b0;
				end

		`write :	begin // output when the state is write, w = 0
				write <= 1'b1;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b001;
				reset_pc <= 1'b0;
				load_pc <= 1'b0;
				addr_sel <= 1'b0;
				mem_cmd <= `MNONE;
				load_ir <= 1'b0;
				load_addr <= 1'b0;
				end

		`getA1 :	begin // output when the state is getA1, w = 0
				write <= 1'b0;
				loada <= 1'b1;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b001;
				reset_pc <= 1'b0;
				load_pc <= 1'b0;
				addr_sel <= 1'b0;
				mem_cmd <= `MNONE;
				load_ir <= 1'b0;
				load_addr <= 1'b0;
				end

		`getA0 :	begin // output when the state is getA0, w = 0
				write <= 1'b0;
				loada <= 1'b1;
				loadb <= 1'b0;
				asel <= 1'b1;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b001;
				reset_pc <= 1'b0;
				load_pc <= 1'b0;
				addr_sel <= 1'b0;
				mem_cmd <= `MNONE;
				load_ir <= 1'b0;
				load_addr <= 1'b0;
				end

		`getA3 :	begin // output when the state is getA1, w = 0
				write <= 1'b0;
				loada <= 1'b1;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b001;
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				mem_cmd = `MNONE;
				load_ir = 1'b0;
				load_addr = 1'b0;
				end

		

		`getB1 :	begin // output when the state is getB1, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b1;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b010;
				reset_pc <= 1'b0;
				load_pc <= 1'b0;
				addr_sel <= 1'b0;
				mem_cmd <= `MNONE;
				load_ir <= 1'b0;
				load_addr <= 1'b0;
				end

		`getB3 :	begin // output when the state is getB1, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b1;
				asel <= 1'b0;
				bsel <= 1'b1;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b010;
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				mem_cmd = `MNONE;
				load_ir = 1'b0;
				load_addr = 1'b0;
				end

		`getB0 :	begin // output when the state is getB0, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b1;
				asel <= 1'b1;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b010;
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				mem_cmd = `MNONE;
				load_ir = 1'b0;
				load_addr = 1'b0;
				end


		`add1 :		begin // output when the state is add1, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b1;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b000;
				reset_pc <= 1'b0;
				load_pc <= 1'b0;
				addr_sel <= 1'b0;
				mem_cmd <= `MNONE;
				load_ir <= 1'b0;
				load_addr <= 1'b0;
				end

		`add0 :		begin // output when the state is add0, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b1;
				bsel <= 1'b0;
				loadc <= 1'b1;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b000;
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				mem_cmd = `MNONE;
				load_ir = 1'b0;
				load_addr = 1'b0;
				end

		`add2 :		begin // output when the state is add2, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b1;
				loads <= 1'b1;
				vsel <= 2'b10;
				nsel <= 3'b000;
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				mem_cmd = `MNONE;
				load_ir = 1'b0;
				load_addr = 1'b0;
				end

		`add3 :		begin // output when the state is add1, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b1;
				loadc <= 1'b1;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b000;
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				mem_cmd = `MNONE;
				load_ir = 1'b0;
				load_addr = 1'b0;
				end

		`load_data :		begin // output when the state is add1, w = 0
				write <= 1'b0;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b10;
				nsel <= 3'b100;
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				mem_cmd = `MNONE;
				load_ir = 1'b0;
				load_addr = 1'b1;
				end

		`LDR :		begin // output when the state is add1, w = 0
				write <= 1'b1;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b11;
				nsel <= 3'b100;
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				mem_cmd = `MREAD;
				load_ir = 1'b0;
				load_addr = 1'b0;
				end

		`writereg1 :	begin // output when the state is writereg1, w = 0
				write <= 1'b1;
				loada <= 1'b0;
				loadb <= 1'b0;
				asel <= 1'b0;
				bsel <= 1'b0;
				loadc <= 1'b0;
				loads <= 1'b0;
				vsel <= 2'b00;
				nsel <= 3'b100;
				reset_pc <= 1'b0;
				load_pc <= 1'b0;
				addr_sel <= 1'b0;
				mem_cmd <= `MNONE;
				load_ir <= 1'b0;
				load_addr <= 1'b0;
				end


		

		default :	begin // output when the fsm is not in any defined state
				write <= 1'bx;
				loada <= 1'bx;
				loadb <= 1'bx;
				asel <= 1'bx;
				bsel <= 1'bx;
				loadc <= 1'bx;
				loads <= 1'bx;
				vsel <= 2'bxx;
				nsel <= 3'bxxx;
				reset_pc <= 1'b1;
				load_pc <= 1'bx;
				addr_sel <= 1'bx;
				mem_cmd <= 2'bxx;
				load_ir <= 1'bx;
				load_addr <= 1'bx;
				end

		endcase
		



		

	end

	

	datapath DP(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads,
 	writenum, write, mdata, sximm8, sximm5, PC, datapath_out, N, V, Z ); //instantiates the datapath file)
	

	assign next_pc = reset_pc ? 9'b000000000 : add;

	vDFFE_PC #(9) program_counter(clk,load_pc,next_pc,PC);

	always_comb begin

	add = PC + 1'b1;

	end

	assign mem_addr = addr_sel ? PC : data;

	
	vDFFE_DA #(9) data_address(clk, load_addr, datapath_out[8:0], data);
	
	
		

			

		
		

		

	


	

	

	



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

module vDFFE_PC(clk, en, in, out); //module for register with load enable
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule

module vDFFE_DA(clk, en, in, out); //module for register with load enable
	
	parameter n = 1;
	input clk, en;
	input [n-1:0] in;
	output reg [n-1:0] out;
	wire [n-1:0] next_state;

	assign next_state = en ? in : out;

	always @(posedge clk)
		out = next_state;

endmodule


