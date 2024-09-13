
module ALU(Ain,Bin,ALUop,out,Z);
input [15:0] Ain, Bin; //the two 16 bit signals that are being fed into the ALU 
input [1:0] ALUop; //specifies which operation the ALU will perform	
output reg [15:0] out;	//output of the ALU 
output reg Z;	//zero flag

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

		if( out == 16'b0 ) begin //sets Zero flag if the output is 0 
			Z = 1'b1;
		end

		else begin
			Z = 1'b0; //if out is not zero, sets the zero flag to 0
		end
	end

endmodule
