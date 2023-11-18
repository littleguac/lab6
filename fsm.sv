module fsm(clk, reset, s, w, nsel, out);

input clk, reset, s;
output w;
output [6:0] out;
output [2:0] nsel;
`define SW 4 //ballpark for the number of states needed
`define WAIT 4'b0000 //wait state for FSM
`define DECODE 4'b0001 //decode buffer state
`define WRITEMM 4'b0010 //state to write an immediate to a register
`define GETA 4'b0011 //state to load register A
`define GETB 4'b0100 //state to load register B
`define OP 4'b0101 //state for ALU operations
`define WriteReg 4'b0110 //state for writing output of operation into reg
//all the internal signals for the datapath and w
wire bsel, asel, loada, loadb, write, loadc, loads 
wire [3:0] vsel; 
//present state for the FSM

reg [SW-1:0] present_state 

//output = {asel, bsel, loada, loadb, loadc, write, loads, vsel}

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
        out = {11{1'b0}};
        w = 1'b1;
        nsel = 3'b000;
    end
    DECODE:begin
    //all outputs should still be 0 in the decode state 
    //no longer in waiting stage
        out = {11{1'b0}};
        w = 1'b0;
        nsel = 3'b000;
    end
    WRITEMM:begin
    //write is 1 with vsel choosing the sign extended 8 bit
    //nsel passes Rn through to datapath
        out = {11'b0000100010};
        w = 1'b0;
        nsel = 3'b100;
    end
    GETA:begin
    //loada is the only positive signal
    //vsel is unchanged, choosing sximmi8
    //nsel passes Rn through to datapath
        out = {11'b00100000010};
        w = 1'b0;
        nsel = 3'b100;
    end
    GETB:begin
    //loadb is the only signal
    //vsel is unchanged, choosing sximmi8
    //nsel passes Rm through to datapath
        out = {11'b00010000010};
        w = 1'b0;
        nsel = 3'b001;
    end
    OP:begin
    //asel and bsel are both 0 to pass register signals
    //vsel is unchanged, choosing sximmi8
    //loadc and loads are on
    //nsel passes Rm through to datapath
        out = {1'b00001010010};
        w = 1'b0;
        nsel = 3'b001;
    end
    WriteReg:begin
    //write is 1 to overwrite a register
    //vsel is now passing the datapath_out
    //nsel passes Rm through to datapath
        out = {7'b00000101000};
        w = 1'b0;
        nsel = 3'b001;
    end
    endcase
end
endmodule
