module FIFO_control(write_ptr,read_ptr,stack_full,stack_empty,write_to_stack,read_from_stack,clk,rst);
 parameter stack_width=8,stack_height=8,stack_ptr_width=3;
 output stack_full; //堆栈满标志
 output stack_empty; //堆栈空标志
 output [stack_ptr_width-1:0] read_ptr; //读数据地址
 output [stack_ptr_width-1:0] write_ptr; //写数据地址
 input write_to_stack;  //数据写入堆栈
 input read_from_stack; //数据从堆栈中读出
 input clk;
 input rst;
 reg [stack_ptr_width-1:0] read_ptr;
 reg [stack_ptr_width-1:0] write_ptr;
 reg [stack_ptr_width:0] ptr_gap;
 reg [stack_ptr_width-1:0] data_out;
 reg [stack_width-1:0] stack [stack_height-1:0]; 
 
 //栈状态信号
 assign stack_full=(ptr_gap==stack_height);
 assign stack_empty=(ptr_gap==0);
 
 always@(posedge clk or posedge rst)
  if(rst)
   begin
    data_out<=0;
	read_ptr<=0;
	write_ptr<=0;
	ptr_gap<=0;
   end
  else if (write_to_stack&&(!stack_full)&&(!read_from_stack))  //栈未满 且为写模式
   begin
    write_ptr<=write_ptr+1;
	ptr_gap<=ptr_gap+1; //写入地址加一，标志地址加一
   end
  else if (!write_to_stack&&(!stack_empty)&&(read_from_stack))  //栈不为空 且为读模式
   begin
    read_ptr<=read_ptr+1;
	ptr_gap<=ptr_gap-1; //读入地址加一，标志地址减一
   end
  else if (write_to_stack&&(stack_empty)&&(read_from_stack))  //栈空的 且读写都有效，则先写
   begin
    write_ptr<=write_ptr+1;
	ptr_gap<=ptr_gap+1; //写入地址加一，标志地址加一
   end
  else if (write_to_stack&&(stack_full)&&(read_from_stack))  //栈满 且读写都有效，则读
   begin
    read_ptr<=read_ptr+1;
	ptr_gap<=ptr_gap-1; //读地址加一，标志地址减一
   end
  else if (write_to_stack&&(!stack_full)&&(read_from_stack)&&(!stack_empty))  //栈未满未空 写模式读模式均有效，则读写同时
   begin
    write_ptr<=write_ptr+1;
	read_ptr<=read_ptr+1; //写入地址加一，读地址加一，标志不变
   end   
endmodule