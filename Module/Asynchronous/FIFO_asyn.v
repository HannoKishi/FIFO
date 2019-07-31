module FIFO_asyn(wr,rd,wr_clk,rd_clk,rst,Din,Dout,full,empty);
 input wr;
 input rd;
 input wr_clk;
 input rd_clk;
 input rst;
 input[7:0] Din;
 output[7:0] Dout;
 output full;
 output empty;
 
 reg full;
 reg empty;
 reg[7:0] Dout;
 
 reg[7:0] mem[15:0];                        //双端口ram 8位宽8深度
 reg[4:0] wr_addr_bin;                     //多一位地址
 reg[4:0] rd_addr_bin;                     //
 
 //同步使用的格雷码缓存，跨时钟 需要两个DFF做缓存采样
 reg[4:0] syn_wr_addr0_gray;
 reg[4:0] syn_wr_addr1_gray;
 reg[4:0] syn_wr_addr2_gray;
 reg[4:0] syn_rd_addr0_gray;
 reg[4:0] syn_rd_addr1_gray;
 reg[4:0] syn_rd_addr2_gray;
 
 //
 wire[3:0] fifo_enter_addr;
 wire[3:0] fifo_exit_addr;
 wire[4:0] wr_nextaddr_bin;
 wire[4:0] rd_nextaddr_bin;
 wire[4:0] wr_nextaddr_gray;
 wire[4:0] rd_nextaddr_gray;
 
 //满空标志
 wire asyn_full;
 wire asyn_empty;
 
 assign fifo_enter_addr=wr_addr_bin[3:0];
 assign fifo_exit_addr=rd_addr_bin[3:0];
 
 //fifo读写随各自周期同步输出
 always@(posedge wr_clk )
  begin
   if(wr&(~full))
    mem[fifo_enter_addr]<=Din;
   else
    mem[fifo_enter_addr]<=mem[fifo_enter_addr];
  end
  always@(posedge rd_clk)
   begin 
    if(rd&(~empty))
	 Dout<=mem[fifo_exit_addr];
	else
	 Dout<=0;
   end
  
  //fifo读写下个地址生成
  assign wr_nextaddr_bin=(wr&(~full))?wr_addr_bin[4:0]+1:wr_addr_bin[4:0];
  assign rd_nextaddr_bin=(rd&(~empty))?rd_addr_bin[4:0]+1:rd_addr_bin[4:0];
  //地址改格雷码
  assign wr_nextaddr_gray=(wr_nextaddr_bin>>1)^(wr_nextaddr_bin);
  assign rd_nextaddr_gray=(rd_nextaddr_bin>>1)^(rd_nextaddr_bin);
  
  //下一个地址赋值
  always@(posedge wr_clk or negedge rst)
   begin
    if(!rst)
	 begin
	  wr_addr_bin<=0;
	  syn_wr_addr0_gray<=0;
	 end
	else
	 begin
	  wr_addr_bin<=wr_nextaddr_bin;
	  syn_wr_addr0_gray<=wr_nextaddr_gray;
	 end
   end
   
   always@(posedge rd_clk or negedge rst)
    begin
	 if(!rst)
	  begin
	   rd_addr_bin<=0;
	   syn_rd_addr0_gray<=0;
	  end
	 else
	  begin
	   rd_addr_bin<=rd_nextaddr_bin;
	   syn_rd_addr0_gray<=rd_nextaddr_gray;
	  end
	end

  //读地址格雷码同步到wr_clk //同理 写地址格雷码同步到rd_clk
  always@(posedge wr_clk or negedge rst)
   if(!rst)
    begin
	 syn_rd_addr1_gray<=0;
	 syn_rd_addr2_gray<=0;
	end
   else
    begin
	 syn_rd_addr1_gray<=syn_rd_addr0_gray;
	 syn_rd_addr2_gray<=syn_rd_addr1_gray;
	end
	
  always@(posedge rd_clk or negedge rst)
   if(!rst)
    begin
	 syn_wr_addr1_gray<=0;
	 syn_wr_addr2_gray<=0;
	end
   else
    begin
	 syn_wr_addr1_gray<=syn_wr_addr0_gray;
	 syn_wr_addr2_gray<=syn_wr_addr1_gray;
	end

  //判断 full 与 empty
  assign asyn_empty=(rd_nextaddr_gray==syn_wr_addr2_gray);
  assign asyn_full=(wr_nextaddr_gray=={~syn_rd_addr2_gray[4:3],syn_rd_addr2_gray[2:0]});
  
  always@(posedge wr_clk or negedge rst)
   if(!rst)
    full<=0;
   else
    full<=asyn_full;
	
  always@(posedge rd_clk or negedge rst)
   if(!rst)
    empty<=0;
   else
    empty<=asyn_empty;
	
endmodule
	 
  
   