// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;

assign out = psum_q;

// Your code goes here

always @(posedge clk) begin
    if (reset) begin
        psum_q <= 1'b0;
        a_q <= 1'b0;
        b_q <= 1'b0;
    end
    else begin
        a_q <= A;
        b_q <= B;
        if (format) begin
            // Handle sign + magnitude
            if (a_q[bw-1] ^ b_q[bw-1] ^ psum_q[psum_bw-1]) begin
                // Handle different signs
                if (psum_q[psum_bw-2:0] > (a_q[bw-2:0] * b_q[bw-2:0])) begin
                    psum_q[psum_bw-1] <= psum_q[psum_bw-1];
                    psum_q[psum_bw-2:0] <= psum_q[psum_bw-2:0] - (a_q[bw-2:0] * b_q[bw-2:0]);
                end
                else begin
                    psum_q[psum_bw-1] <= a_q[bw-1] ^ b_q[bw-1];
                    psum_q[psum_bw-2:0] <= (a_q[bw-2:0] * b_q[bw-2:0]) - psum_q[psum_bw-2:0];
                end
            end
            else begin
                // Handle same sign
                psum_q[psum_bw-1] <= psum_q[psum_bw-1];
                psum_q[psum_bw-2:0] <= psum_q[psum_bw-2:0] + (a_q[bw-2:0] * b_q[bw-2:0]);
            end
        end
        else begin
            // Handle 2's complement
            psum_q <= psum_q + a_q * b_q;
        end
    end
end


endmodule
