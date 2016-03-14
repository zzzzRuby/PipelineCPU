`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:25:40 01/02/2016
// Design Name:   top
// Module Name:   E:/Project/CPU/test.v
// Project Name:  CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg clk;
	reg reset;
	reg start;
	reg enable;

	// Instantiate the Unit Under Test (UUT)
	cpu uut (
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.enable(enable)
	);

	always #5 begin
		clk <= ~clk;
	end
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		start = 0;
		enable = 0;

		// Wait 100 ns for global reset to finish
		#100;
      reset <= 0;
		enable <= 1;
		start <= 1;
		#10 start <= 0;
		$display("pc	idir		reg_a	reg_b	reg_c	d_addr	d_dataout	d_we	wb_reg_c	r0     r1     r2     r3     r4     r5     r6     r7");
		$monitor("%d	%b	%h	%h	%h	%h	%h	%b	%h	%h   %h   %h   %h   %h   %h   %h   %h",
			uut.pcpu_inst.pc,
			uut.pcpu_inst.id_ir,
			uut.pcpu_inst.reg_a,
			uut.pcpu_inst.reg_b,
			uut.pcpu_inst.reg_c,
			uut.d_addr,uut.d_dataout,
			uut.d_we,
			uut.pcpu_inst.wb_reg_c,
			uut.pcpu_inst.regs[0],
			uut.pcpu_inst.regs[1],
			uut.pcpu_inst.regs[2],
			uut.pcpu_inst.regs[3],
			uut.pcpu_inst.regs[4],
			uut.pcpu_inst.regs[5],
			uut.pcpu_inst.regs[6],
			uut.pcpu_inst.regs[7]
			);
		#19890 $display("%d %d %d %d %d %d %d %d %d %d",
			uut.d_memory.mem[0],
			uut.d_memory.mem[1],
			uut.d_memory.mem[2],
			uut.d_memory.mem[3],
			uut.d_memory.mem[4],
			uut.d_memory.mem[5],
			uut.d_memory.mem[6],
			uut.d_memory.mem[7],
			uut.d_memory.mem[8],
			uut.d_memory.mem[9]
			);
	end
      
endmodule

