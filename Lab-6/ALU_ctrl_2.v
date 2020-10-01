module ALU_Control (ALU_ctrl,funct, ALUOp);
input [5:0] funct;
input [1:0] ALUOp;
output reg [3:0] ALU_ctrl;
//output sign;
//parameter
    
always @(ALUOp, funct)
	begin
		case(ALUOp)
		2'b00: //LW or SW 
		ALU_ctrl= 4'b0010;//0010 implies "ADD" refer to figure 4.12
		2'b01: ALU_ctrl=4'b0110; //subtract for Beq
		2'b10: case(funct)//R-type functions
							6'b 100000: ALU_ctrl= 4'b 0010;//add
							6'b 100010: ALU_ctrl= 4'b 0110;//sub
							6'b 100100: ALU_ctrl= 4'b 0000;//and
							6'b 100101: ALU_ctrl= 4'b 0001;//or
							6'b 101010: ALU_ctrl= 4'b 0111; //set on less than
							default: ALU_ctrl = 4'bzzzz;
				endcase	
		2'b11: ALU_ctrl=4'b zzzz;//since 2'b11 is not defined as a control 
		default: ALU_ctrl=4'bzzzz;
		endcase		
	end	
endmodule

module ALU_2_tb();
reg [5:0] funct;
reg [1:0] ALUOp;
wire [3:0] ALU_ctrl;
ALU_Control DUT (.ALU_ctrl(ALU_ctrl),.funct(funct), .ALUOp(ALUOp));
initial
	begin
		$dumpfile("ALU_2.vcd");
		$dumpvars(0,ALU_2_tb);
		$monitor($time,"  funct=%b, ALUOp=%b, ALU_ctrl=%b", funct, ALUOp, ALU_ctrl);
		 funct= 6'b 100000; ALUOp= 2'b10;
		#10 funct= 6'b 100010; ALUOp= 2'b10;
		#10 funct= 6'b 100100; ALUOp= 2'b10;
		#10 funct= 6'b 100111; ALUOp= 2'b10;
		#60 $finish;
	end
endmodule	
