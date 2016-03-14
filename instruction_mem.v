`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:12:57 01/04/2015 
// Design Name: 
// Module Name:    instruction_mem 
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
module instruction_mem(
		input wire [7:0]addr,
		output reg [15:0]rdata
	);
	
	always@(*) begin
		case(addr)
		
	//最大公因数 最小公倍数：gcm
	0: rdata <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0001};
	1: rdata <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0010};
	2: rdata <= {`ADD, `gr3, 1'b0, `gr0, 1'b0, `gr1};//(1)
	3: rdata <= {`SUB, `gr1, 1'b0, `gr1, 1'b0, `gr2};
	4: rdata <= {`BZ, `gr0, 8'b0000_1001}; //jump to (2)
	5: rdata <= {`BNN, `gr0,  8'b0000_0010}; //jump to (1)
	6: rdata <= {`ADD, `gr1, 1'b0, `gr0, 1'b0, `gr2};
	7: rdata <= {`ADD, `gr2, 1'b0, `gr0, 1'b0, `gr3};
	8:rdata <= {`JUMP, 11'b000_0000_0010};//jump to (1)
	9:rdata <= {`STORE, `gr2, 1'b0, `gr0, 4'b0011}; //(2)
	10: rdata <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0001};
	11: rdata <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0010};
	12:rdata <= {`ADDI, `gr4, 8'h1}; //(3)
	13:rdata <= {`SUB, `gr2, 1'b0, `gr2, 1'b0, `gr3};
	14:rdata <= {`BZ, `gr0, 8'b0001_0000}; //jump to (4)
	15:rdata <= {`JUMP, 11'b000_0000_1100}; //jump to (3)
	16:rdata <= {`SUBI, `gr4, 8'h1}; //(4)
	17:rdata <= {`BN, `gr0, 8'b0001_0100}; //jump to (5)
	18:rdata <= {`ADD, `gr5, 1'b0, `gr5, 1'b0, `gr1};
	19:rdata <= {`JUMP, 11'b000_0001_0000}; //jump to (4)
	20:rdata <= {`STORE, `gr5, 1'b0, `gr0, 4'b0100}; //(5)
	21:rdata <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0011};//最大公因数
	22:rdata <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0100};//最小公倍数
	23:rdata <= {`HALT, 11'b000_0000_0000};
		
			/*0:rdata <= {`MOV, `gr0, 8'hf1};
			1:rdata <= {`ADDI, `gr1, 8'h0f};
			2:rdata <= {`ADD, `gr2, 1'b0, `gr1, 1'b1, `gr0};
			3:rdata <= {`LDIH, `gr2, 8'hff};
			4:rdata <= {`ADDC, `gr3, 1'b0, `gr1, 1'b0, `gr0};
			5:rdata <= {`BNC, `gr7, 8'd8};
			6:rdata <= {`SUB, `gr0, 1'b0, `gr0, 1'b1, `gr3};
			7:rdata <= {`BC, `gr7, 8'd9};
			8:rdata <= {`JUMP, `gr0, 8'd6};
			9:rdata <= {`SUBC, `gr0, 1'b0, `gr0, 1'b0, `gr7};
			10:rdata <= {`BZ ,`gr7, 8'd12};
			11:rdata <= {`BNZ, `gr7, 8'd14};
			12:rdata <= {`SRA, `gr0, 1'b0, `gr0, 4'd2};
			13:rdata <= {`BN, `gr7, 8'd15};
			14:rdata <= {`JMPR, `gr7, 8'd12};
			15:rdata <= {`SRL, `gr0, 1'b0, `gr0, 4'd4};
			16:rdata <= {`STORE, `gr0, 1'b1, `gr7, 4'd1};
			17:rdata <= {`LOAD, `gr4, 1'b0, `gr7, 4'd1};
			18:rdata <= {`SLL, `gr4, 1'b0, `gr4, 4'd4};
			19:rdata <= {`AND, `gr5, 1'b0, `gr4, 1'b0, `gr1};
			20:rdata <= {`SUBI, `gr4, 8'd10};
			21:rdata <= {`CMP, 4'b0000, `gr0, 1'b0, `gr4};
			22:rdata <= {`BNN, `gr7, 8'd25};
			23:rdata <= {`BNN, `gr7, 8'd24};
			24:rdata <= {`MOV, `gr0, 8'd0};
			25:rdata <= {`XOR, `gr6, 1'b1, `gr0, 1'b1, `gr1};
			26:rdata <= {`OR, `gr6, 1'b0, `gr6, 1'b1, `gr1};
			27:rdata <= {`MOVR, `gr5, 1'b0, `gr6, 4'b1010};
			28:rdata <= {`NOT, `gr5, 1'b0, `gr5, 4'b0000};
			29:rdata <= {`ADDRI, `gr5, 1'b0, `gr5, 4'b0001};
			30:rdata <= {`ROR, `gr5, 1'b0, `gr5, 4'd8};
			31:rdata <= {`SUBRI, `gr5, 1'b0, `gr5, 4'b0001};
			32:rdata <= {`NOP, 11'b00000000000};
			33:rdata <= {`HALT, 11'b00000000000};
			default:rdata <= 0;*/
			
			/*
			0:rdata <= {`ADDI,` gr3, 8'b00000001};
			1:rdata <= {`STORE, `gr3, 1'b0, `gr0, 4'd2};
			2:rdata <= {`ADDI,` gr3, 8'b00000001};
			3:rdata <= {`STORE, `gr3, 1'b0, `gr0, 4'd5};
			4:rdata <= {`ADDI,` gr3, 8'b00000001};
			5:rdata <= {`STORE, `gr3, 1'b1, `gr0, 4'd7};
			6:rdata <= {`ADDI,` gr3, 8'b00000001};
			7:rdata <= {`STORE, `gr3, 1'b0, `gr0, 4'd1};
			8:rdata <= {`ADDI,` gr3, 8'b00000001};
			9:rdata <= {`STORE, `gr3, 1'b0, `gr0, 4'd3};
			10:rdata <= {`ADDI,` gr3, 8'b00000001};
			11:rdata <= {`STORE, `gr3, 1'b0, `gr0, 4'd6};
			12:rdata <= {`ADDI,` gr3, 8'b00000001};
			13:rdata <= {`STORE, `gr3, 1'b0, `gr0, 4'd9};
			14:rdata <= {`ADDI,` gr3, 8'b00000001};
			15:rdata <= {`STORE, `gr3, 1'b0, `gr0, 4'd8};
			16:rdata <= {`ADDI,` gr3, 8'b00000001};
			17:rdata <= {`STORE, `gr3, 1'b0, `gr0, 4'd0};
			18:rdata <= {`ADDI,` gr3, 8'b00000001};
			19:rdata <= {`STORE, `gr3, 1'b0, `gr0, 4'd4};
			20:rdata <= {`CMP, 4'b0000, `gr4, 1'b0, `gr3};
			21:rdata <= {`BNN, `gr7, 8'd35};
			22:rdata <= {`MOV, `gr5, 8'd0};
			23:rdata <= {`CMP, 4'b0000, `gr5, 1'b0, `gr4};
			24:rdata <= {`BNN, `gr7, 8'd33};
			25:rdata <= {`LOAD, `gr1, 1'b0, `gr4, 4'b0000};
			26:rdata <= {`LOAD, `gr2, 1'b0, `gr5, 4'b0000};
			27:rdata <= {`CMP, 4'b0000, `gr1, 1'b0, `gr2};
			28:rdata <= {`BNN, `gr7, 8'd31};
			29:rdata <= {`STORE, `gr2, 1'b0, `gr4, 4'b0000};
			30:rdata <= {`STORE, `gr1, 1'b0, `gr5, 4'b0000};
			31:rdata <= {`ADDI, `gr5, 8'b1};
			32:rdata <= {`JUMP, `gr0, 8'd23};
			33:rdata <= {`ADDI, `gr4, 8'b1};
			34:rdata <= {`JUMP, `gr0, 8'd20};
			35:rdata <= {`HALT, 11'b00000000000};
			default:rdata <= 0;*/
			
			/*
			等价于c++
			int n = 10;
			int nums[10] = { 9,4,1,5,10,2,6,3,8,7 };
			int temp;
			for(int i = 0;i < n;i++)
			{
				for(int j = 0;j < i;j++)
				{
					if (nums[i]<nums[j])
					{
						temp = nums[i];
						nums[i] = nums[j];
						nums[j] = temp;
					}
				}
			}
			*/
		endcase
	end
	
endmodule

