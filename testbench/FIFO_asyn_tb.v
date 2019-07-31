//testbench for FIFO_syn
`timescale 1ns/1ns
module FIFO_asyn_tb();
 
 reg wr;
 reg rd;
 reg wr_clk;
 reg rd_clk;
 reg rst;
 reg[7:0] Din;
 wire[7:0] Dout;
 wire full;
 wire empty;
 FIFO_syn U1(wr,rd,wr_clk,rd_clk,rst,Din,Dout,full,empty);
 
 always
  #5 wr_clk=~wr_clk;
 always
  #8 rd_clk=~rd_clk;
  
 initial 
  begin
   wr_clk=1;
   rd_clk=1;
   rst=1;
   rd=0;
   #2 rst=0;
   #4 rst=1;
   #190 rd=1;
        wr=0;
  end
  
  initial
   begin
    #10 wr=1;
	    Din=8'd0;
	#10 Din=8'd1;
	#10 Din=8'd2;
	#10 Din=8'd3;
	#10 Din=8'd4;
	#10 Din=8'd5;
	#10 Din=8'd6;
	#10 Din=8'd7;
	#10 Din=8'd8;
	#10 Din=8'd9;
	#10 Din=8'd10;
	#10 Din=8'd11;
	#10 Din=8'd12;
	#10 Din=8'd13;
	#10 Din=8'd14;
	#10 Din=8'd15;
   end
 
 endmodule