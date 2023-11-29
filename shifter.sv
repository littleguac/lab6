module shifter(in,shift,sout);
input [15:0] in;
input [1:0] shift;
output reg [15:0] sout;

	`define LSB in[0]
	`define MSB in[15]

	always_comb begin

		case(shift) //case statement for operation to perform depending in the input

	2'b00 : sout = in; //does not shift the input of shift = 00

	2'b01 : begin //if shift = 01, shifts the signal on but to the left, with LSB being 0
		sout = in << 1;
		sout[0] = 1'b0;
		end

	2'b10 : begin //if shift is 10, shifts one to the right with MSB being 0
		sout = in >> 1;
		sout[15] = 1'b0;
		end

	2'b11 : begin	//if shift is 10, shifts one to the right with MSB being MSB
		sout = in >> 1;
		sout[15] = `MSB;
		end

	default : sout = 16'bxxxxxxxxxxxxxxxx;

	

	endcase

	end

endmodule
