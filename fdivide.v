`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:38:22 11/23/2015 
// Design Name: 
// Module Name:    fdevide 
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
module fdivide(
	input wire reset,
	input wire clk_in,
	output wire clk_out2,
	output wire clk_out3
    );
	parameter N2 = 15;
	parameter N3 = 14;
	parameter MAX = 15;
	reg [MAX:0] count;
	
	always @(posedge clk_in or posedge reset) begin
		if (reset) count <= 0;
		else count <= count + 1'b1;
	end
	
	assign clk_out2 = count[N2];
	assign clk_out3 = count[N3];
endmodule
