// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper (clk, out, a1, a2, a3, a4, b1, b2, b3, b4, c);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] a1;
input  [bw-1:0] a2;
input  [bw-1:0] a3;
input  [bw-1:0] a4;
input  [bw-1:0] b1;
input  [bw-1:0] b2;
input  [bw-1:0] b3;
input  [bw-1:0] b4;
input  [psum_bw-1:0] c;
input  clk;

reg    [bw-1:0] a1_q;
reg    [bw-1:0] a2_q;
reg    [bw-1:0] a3_q;
reg    [bw-1:0] a4_q;

reg    signed [bw-1:0] b1_q;
reg    signed [bw-1:0] b2_q;
reg    signed [bw-1:0] b3_q;
reg    signed [bw-1:0] b4_q;

reg    [psum_bw-1:0] c_q;

wire   signed [psum_bw-1:0] out1;
wire   signed [psum_bw-1:0] out2;
wire   signed [psum_bw-1:0] out3;
wire   signed [psum_bw-1:0] out4;

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance_1 (
        .a(a1_q), 
        .b(b1_q),
        .c(c_q),
	.out(out1)
);

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance_2 (
        .a(a2_q), 
        .b(b2_q),
        .c(out1),
	.out(out2)
); 

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance_3 (
        .a(a3_q), 
        .b(b3_q),
        .c({psum_bw{1'b0}}),
	.out(out3)
);

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance_4 (
        .a(a4_q), 
        .b(b4_q),
        .c(out3),
	.out(out4)
); 

assign out = out2 + out4;

always @ (posedge clk) begin
        b1_q  <= b1;
        b2_q  <= b2;
        b3_q  <= b3;
        b4_q  <= b4;

        a1_q  <= a1;
        a2_q  <= a2;
        a3_q  <= a3;
        a4_q  <= a4;

        c_q  <= c;
end

endmodule
