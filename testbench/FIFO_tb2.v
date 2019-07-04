`timescale 1ns/1ns
module FIFO_tb2;
 reg clk,rst;
 reg[7:0] Data_in;
 reg write_to_stack,read_from_stack;
 wire [7:0] Data_out;
 FIFO_buffer U1(clk,rst,write_to_stack,read_from_stack,Data_in,Data_out);
 initial
  begin
   clk=0;
   rst=1;
   Data_in=0;
   write_to_stack=1;
   read_from_stack=0;
   #5 rst=0;
   //#155 write_to_stack=0; 
   #135 read_from_stack=1;
  end
 initial
  begin
   repeat(15)
   #20 Data_in=Data_in+1;
  end
 always #10 clk=~clk;
endmodule
  