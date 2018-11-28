`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 11:36:08
// Design Name: 
// Module Name: buzzer_led
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

module buzzer_led(clk,clk_buzzer,reset,power_led,start_pause,module_select,water_select,buzzer_led );
 input wire clk,clk_buzzer,reset,power_led,start_pause,module_select,water_select;
      reg if_finish;
output reg buzzer_led;
reg [1:0] cont;   
initial begin
  buzzer_led=0;
  cont=0;
  if_finish=0;
  end
  
always @(posedge  clk_buzzer) begin
  if(reset||start_pause||module_select||water_select)  begin
     buzzer_led=1;
     end
  else begin
     if(if_finish==1)begin
        buzzer_led=1;
        cont=0;
     end
     if( buzzer_led)begin 
       cont=cont+1;
       buzzer_led=~buzzer_led;
        buzzer_led=1;
     if(cont>=3)
      buzzer_led=0;
     end
  end 
end 
endmodule

