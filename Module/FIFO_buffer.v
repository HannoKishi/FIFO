module FIFO_buffer(clk,rst,write_to_stack,read_from_stack,Data_in,Data_out);
 input clk,rst;
 input write_to_stack,read_from_stack;
 input [7:0]Data_in;
 input [7:0] Data_out;
 wire[7:0] Data_out;
 wire stack_full,stack_empty;
 wire [2:0] addr_in,addr_out;
 FIFO_control U1(addr_in,addr_out,stack_full,stack_empty,write_to_stack,read_from_stack,clk,rst);
 ram_dual U2(Data_out,addr_in,addr_out,Data_in,write_to_stack,read_from_stack,clk,clk);
endmodule