`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:49:23 12/29/2015 
// Design Name: 
// Module Name:    pipeline_cpu 
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
module pipeline_cpu(
		input wire clk,
		input wire [15:0]d_datain,
		input wire [15:0]i_datain,
		input wire enable,
		input wire reset,
		input wire start,
		output wire [7:0]d_addr,
		output wire [15:0]d_dataout,
		output wire d_we,
		output wire [7:0]i_addr,
		input wire [2:0]select_y,
		output wire [15:0]y
    );
	 
	 reg dw;
	 assign d_we = dw;
	 reg [15:0]regs[7:0];
	 reg [7:0]pc;
	 reg state;
	 reg next_state;
	 reg zf,cf,nf;
	 
	 assign y = regs[select_y];
	 
	 reg [15:0]id_ir;
	 reg [15:8]ex_ir;
	 reg [15:0]ex_smdr;
	 reg [15:8]mem_ir;
	 reg [15:8]wb_ir;
	 
	 reg [15:0]reg_a;
	 reg [15:0]reg_b;
	 reg [15:0]reg_c;
	 
	 always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= `idle;
		end else begin
			state <= next_state;
		end
	 end
	 
	 always @(*) begin
		if (reset) begin
			next_state <= `idle;
		end else begin
			case(state)
				`idle:begin
					if (enable&&start) next_state <= `exec;
					else next_state <= `idle;
				end
				`exec:begin
					if (!enable||wb_ir[15:11]===`HALT) next_state <= `idle;
					else next_state <= `exec;
				end
			endcase
		end
	 end
	 
	 reg jmp_flag;
	 //IF
	 always @(posedge clk or posedge reset) begin
		if (reset) begin
			pc <= 0;
			id_ir <= 0;
			jmp_flag <= 0;
		end else begin
			if (state === `exec) begin
				if (jmp_flag) begin
					id_ir <= 0;
				end else begin
					if (id_ir[15:11]!=`LOAD)
						id_ir <= i_datain;
					else id_ir <= 0;
				end
				if (!jmp_flag&&
					((i_datain[15:11]===`BZ)||
					 (i_datain[15:11]===`BNZ)||
					 (i_datain[15:11]===`BN)||
					 (i_datain[15:11]===`BNN)||
					 (i_datain[15:11]===`BC)||
					 (i_datain[15:11]===`BNC)||
					 i_datain[15:11]===`JMPR||
					 i_datain[15:11]===`JUMP)) begin
					jmp_flag <= 1;
				end else if ((mem_ir[15:11]===`BZ)||
								 (mem_ir[15:11]===`BNZ)||
								 (mem_ir[15:11]===`BN)||
								 (mem_ir[15:11]===`BNN)||
								 (mem_ir[15:11]===`BC)||
								 (mem_ir[15:11]===`BNC)||
								 mem_ir[15:11]===`JMPR||
								 mem_ir[15:11]===`JUMP) begin
					jmp_flag <= 0;
				end
				if ((mem_ir[15:11]===`BZ&&zf)||
					 (mem_ir[15:11]===`BNZ&&!zf)||
					 (mem_ir[15:11]===`BN&&nf)||
					 (mem_ir[15:11]===`BNN&&!nf)||
					 (mem_ir[15:11]===`BC&&cf)||
					 (mem_ir[15:11]===`BNC&&!cf)||
					 mem_ir[15:11]===`JMPR||
					 mem_ir[15:11]===`JUMP)
					 begin
					pc <= reg_c[7:0];
				end else if ((mem_ir[15:11]===`BZ&&!zf)||
								 (mem_ir[15:11]===`BNZ&&zf)||
								 (mem_ir[15:11]===`BN&&!nf)||
								 (mem_ir[15:11]===`BNN&&nf)||
								 (mem_ir[15:11]===`BC&&!cf)||
								 (mem_ir[15:11]===`BNC&&cf)) begin
					pc <= pc - 2'b10;
				end else begin
					if (id_ir[15:11]!=`LOAD)
						pc <= pc + 1'b1;
				end
			end
		end
	 end
	 
	 assign i_addr = pc;
	 
	 //ID
	 always @(posedge clk or posedge reset) begin
		if (reset) begin
			ex_ir <= 0;
			ex_smdr <= 0;
			reg_a <= 0;
			reg_b <= 0;
		end else begin
			if (state === `exec) begin
				ex_ir <= id_ir[15:8];
				if (id_ir[15:11]===`BZ||
					 id_ir[15:11]===`BNZ||
					 id_ir[15:11]===`BN||
					 id_ir[15:11]===`BNN||
					 id_ir[15:11]===`BC||
					 id_ir[15:11]===`BNC||
					 id_ir[15:11]===`JMPR||
					 id_ir[15:11]===`ADDI||
					 id_ir[15:11]===`LDIH||
					 id_ir[15:11]===`SUBI) begin
					 if (id_ir[10:8]===ex_ir[10:8]&&ex_ir[15:11]!=`STORE&&ex_ir[15:11]!=`NOP&&ex_ir[15:11]!=`HALT)
						reg_a <= ALUo;
					 else if (id_ir[10:8]===mem_ir[10:8]&&mem_ir[15:11]!=`STORE&&mem_ir[15:11]!=`NOP&&
							mem_ir[15:11]!=`HALT&&mem_ir[15:11]!=`LOAD)
						reg_a <= reg_c;
					 else if (id_ir[10:8]===mem_ir[10:8]&&mem_ir[15:11]===`LOAD) 
						reg_a <= d_datain;
					 else if (id_ir[10:8]===wb_ir[10:8]&&wb_ir[15:11]!=`STORE&&wb_ir[15:11]!=`NOP&&wb_ir[15:11]!=`HALT)
						reg_a <= wb_reg_c;
					 else reg_a <= regs[id_ir[10:8]];
				end else begin
					 if (id_ir[6:4]===ex_ir[10:8]&&ex_ir[15:11]!=`STORE&&ex_ir[15:11]!=`NOP&&ex_ir[15:11]!=`HALT) 
						reg_a <= ALUo;
					 else if (id_ir[6:4]===mem_ir[10:8]&&mem_ir[15:11]!=`STORE&&mem_ir[15:11]!=`NOP&&
							mem_ir[15:11]!=`HALT&&mem_ir[15:11]!=`LOAD)
						reg_a <= reg_c;
					 else if (id_ir[6:4]===mem_ir[10:8]&&mem_ir[15:11]===`LOAD)
						reg_a <= d_datain;
					 else if (id_ir[6:4]===wb_ir[10:8]&&wb_ir[15:11]!=`STORE&&wb_ir[15:11]!=`NOP&&wb_ir[15:11]!=`HALT)
						reg_a <= wb_reg_c;
					 else reg_a <= regs[id_ir[6:4]];
				end
				
				if (id_ir[15:11]===`STORE) begin
					ex_smdr <= regs[id_ir[10:8]];
					if (id_ir[10:8]===ex_ir[10:8]&&ex_ir[15:11]!=`STORE&&ex_ir[15:11]!=`NOP&&ex_ir[15:11]!=`HALT)
						ex_smdr <= ALUo;
					else if (id_ir[10:8]===mem_ir[10:8]&&mem_ir[15:11]!=`STORE&&
								mem_ir[15:11]!=`NOP&&mem_ir[15:11]!=`HALT&&mem_ir[15:11]!=`LOAD) 
						ex_smdr <= reg_c;
					else if (id_ir[10:8]===mem_ir[10:8]&&mem_ir[15:11]===`LOAD) 
						ex_smdr <= d_datain;
					else if (id_ir[10:8]===wb_ir[10:8]&&wb_ir[15:11]!=`STORE&&wb_ir[15:11]!=`NOP&&wb_ir[15:11]!=`HALT)
						ex_smdr <= wb_reg_c;
					else ex_smdr <= regs[id_ir[10:8]];
					reg_b <= id_ir[3:0];
				end else if (id_ir[15:11]===`LOAD||
								 id_ir[15:11]===`SLL||
								 id_ir[15:11]===`SRL||
								 id_ir[15:11]===`MOVR||
								 id_ir[15:11]===`NOT||
								 id_ir[15:11]===`ROR||
								 id_ir[15:11]===`ADDRI||
								 id_ir[15:11]===`SUBRI||
								 id_ir[15:11]===`SRA) begin
					reg_b <= id_ir[3:0];
				end else if (id_ir[15:11]===`BZ||
								 id_ir[15:11]===`BNZ||
								 id_ir[15:11]===`BN||
								 id_ir[15:11]===`BNN||
								 id_ir[15:11]===`BC||
								 id_ir[15:11]===`BNC||
								 id_ir[15:11]===`ADDI||
								 id_ir[15:11]===`JMPR||
								 id_ir[15:11]===`JUMP||
								 id_ir[15:11]===`MOV||
								 id_ir[15:11]===`SUBI)
								 begin
					reg_b <= id_ir[7:0];
				end else if (id_ir[15:11]===`LDIH) begin
					reg_b <= {id_ir[7:0],8'b00000000};
				end else begin
					if (id_ir[2:0]===ex_ir[10:8]&&ex_ir[15:11]!=`STORE&&ex_ir[15:11]!=`NOP&&ex_ir[15:11]!=`HALT) 
						reg_b <= ALUo;
					else if (id_ir[2:0]===mem_ir[10:8]&&mem_ir[15:11]!=`STORE&&mem_ir[15:11]!=`NOP&&
							mem_ir[15:11]!=`HALT&&mem_ir[15:11]!=`LOAD)
						reg_b <= reg_c;
					else if (id_ir[2:0]===mem_ir[10:8]&&mem_ir[15:11]===`LOAD) 
						reg_b <= d_datain;
					else if (id_ir[2:0]===wb_ir[10:8]&&wb_ir[15:11]!=`STORE&&wb_ir[15:11]!=`NOP&&wb_ir[15:11]!=`HALT)
						reg_b <= wb_reg_c;
					else reg_b <= regs[id_ir[2:0]];
				end
			end
		end
	 end
	 
	 wire [15:0]ALUo;
	 wire [15:0]ALUi;
	 wire cf_out,cf_in;
	 assign cf_in = cf;
	 assign ALUi = reg_c;
	 //EX
	 alu alu_inst(
		.oper1(reg_a),
		.oper2(reg_b),
		.oper_code(ex_ir[15:11]),
		.ALUi(ALUi),
		.cf_in(cf_in),
		.ALUo(ALUo),
		.cf_out(cf_out)
	 );
	 
	 reg [15:0]mem_smdr;
	 assign d_dataout = mem_smdr;
	 
	 always @(posedge clk or posedge reset) begin
		if (reset) begin
			mem_ir <= 0;
			zf <= 0;
			cf <= 0;
			nf <= 0;
			mem_smdr <= 0;
			dw <= 0;
			reg_c <= 0;
		end else begin
			if (state === `exec) begin
				mem_ir <= ex_ir;
				reg_c <= ALUo;
				cf <= cf_out;
				if (ex_ir[15:11]===`ADD||
					 ex_ir[15:11]===`CMP||
					 ex_ir[15:11]===`ADDC||
					 ex_ir[15:11]===`ADDI||
					 ex_ir[15:11]===`SUB||
					 ex_ir[15:11]===`SUBC||
					 ex_ir[15:11]===`SUBI||
					 ex_ir[15:11]===`ADDRI||
					 ex_ir[15:11]===`SUBRI||
					 ex_ir[15:11]===`LDIH) begin
					zf <= (ALUo===0)?1'b1:1'b0;
					nf <= ALUo[15];
				end
				if (ex_ir[15:11]===`STORE) begin
					dw <= 1'b1;
					mem_smdr <= ex_smdr;
 				end else begin
					dw <= 1'b0;
				end
			end
		end
	 end
	 
	 reg [15:0]wb_reg_c;
	 
	 //MEM
	 always @(posedge clk or posedge reset) begin
		if (reset) begin
			wb_ir <= 0;
			wb_reg_c <= 0;
		end else begin
			if (state===`exec) begin
				wb_ir <= mem_ir;
				if (mem_ir[15:11]===`LOAD) begin
					wb_reg_c <= d_datain;
				end else begin
					wb_reg_c <= reg_c;
				end
			end
		end
	 end
	 
	 assign d_addr = reg_c[7:0];
	 
	 //WB
	 always @(posedge clk or posedge reset) begin
		if (reset) begin
			regs[0] <= 0;
			regs[1] <= 0;
			regs[2] <= 0;
			regs[3] <= 0;
			regs[4] <= 0;
			regs[5] <= 0;
			regs[6] <= 0;
			regs[7] <= 0;
		end else begin
			if (state===`exec) begin
				if (wb_ir[15:11]===`LOAD||
					 wb_ir[15:11]===`ADD||
					 wb_ir[15:11]===`ADDC||
					 wb_ir[15:11]===`ADDI||
					 wb_ir[15:11]===`SUB||
					 wb_ir[15:11]===`SUBC||
					 wb_ir[15:11]===`SUBI||
					 wb_ir[15:11]===`SLL||
					 wb_ir[15:11]===`SRL||
					 wb_ir[15:11]===`MOV||
					 wb_ir[15:11]===`SRA||
					 wb_ir[15:11]===`XOR||
					 wb_ir[15:11]===`MOVR||
					 wb_ir[15:11]===`NOT||
					 wb_ir[15:11]===`ROR||
					 wb_ir[15:11]===`ADDRI||
					 wb_ir[15:11]===`SUBRI||
					 wb_ir[15:11]===`OR||
					 wb_ir[15:11]===`AND||
					 wb_ir[15:11]===`LDIH) begin
					regs[wb_ir[10:8]] <= wb_reg_c;
				end
			end
		end
	 end

endmodule
