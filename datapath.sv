module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads,
 	writenum, write, datapath_in, Z_out, datapath_out);

	input write , loada, loadb, asel, bsel, loadc, loads, clk;
	input [3:0] vsel;
	input [2:0] readnum, writenum;
	input [1:0] shift, ALUop;
	input [15:0] datapath_in;
	output [2:0] Z_out;
	output [15:0] datapath_out;

	wire [15:0] data_in;
	wire [15:0] data_out;
	wire [15:0] regA;
	wire [15:0] in;
	wire [15:0] sout;
	wire [15:0] Ain;
	wire [15:0] Bin;
	wire [2:0] Z;
	wire [15:0] out;
	wire[15:0] sximm;
	

	always_comb @(*)begin
		case(vsel)
			4'b0001: datapath_in = mdata;
			4'b0010: datapath_in = sximm8;
			4'b0100: datapath_in = PC;
			4'b1000: datapath_in = datapath_out;
            default: datapath_in = {16{1'bx}};
		endcase
	end


	regfile REGFILE(.data_in(data_in),
                    .writenum(writenum),
                    .write(write),
                    .readnum(readnum),
                    .clk(clk),
                    .data_out(data_out));

	vDFFE #(16) A(.clk(clk),
                .en(loada),
                .in(data_out),
                .out(regA));

	vDFFE #(16) B(.clk(clk),
                .en(loadb),
                .in(data_out),
                .out(in));

	shifter U1(.in(in),
            .shift(shift),
            .sout(sout));

	assign Ain = asel ? 16'b0000000000000000 : regA;

	assign Bin = bsel ? sximm : sout;

	ALU U2(.Ain(Ain),
        .Bin(Bin),
        .ALUop(ALuop),
        .out(out),
        .Z(Z));

	vDFFE #(16) C(.clk(clk), 
                .en(loadc), 
                .in(out), 
                .out(datapath_out));
	vDFFE status(.clk(clk),
                .en(loads),
                .in(Z),
                .out(Z_out));

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
