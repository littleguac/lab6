module fsm(clk, reset, s, w, out);
`define SW 4 //ballpark for the number of states needed
`define WAIT 4'b0000 //wait state for FSM
`define DECODE 4'b0001 //decode buffer state
`define WRITEMM 4'b0010 //state to write an immediate to a register
`define GETA 4'b0011 //state to load register A
`define GETB 4'b0100 //state to load register B
`define OP 4'b0101 //state for ALU operations
`define WriteReg 4'b0110 //state for writing output of operation into reg
//all the internal signals for the datapath, nsel, and w
wire bsel, asel, loada, loadb, write, loadc, loads, nsel, w; 
//present state for the FSM
reg [SW-1:0] present_state 


always @(posedge clk) begin
        //sends FSM to wait state
	if (reset) begin
		present_state = `WAIT;
	end

	else begin
        case(present_state)
        //when in wait, stays until s is input
        WAIT: begin 
            if(s)
                present_state = DECODE;
            else
                present_state = WAIT;
        end
        DECODE: begin
        //when i decode, if opcode goes to write immediate
            if(opcode)
                present_state = WRITEMM;
            else
                present_state = GETA;
            end
        //state for writing immediates
        WRITEMM: present_state = WAIT;
        //state transitions for operations
        GETA: present_state = GETB;
        GETB: present_state = OP;
        OP: present_state = WriteReg;
        WriteReg: present_state = WAIT;
        endcase


        end
end

always @(*)begin
    case(present_state)
    //assigns 0 to all outputs in WAIT State, and w to 1
    WAIT: begin
        out = {7'b0000000};
        w = 1'b1;
    end
    endcase
end
endmodule