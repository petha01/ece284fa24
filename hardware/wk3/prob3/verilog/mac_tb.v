// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [bw-1:0] a;
reg  [bw-1:0] b;
reg  [psum_bw-1:0] c;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x_dec[3:0];
integer w_dec[3:0];
integer i; 
integer u; 

function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction



function [3:0] x_bin ;
  input integer x;
  begin
    if (x > 7) begin
      x_bin[3] = 1;
      x = x - 8;
    end else begin
      x_bin[3] = 0;
    end

    if (x > 3) begin
      x_bin[2] = 1;
      x = x - 4;
    end else begin
      x_bin[2] = 0;
    end

    if (x > 1) begin
      x_bin[1] = 1;
      x = x - 2;
    end else begin
      x_bin[1] = 0;
    end

    if (x > 0) begin
      x_bin[0] = 1;
    end else begin
      x_bin[0] = 0;
    end
  end

endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;
  input [bw-1:0] a;
  input [bw-1:0] b;
  input [psum_bw-1:0] c;

  reg unsigned [psum_bw-1:0] a_unsigned;
  reg signed [psum_bw-1:0] b_signed;
  reg [psum_bw-1:0] product;

  begin
    a_unsigned = $unsigned(a);
    b_signed = $signed(b);

    product = a_unsigned * b_signed;
    mac_predicted = c + product;
  end

endfunction

function [psum_bw-1:0] mac_predicted_4_input;
  input [bw-1:0] a1;
  input [bw-1:0] a2;
  input [bw-1:0] a3;
  input [bw-1:0] a4;
  input [bw-1:0] w1;
  input [bw-1:0] w2;
  input [bw-1:0] w3;
  input [bw-1:0] w4;
  input [psum_bw-1:0] c;

  reg unsigned [psum_bw-1:0] a_unsigned1;
  reg unsigned [psum_bw-1:0] a_unsigned2;
  reg unsigned [psum_bw-1:0] a_unsigned3;
  reg unsigned [psum_bw-1:0] a_unsigned4;
  reg signed [psum_bw-1:0] w_signed2;
  reg signed [psum_bw-1:0] w_signed2;
  reg signed [psum_bw-1:0] w_signed2;
  reg signed [psum_bw-1:0] w_signed2;

  reg [psum_bw-1:0] product1;
  reg [psum_bw-1:0] product2;
  reg [psum_bw-1:0] product3;
  reg [psum_bw-1:0] product4;

  begin
    a_unsigned1 = $unsigned(a1);
    a_unsigned2 = $unsigned(a2);
    a_unsigned3 = $unsigned(a3);
    a_unsigned4 = $unsigned(a4);
    w_signed1 = $signed(w1);
    w_signed2 = $signed(w2);
    w_signed3 = $signed(w3);
    w_signed4 = $signed(w4);

    product1 = a_unsigned1 * w_signed1;
    product2 = a_unsigned2 * w_signed2;
    product3 = a_unsigned3 * w_signed3;
    product4 = a_unsigned4 * w_signed4;
    mac_predicted = c + product1 + product2 + product3 + product4;
  end

endfunction



mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
	.clk(clk), 
        .a1(a1), 
        .a2(a2), 
        .a3(a3), 
        .a4(a4), 
        .b1(b1),
        .b2(b2),
        .b3(b3),
        .b4(b4),
        .c(c),
	.out(out)
); 
 

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);

  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  
  for (i=0; i<5; i=i+1) begin  // 20 numbers in file. 20/4 = 5

     #1 clk = 1'b1;
     #1 clk = 1'b0;
     integer j;
     for (j = 0; j<4; j=j+1) begin
      w_scan_file = $fscanf(w_file, "%d\n", w_dec[j]);
      x_scan_file = $fscanf(x_file, "%d\n", x_dec[j]);
     end

     a1 = x_bin(x_dec[0]);
     a2 = x_bin(x_dec[1]);
     a3 = x_bin(x_dec[2]);
     a4 = x_bin(x_dec[3]);
     b1 = w_bin(w_dec[0]);
     b2 = w_bin(w_dec[1]);
     b3 = w_bin(w_dec[2]);
     b4 = w_bin(w_dec[3]);
     c = expected_out;

     expected_out = mac_predicted_4_input(a1, a2, a3, a4, b1, b2, b3, b4, c);

  end



  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule




