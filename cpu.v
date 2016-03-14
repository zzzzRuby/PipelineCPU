`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:23:59 01/05/2016 
// Design Name: 
// Module Name:    cpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module cpu(
		input wire clk,
		input wire reset,
		input wire start,
		input wire enable,
		input wire [2:0]select_y,
		output wire [15:0]y
    );

	wire [15:0]d_datain;
	wire d_we;
	wire [15:0]d_dataout;
	wire [7:0]d_addr;
	
	wire [7:0]i_addr;
	wire [15:0]i_datain;
	
	data_memory d_memory(
			.wea(d_we),
			.clka(clk),
			.addra(d_addr),
			.douta(d_datain),
			.dina(d_dataout),
			.ena(enable)
	);
	
	instruction_mem i_memory(
			.rdata(i_datain),
			.addr(i_addr)
	);
	 
	pipeline_cpu pcpu_inst(
			.clk(clk),
			.d_datain(d_datain),
			.i_datain(i_datain),
			.enable(enable),
			.reset(reset),
			.start(start),
			.d_addr(d_addr),
			.d_dataout(d_dataout),
			.d_we(d_we),
			.i_addr(i_addr),
			.y(y),
			.select_y(select_y)
	);

endmodule
