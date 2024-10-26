// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

input  [bw-1:0] a;
input  signed [bw-1:0] b;
input  signed [psum_bw-1:0] c;
output [psum_bw-1:0] out;

wire [psum_bw-1:0] product;

assign product = $signed(a)*b;
assign out = product + c;

endmodule
