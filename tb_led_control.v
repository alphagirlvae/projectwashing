`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/21 15:34:25
// Design Name: 
// Module Name: tb_led_control
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


module tb_led_control();
reg clk,clk_KHZ,reset,if_finish,power_off;
reg [3:0]counter_power;
reg [3:0]water_level;
reg [5:0]time_now,time_all;
wire [7:0]state,count;
led_shine A(clk,clk_KHZ,reset,if_finish,
counter_power,water_level,time_now,power_off,time_all,state,count);
initial begin
clk<=0;
clk_KHZ<=0;
end
initial begin
   reset<=0;
   if_finish<=0;
   power_off<=0;
   counter_power<=0;
   water_level<=2;
   time_now<=11;
   time_all<=29;
   #(5)  reset<=1;

   end
    always  begin
             #(5) clk <= ~clk;
             clk_KHZ<=~clk_KHZ;
     end    
endmodule

