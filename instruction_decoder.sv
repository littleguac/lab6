module instruction_decoder(in, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum);
input [15:0] in;
input [2:0] nsel;
output reg [2:0] opcode;
output reg [1:0] op;

output reg [1:0] ALUop;
output reg [15:0] sximm5;
output reg [15:0] sximm8;
output reg [1:0] shift;
output reg [2:0] readnum;
output reg [2:0] writenum;

reg [4:0] imm5;
reg [7:0] imm8;
reg [2:0] Rm;
reg [2:0] Rd;
reg [2:0] Rn;






always_comb begin

	imm5 = in[4:0];
	imm8 = in[7:0];
	Rm = in[2:0];
	Rd = in[7:5];
	Rn = in[10:8];

    	sximm5 = { {11{imm5[4]}}, imm5};
    	sximm8 = { {8{imm8[7]}}, imm8};

    	case(nsel)

    	3'b001: begin
		readnum = Rn;
		writenum = Rn;
		end
	3'b010: begin
		readnum = Rm;
		writenum = Rm;
		end
	3'b100: begin
		readnum = Rd;
		writenum = Rd;
		end
	default: begin
		readnum = 3'bxxx;
		writenum =3'bxxx;
		end
   	endcase

	ALUop = in[12:11];
	shift = in[4:3];

	opcode = in[15:13];
	op = in[12:11];

	
	
	

	

	
end



endmodule
