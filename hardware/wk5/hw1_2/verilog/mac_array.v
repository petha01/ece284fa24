// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_array (clk, reset, out_s, in_w, in_n, inst_w, valid);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;
  parameter row = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s;
  input  [row*bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;
  output [col-1:0] valid;

  wire [(row+1)*2-1:0] sum_wire;
  wire [row*bw-1:0]    in_wire;
  wire [col*row-1:0]   valid_wire;

  reg [2*row-1: 0] ins;

  assign sum_wire[psum_bw-1:0] = in_n;
  assign in_wire = in_w;
  assign out_s = sum_wire[psum_bw*col*(row+1)-1:psum_bw*col*row];
  assign valid = valid_wire[col*row-1:col*(row-1)];

  genvar i;
  for (i=1; i < row+1 ; i=i+1) begin : row_num
      mac_row #(.bw(bw), .psum_bw(psum_bw)) mac_row_instance (
      .clk(clk),
      .reset(reset),
      .in_w(in_wire[bw*i-1:bw*(i-1)]),
      .in_n(sum_wire[psum_bw*col*i-1:psum_bw*col*(i-1)]),
      .out_s(sum_wire[psum_bw*col*(i+1)-1:psum_bw*col*i]),
      .valid(valid_wire[col*i-1:col*(i-1)]),
      .inst_w(ins[2*i-1:2*(i-1)])
      );
  end

  always @ (posedge clk) begin
    if (reset) begin
      ins = 0;
    end
    else begin
      ins[1:0] <= inst_w;
      ins[2*row-1: 2] <= ins[2*(row-1)-1: 0];
    end

   // inst_w flows to row0 to row7
 
  end



endmodule
