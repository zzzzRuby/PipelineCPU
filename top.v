`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:54:47 12/29/2015 
// Design Name: 
// Module Name:    top 
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
`include "macro.v"
module top(
		input wire clk,
		input wire reset,
		input wire start,
		input wire enable,
		input wire [2:0]select_y,
		output wire [6:0]a_to_g,
		output wire [3:0]num_en
    );
	 
	wire [15:0]y;
	cpu cpu_inst(
			.clk(clk),
			.reset(reset),
			.start(start),
			.enable(enable),
			.select_y(select_y),
			.y(y)
	);
	
	wire [1:0]num_clk;
	
	fdivide div_clk(
			.reset(reset),
			.clk_in(clk),
			.clk_out2(num_clk[1]),
			.clk_out3(num_clk[0])
	);
	
	wire [3:0]enable_;
	assign enable_ = enable?(4'b1111):(4'b0000);
	
	num num_dislpay(
			.number(y),
			.enable(enable_),
			.clk(num_clk),
			.a_to_g(a_to_g),
			.en(num_en)
	);
endmodule
