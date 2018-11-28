`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 11:28:18
// Design Name: 
// Module Name: water_in
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


module water_in(reset,power_led,start_led,water_select,if_finish,water_level);
input wire reset,power_led,start_led,water_select,if_finish;
output reg [3:0] water_level;
initial begin
water_level=2;  //水位初始状态默认为2kg
end
 always@(posedge water_select or posedge if_finish )    //实现水位传感器模块
   begin
   if(reset==0||if_finish==1)        
   water_level=2;           //按下电源键或洗衣完成之后水位默认为2
   else   begin
   if(power_led&&~start_led)   begin     
   if(water_level>=5)    //模4计数器实现水位从2-5变化
   water_level=2;
   else water_level=water_level+1; 
     end
    end
   end  
endmodule


