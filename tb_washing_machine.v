`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/21 14:37:38
// Design Name: 
// Module Name: tb_washing_machine
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


module tb_washing_machine();
reg   clk,reset,start_pause,module_select,water_select;
    wire   in_led,out_led;
    wire  start_led,power_led,wash_led,rinse_led,dry_led;
    wire [3:0] water_level;
    wire [2:0] model_now;
    wire [5:0] time_now;   
    wire [5:0] time_all;      
    wire power_off;
    wire if_finish;  
     Washing_machine tb (clk,reset,start_pause,module_select,water_select,power_led,start_led,
    wash_led,rinse_led,dry_led,in_led,out_led,state,count,buzzer_led,
    water_level,model_now,time_now,time_all,power_off,if_finish);
   initial    begin
        clk <= 1;
             end   
       initial    begin
          reset <= 1;
          start_pause <= 0;
          water_select <= 0;
          module_select <= 0;        
          #(5) start_pause <= 1;  
          end    
          always  begin
          #(5) clk <= ~clk;
          end 
endmodule
