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
water_level=2;  //ˮλ��ʼ״̬Ĭ��Ϊ2kg
end
 always@(posedge water_select or posedge if_finish )    //ʵ��ˮλ������ģ��
   begin
   if(reset==0||if_finish==1)        
   water_level=2;           //���µ�Դ����ϴ�����֮��ˮλĬ��Ϊ2
   else   begin
   if(power_led&&~start_led)   begin     
   if(water_level>=5)    //ģ4������ʵ��ˮλ��2-5�仯
   water_level=2;
   else water_level=water_level+1; 
     end
    end
   end  
endmodule


