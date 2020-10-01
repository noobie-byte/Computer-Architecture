//implementing the control logic for the single cycle design.
//Choosing an Hierarchical approach to create the single cycle controller
`timescale 1ns /100ps
module single_cylce_controller(OPcode,Regwrite,ALUSrc,RegDest,ALUOp);
input [5:0] OPcode;//funct is given as an input to the ALUControl
output reg Regwrite,ALUSrc,RegDest;
output [1:0] ALUOp;
reg ALUOp1, ALUOp0;
assign ALUOp = {ALUOp1,ALUOp0};//dataflow modeling

always @ (OPcode) //ROM based design
	begin
		case(OPcode)
		//R-type instruction format
		6'b 000000: begin
						Regwrite=1'b1; ALUSrc=1'b0; RegDest=1'b1;ALUOp1=1'b1;ALUOp0=1'b0;/*MemtoReg=1'b0;Memread=1'b0;Memwrite=1'b0*/
					end 
		//I type instruction format
	   /*6'b 001001: begin
	   					Regwrite=1'b1; ALUSrc=1'b1; RegDest=1'b1; ALUOp=2'b00;
	   			   end*/
	   			   //similarly write for U type, Branch type etc
	   	default: begin
	   					Regwrite=1'bz; ALUSrc=1'bz; RegDest=1'bz; ALUOp1= 1'bz; ALUOp0=1'bz;/*MemtoReg=1'bz;Memread=1'bz;Memwrite=1'bz*/
	   			 end
	   	endcase
	end
endmodule

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
		$display($time,"funct=%b, ALUOp=%b, ALU_ctrl=%b", funct, ALUOp, ALU_ctrl);
		 funct= 6'b 100000; ALUOp= 2'b10;
		#10 funct= 6'b 100010; ALUOp= 2'b10;
		#10 funct= 6'b 100100; ALUOp= 2'b10;
		#10 funct= 6'b 100111; ALUOp= 2'b10;
		#60 $finish;
	end
endmodule	
/*module testbench();
reg [5:0] OP, funct;
wire [3:0] ALU_ctrl;
reg [1:0] ALUOp;
reg Regwrite,ALUSrc,RegDest;
ALU_Control DUT1 (.ALU_ctrl(ALU_ctrl),.ALUOp(ALUOp),.funct(funct)); //format <dut_module> <instance name>(.<dut_signal>(test_module_signal),…)
single_cycle_controller DUT2 (.OP(OPcode),.Regwrite(Regwrite),.ALUSrc(ALUSrc),.RegDest(RegDest),.ALUOp(ALUOp));*/



