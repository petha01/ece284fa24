// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_row (clk, out_s, in_w, in_n, valid, inst_w, reset);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s;
  output [col-1:0] valid;
  input  [bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;

  wire  [(col+1)*bw-1:0] ab_wire;
  wire [(col+1)*2-1:0] inst_wire;
  wire [psum_bw*col-1:0] sum_in_wire;
  wire [psum_bw*col-1:0] sum_out_wire;

  assign ab_wire[bw-1:0]   = in_w;
  assign inst_wire[bw-1:0] = inst_w;
  assign sum_in_wire[psum_bw*col-1:0] = in_n;
  assign out_s = sum_out_wire[psum_bw*col-1:0];
  assign valid = {inst_wire[17], inst_wire[15], inst_wire[13], inst_wire[11], inst_wire[9], inst_wire[7], inst_wire[5], inst_wire[3]};

  genvar i;
  for (i=1; i < col+1 ; i=i+1) begin : col_num
      mac_tile #(.bw(bw), .psum_bw(psum_bw)) mac_tile_instance (
         .clk(clk),
         .reset(reset),
	 .in_w( ab_wire[bw*i-1:bw*(i-1)]),
	 .out_e(ab_wire[bw*(i+1)-1:bw*i]),
	 .inst_w(inst_wire[2*i-1:2*(i-1)]),
	 .inst_e(inst_wire[2*(i+1)-1:2*i]),
	 .in_n(sum_in_wire[bw*i-1:bw*(i-1)]),
	 .out_s(sum_out_wire[bw*i-1:bw*(i-1)]));
  end

endmodule
