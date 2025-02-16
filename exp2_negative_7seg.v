`timescale 1ns / 1ps

module BCD2 (
input [7:0] num,
output reg [3:0] Hundreds,
output reg [3:0] Tens,
output reg [3:0] Ones
);
    integer i;
    always @(num)
    begin
        //initialization
        
        Hundreds = 4'd0;
        Tens = 4'd0;
        Ones = 4'd0;
        for (i = 7; i >= 0 ; i = i-1 )
            begin
                if(Hundreds >= 5 )
                    Hundreds = Hundreds + 3;
                if (Tens >= 5 )
                    Tens = Tens + 3;
                if (Ones >= 5)
                    Ones = Ones +3;
             
               
                Hundreds = Hundreds << 1;
                Hundreds [0] = Tens [3];
                Tens = Tens << 1;
                Tens [0] = Ones[3];
                Ones = Ones << 1;
                Ones[0] = num[i];
        end
    end
endmodule


module exp2_negative_7seg (
input clk,
input [7:0] num,
output reg [3:0] Anode,
output reg [6:0] LED_out
);
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter = 0; // 20-bit counter
    wire [1:0] LED_activating_counter;
    
    wire neg;
    wire [3:0] Hundreds;
    wire [3:0] Tens;
    wire [3:0] Ones;
    
    assign neg = num[7];
    wire [7:0] num_neg ;
    assign num_neg = (num[7] == 1) ? ~num + 1 : num; // Handle negative numbers
     
   always @(posedge clk)
    begin
        refresh_counter <= refresh_counter + 1;
    end
    assign LED_activating_counter = refresh_counter[19:18];
    
    BCD2 bcd2(.num(num_neg[7:0]), .Hundreds(Hundreds[3:0]), .Tens(Tens[3:0]), .Ones(Ones[3:0]));

    always @(*)
    begin

        case(LED_activating_counter)
            2'b00: begin
            if(neg == 1'b0) begin
            Anode = 4'b1111;
            end
            else begin
            Anode = 4'b0111;
            LED_BCD = 4'b1111;
            end
        end
            2'b01: begin
            Anode = 4'b1011;
            LED_BCD = Hundreds;
        end
            2'b10: begin
            Anode = 4'b1101;
            LED_BCD = Tens;
        end
            2'b11: begin
            Anode = 4'b1110;
            LED_BCD = Ones;
        end
    endcase
    end
    always @(*)
        begin
            case(LED_BCD)
                4'b0000: LED_out = 7'b0000001; // "0"
                4'b0001: LED_out = 7'b1001111; // "1"
                4'b0010: LED_out = 7'b0010010; // "2"
                4'b0011: LED_out = 7'b0000110; // "3"
                4'b0100: LED_out = 7'b1001100; // "4"
                4'b0101: LED_out = 7'b0100100; // "5"
                4'b0110: LED_out = 7'b0100000; // "6"
                4'b0111: LED_out = 7'b0001111; // "7"
                4'b1000: LED_out = 7'b0000000; // "8"
                4'b1001: LED_out = 7'b0000100; // "9"
                4'b1111: LED_out = 7'b1111110; // "-"
                default: LED_out = 7'b0000001; // "0"
        endcase
    end
endmodule

