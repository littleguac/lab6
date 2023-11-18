module instruction_decoder(in, nsel, datapath_out, fsm_out);
input [15:0] in;
input [2:0] nsel;
output [4:0] fsm_out;
output [38:0] datapath_out;

wire [4:0] imm5;
wire [7:0] imm8;
wire [3:0] Rn, Rd, Rm;
wire [1:0] ALUop;
reg [15:0] sximm5;
reg [15:0] sximm8;
wire [1:0] shift;
reg [2:0] numout;

assign opcode = in[15:13];
assign op = in[12:11];
assign ALUop = in[12:11];
assign imm5 = in[4:0];
assign imm8 = in[7:0];
assign shift = in[4:3];
assign Rn = in[10:8];
assign Rd = in[7:5];
assign Rm = in[2:0];

always @(*)begin

    sximm5 = { {11{imm5[5]}}, imm5};
    sximm5 = { {8{imm8[8]}}, imm8};

    case(nsel)
        3'b001: numout = Rm;
        3'b010: numout = Rd;
        3'b100: numout = Rn;
        default: numout = 3'bxxx;
    endcase
end

assign datapath_outout = {ALUop, sximm5, sximm8, shift, numout};
assign fsm_out = {opcode, op};

endmodule