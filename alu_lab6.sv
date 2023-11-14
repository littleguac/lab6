module ALU(Ain,Bin,ALUop,out,Z);
input [15:0] Ain, Bin;
input [1:0] ALUop;
output reg [15:0] out;
output reg [2:0] Z;

reg samesign;
reg inoutdiff;

	always_comb begin

	if( ALUop == 2'b00 ) begin	
		out = Ain + Bin;

    end else if ( ALUop == 2'b01 ) begin
		out = Ain - Bin;

    end else if ( ALUop == 2'b10 ) begin
		out = Ain & Bin;
    end else begin
		out = ~Bin;
	end

	if(Ain[15] == Bin[15])begin //checks if the inputs are the same sign 
		samesign = 1'b1;
    end else begin
		samesign = 1'b0;
	end
	if(out[15] != Bin[15])begin //checks if the inputs and outputs are different signs
		inoutdiff = 1'b1;
    end else begin
		inoutdiff = 1'b0;
	end
	
	if(out == {16{1'b0}})begin
		Z[0] = 1'b1; 	//the all zero register
    end else begin
		Z[0] = 1'b0;		
	end
	if(out[15] == 1 ) begin		
		Z[1] = 1'b1; 			//the negative register 
    end else begin
		Z[1] = 1'b0;
	end
	if(samesign && inoutdiff)begin //overflow register
		Z[2] = 1'b1;
    end else begin
		Z[2] = 1'b0;
	end

	end

endmodule
