
module ALU(Ain,Bin,ALUop,out,Z);
input [15:0] Ain, Bin;
input [1:0] ALUop;
output reg [15:0] out;
output reg Z;

	always_comb begin

		if( ALUop == 2'b00 ) begin //specifies the addition operator
		
		out = Ain + Bin;

		end

		else if ( ALUop == 2'b01 ) begin   //specifies the subtraction operator
	
		out = Ain - Bin;

		end

		else if ( ALUop == 2'b10 ) begin //specifies the and operator
	
		out = Ain & Bin;

		end

		else begin

		out = ~Bin; //if none of the above are true, it must be the NOT operation in the ALU

		end

	

		if( out == 16'b0000000000000000 ) begin //sets Z if all of the output are 0
	
		Z = 1'b1;

		end

		else begin

		Z = 1'b0; //if out != 0, then Z stays at 0

		end

	end

endmodule
