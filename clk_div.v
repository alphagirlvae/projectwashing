`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 11:31:41
// Design Name: 
// Module Name: clk_div
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

module clk_div(clk,clk_sec,clk_KHZ,clk_buzzer);
input  wire clk;
output reg  clk_KHZ=0;//数码管显示分频
output reg  clk_sec=0;  //剩余时间更新分频
output reg  clk_buzzer=0;  //蜂鸣分频
reg   [35:0]counter1,counter2,counter3;
    always@(posedge clk)      
    begin   
    if(counter1>=9999)   begin    
    counter1=0;
    clk_KHZ=~clk_KHZ;    
      end
    else  counter1=counter1+1;
    end
    
    always@(posedge clk)
    begin   
    if(counter2>=49999999)   begin
    counter2=0;
    clk_sec=~clk_sec;
      end
    else  counter2=counter2+1;
    end
    
     always@(posedge clk)      
       begin   
       if(counter3>=125_000_000)   begin    
       counter3=0;
       clk_buzzer=~clk_buzzer;    
         end
       else  counter3=counter3+1;
       end
endmodule

