`timescale 1ns / 1ps

module FA(
    input a, b, cin,
    output sum, cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module exp3_signed_Add (
    input clk,
    input [7:0] a, b,
    output [6:0] LED_out,
    output [3:0] Anode
);
    wire [8:0] cout;    
    wire [7:0] out;     
    wire [7:0] a_neg, b_neg;
    wire sign_out;
    wire overflow;
    
    assign a_neg = (a[7] == 1) ? (~a + 1) : a;  
    assign b_neg = (b[7] == 1) ? (~b + 1) : b;  
    assign sign_out = (a[6:0] > b[6:0] && a[7]==1 && b[7]==0)? 1:
            (b[6:0] > a[6:0] && b[7]==1 && a[7]==0)? 1:
            (a[7] == 1 && b[7]==1)? 1:0;
   
    genvar i;
    generate
        for (i = 0; i <= 6; i = i + 1) begin
            FA fa(a_neg[i], b_neg[i], cout[i], out[i], cout[i+1]);
        end
    endgenerate

    assign out[7] = sign_out;  
    assign overflow = (a[7] == b[7]) && (out[7] != a[7]);

    exp2_negative_7seg (clk, {4'b00000, out}, Anode, LED_out);

endmodule
