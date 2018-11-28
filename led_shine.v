`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 11:33:22
// Design Name: 
// Module Name: led_shine
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

module led_shine(clk,clk_KHZ,reset,if_finish,counter_power,water_level,time_now,power_off,time_all,state,count);
 input wire clk;
 input  wire clk_KHZ;
 input wire  power_off,if_finish,reset;
 input wire [3:0]counter_power;    //自动断电计数器
 input  wire [3:0]water_level; 
 input  wire [5:0]time_now,time_all;
 output reg [7:0] state;
 output reg [7:0] count;

   reg [2:0] which;   
   reg [3:0] num[7:0];  
   wire  [7:0] yimahou[7:0];

  initial begin
  which=0;
  state<=8'b11111111;
  count<=8'b00000000;
  num[0]=water_level%10;
  num[1]=water_level/10;
  num[2]=10;
  num[3]=time_now%10;
  num[4]=time_now/10;
  num[5]=10;
  num[6]=time_all%10;
  num[7]=time_all/10;
  end
    bin27seg  L1(num[0],yimahou[0]);
    bin27seg  L2(num[1],yimahou[1]);
    bin27seg  L3(num[2],yimahou[2]);
    bin27seg  L4(num[3],yimahou[3]);
    bin27seg  L5(num[4],yimahou[4]);
    bin27seg  L6(num[5],yimahou[5]);
    bin27seg  L7(num[6],yimahou[6]);
    bin27seg  L8(num[7],yimahou[7]);
  always @(posedge clk_KHZ)
    which<=(which+1)%8;
   
   always @(posedge clk_KHZ)
    begin
    if(power_off==1||reset==0)   //自动断电或者电源键关闭，不亮
      state<=8'b11111111;
      else begin
       case(which)
              3'b000: begin
              state =8'b11111110;
              count =yimahou[0];
               end
              3'b001: begin
              state =8'b11111101;
              count=yimahou[1];
              end
              3'b010: begin
              state =8'b11111011;
              count=yimahou[2];
              end
              3'b011:begin
               state =8'b11110111;
               count=yimahou[3];
               end
              3'b100: begin
              state =8'b11101111;
              count=yimahou[4];
              end
              3'b101:begin
               state =8'b11011111;
               count=yimahou[5];
               end
              3'b110: begin
              state =8'b10111111;
              count=yimahou[6];
              end
              3'b111:begin
              state =8'b01111111;
              count=yimahou[7];
              end
            endcase
          end
          end 
  always@(posedge clk_KHZ)   begin
  if(if_finish==1)begin
    num[0]=10;
      num[1]=10;
      num[2]=10;
      num[3]=10;
      num[4]=10;
      num[5]=10;
      num[6]=counter_power;
      num[7]=counter_power/10;
      end
      else begin
      num[0]=water_level%10;
      num[1]=water_level/10;
      num[2]=10;
      num[3]=time_now%10;
      num[4]=time_now/10;
      num[5]=10;
      num[6]=time_all%10;
      num[7]=time_all/10;
    end
      end
endmodule