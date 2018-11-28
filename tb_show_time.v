`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/21 14:38:30
// Design Name: 
// Module Name: tb_show_time
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


module tb_show_time();
reg reset,clk,clk_sec,power_led,module_select,water_select,start_led,if_finish;
    reg [2:0]model_now;
    reg [3:0] water_level;
    wire [5:0]time_now;
    wire [5:0]time_all;   
    Show_time T1(reset,clk,clk_sec,power_led,module_select,water_select,model_now,start_led,if_finish,water_level,time_now,time_all);
  
   always  begin
           #(5) clk <= ~clk;
           clk_sec<=~clk_sec;
   end    
    initial begin
        clk<=0;
        clk_sec<=0;
      reset <= 0;
      start_led<=0;
      power_led<=0;
      water_select <= 0;
      module_select <= 0;
      water_level<=2;
      if_finish<=0;
      model_now<=0;
      #(5)  reset<=1;
            power_led<=1;
       #(5)   start_led<=1;
    end
   
endmodule
