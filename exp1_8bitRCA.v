`timescale 1ns / 1ps

module FA(
input a,b,cin,
output sum,cout
);
assign {cout,sum} = a+b+cin;
endmodule

module exp1_8bitRCA (
input clk,
input [7:0] a,b,
output [6:0] LED_out,
output [3:0] Anode
    );
    wire [8:0] cout;
    wire [8:0] out;
    genvar i;
    generate
		for (i = 0; i <= 7; i = i + 1) begin
          FA fa(a[i], b[i], cout[i], out[i], cout[i+1]);
		end
	endgenerate
	assign out[8] = cout[8];
   Four_Digit_Seven_Segment_Driver_Optimized Displayer(clk,{4'b0000, out}, Anode,LED_out);
            
endmodule
