`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 11:29:17
// Design Name: 
// Module Name: Select_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Select_module(reset,power_led,start_pause,module_select,if_finish,model_now );
input wire reset,power_led,start_pause,module_select,if_finish;
output reg [2:0] model_now;
initial begin
model_now=0;
end
always @(posedge module_select or posedge if_finish) begin   //模式选择开关和洗衣结束标识影响模式变化
   if(if_finish==1)begin
       model_now=0;       //洗衣完成默认洗漂脱模式
       end       
   else if(power_led && ~start_pause)   //电源开且暂停时模式改变
       begin
       model_now=model_now+1;
       if(model_now>=6)
       model_now=0;
       end
    end
endmodule
