`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:03 12/29/2015 
// Design Name: 
// Module Name:    alu 
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

module alu(
		input wire [15:0]oper1,
		input wire [15:0]oper2,
		input wire [4:0]oper_code,
		input wire cf_in,
		input wire [15:0]ALUi,
		output reg [15:0]ALUo,
		output reg cf_out
    );
	
	always@(*) begin
		case(oper_code)
         `NOP,`HALT:begin
				cf_out <= cf_in;
				ALUo <= ALUi;
			end
         `ADD,`ADDI,`ADDRI,`LDIH:	{cf_out , ALUo} <= oper1 + oper2;
         `SUB,`SUBI,`SUBRI,`CMP:		{cf_out , ALUo} <= oper1 - oper2;
         `ADDC:							{cf_out , ALUo} <= oper1 + oper2 + cf_in;
         `SUBC:							{cf_out , ALUo} <= oper1 - oper2 - cf_in;
			`MOVR:begin
				ALUo <= oper1;
				cf_out <= cf_in;
			end
			`ROR:begin
				ALUo <= (oper1 >> oper2)|(oper1 << (16 - oper2));
				cf_out <= cf_in;
			end
			`NOT:begin
				ALUo <= ~oper1;
				cf_out <= cf_in;
			end
         `AND:begin
				ALUo <= oper1 & oper2;
				cf_out <= cf_in;
			end
         `OR:begin
				ALUo <= oper1 | oper2;
				cf_out <= cf_in;
			end
         `XOR:begin
				ALUo <= oper1 ^ oper2;
				cf_out <= cf_in;
			end
			`BZ,`BNZ,`BN,`BNN,`BC,`BNC,`LOAD,`STORE,`JMPR:begin 
				ALUo <= oper1 + oper2;
				cf_out <= cf_in; 
			end
			`JUMP,`MOV:begin
				cf_out <= cf_in;
				ALUo <= oper2;
			end
         `SLL:begin 
				ALUo <= oper1 << oper2;
				cf_out <= cf_in;
			end
         `SRL:begin
				ALUo <= oper1 >> oper2;
				cf_out <= cf_in; 
			end
         `SRA:begin 
				ALUo <= (oper1 >> oper2) | ((oper1[15])?(~(16'hFFFF >> oper2)):16'h0000);
				cf_out <= cf_in;
			end
			default:begin 
				cf_out <= cf_in;
				ALUo <= ALUi;
			end
		endcase
	end

endmodule
