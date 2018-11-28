`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/21 14:42:46
// Design Name: 
// Module Name: tb_select_model
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


module tb_select_model();
reg  reset,power_led,start_pause,module_select,if_finish;
   wire  [2:0]model_now;
   
  Select_module DUT  (reset,power_led,start_pause,module_select,if_finish,model_now);
  
   initial   begin  
   reset<=1;
   power_led<=1;
   start_pause<=0;
   module_select<=0;
   if_finish<=0;
   end
   
   always   begin
   #(5) module_select<=~module_select;
   end

endmodule
