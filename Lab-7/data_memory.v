//This is a byte addressable memory.
//You can choose the endianess of the memory
//This is based on Little endian.
module data_memory (address, read_data, write_data, memread, memwrite, clk, reset);
/*parameter Address_width=6'b100000;
input [Address_width-1:0] Address;*/
input [31:0] address, write_data;
input clk, reset, memwrite,memread;
output [31:0] read_data;

reg [7:0] data_mem [0:63]; //8-bit wide, 64 registers in total

assign read_data= (memread)?{data_mem[address+3],data_mem[address+2],data_mem[address+1],data_mem[address]}: 32'hzzzz;
//convention is such that reads occur on posedge and write on negedge
always @(posedge clk or negedge reset)
	begin
		if(reset==1'b0) $readmemh("Dmem.txt", dmem); //reading a text-file and storing the contents into the memory array
	end


always @(negedge clk)
	begin
		if(memwrite)
		{data_mem[address+3],data_mem[address+2],data_mem[address+1],data_mem[address]} <= write_data; //little endian
	end
endmodule