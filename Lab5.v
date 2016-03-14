`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:54:28 11/16/2015 
// Design Name: 
// Module Name:    Lab5 
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
module num(
		input wire [15:0]number,
		input wire [1:0]clk,
		input wire [3:0]enable,
		output reg [6:0]a_to_g,
		output wire [3:0]en
    );
	 
	wire [3:0] num;
	wire [3:0]en_temp;
	assign en_temp = (clk[1])?(clk[0]?4'b1101:4'b1110):(clk[0]?4'b0111:4'b1011);
	assign en = en_temp | ~({enable[0],enable[1],enable[2],enable[3]});
	assign num = (clk[1])?(clk[0]?number[11:8]:number[15:12]):(clk[0]?number[3:0]:number[7:4]);
		
	always @(*)
		case(num)
			4'b0000:a_to_g <= 7'b0000001;
			4'b0001:a_to_g <= 7'b1001111;
			4'b0010:a_to_g <= 7'b0010010;
			4'b0011:a_to_g <= 7'b0000110;
			4'b0100:a_to_g <= 7'b1001100;
			4'b0101:a_to_g <= 7'b0100100;
			4'b0110:a_to_g <= 7'b0100000;
			4'b0111:a_to_g <= 7'b0001111;
			4'b1000:a_to_g <= 7'b0000000;
			4'b1001:a_to_g <= 7'b0000100;
			4'b1010:a_to_g <= 7'b0001000;
			4'b1011:a_to_g <= 7'b1100000;
			4'b1100:a_to_g <= 7'b0110001;
			4'b1101:a_to_g <= 7'b1000010;
			4'b1110:a_to_g <= 7'b0110000;
			4'b1111:a_to_g <= 7'b0111000;
		endcase
	 
endmodule