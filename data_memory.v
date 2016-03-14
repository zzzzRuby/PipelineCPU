`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:01:50 01/04/2016 
// Design Name: 
// Module Name:    data_memory 
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
module data_memory(
		input wire wea,
		input wire clka,
		input wire [7:0]addra,
		output wire [15:0]douta,
		input wire [15:0]dina,
		input wire ena
    );
	
	parameter deep = 256;
	(*KEEP = "TRUE"*)
	reg [15:0]mem[deep - 1:0];
	
	always@(posedge clka) begin
		if (ena&&wea) begin
			mem[addra] <= dina;
		end
	end
	
	assign douta = mem[addra];

	integer k;
	initial begin
		mem[0] = 0;
		mem[1] = 9;
		mem[2] = 6;
		for(k = 3;k < deep;k = k + 1)
			mem[k] <= 0;
	end
endmodule
