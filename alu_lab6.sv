module ALU(Ain,Bin,ALUop,out,Z);
input [15:0] Ain, Bin;	//the two inputs to the ALU operation
input [1:0] ALUop;	//the operation assigner
output reg [15:0] out;	//the output
output reg [2:0] Z;	//the output that contains the zero, negative, and overflow flags

reg samesign;	//checks if the input and output are the same sign for overflow
reg inoutdiff;	//checks if the input and output are the opposite sign, which indicates overflow

	always_comb begin

		if( ALUop == 2'b00 ) begin	
			out = Ain + Bin;
		end 		
		else if ( ALUop == 2'b01 ) begin
			out = Ain - Bin;
		end 
		else if ( ALUop == 2'b10 ) begin
			out = Ain & Bin;
    		end 
		else begin
			out = ~Bin;
		end
		

		if(Ain[15] == Bin[15])begin //checks if the inputs are the same sign 
			samesign = 1'b1;
    		end 
		else begin
			samesign = 1'b0;
		end
		
		if(out[15] != Bin[15])begin //checks if the inputs and outputs are different signs
			inoutdiff = 1'b1;
    		end 
		else begin
			inoutdiff = 1'b0;
		end
	
		if(out == {16{1'b0}})begin	//checks if all of the values are 0 to set the zero register
			Z[0] = 1'b1; 			
    		end 
		else begin
			Z[0] = 1'b0;		
		end
		
		if(out[15] == 1 ) begin		//checks to set the negative register
			Z[1] = 1'b1; 			
    		end else begin
			Z[1] = 1'b0;
		end
		
		if(samesign && inoutdiff)begin 		//overflow conditions and register being set
			Z[2] = 1'b1;
    		end else begin
			Z[2] = 1'b0;
		end
	end

endmodule
