`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 11:26:34
// Design Name: 
// Module Name: washing_machine
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


module Washing_machine(clk,reset,start_pause,module_select,water_select,power_led,start_led,
wash_led,rinse_led,dry_led,in_led,out_led,state,count,buzzer_led,water_level,model_now,time_now,time_all,power_off,if_finish);

  input wire clk,reset,start_pause,module_select,water_select;// clk：100Mhz时钟,reset：电源开关,start_pause：启动、暂停开关,
  //module_select：模式选择按钮,water_select：水位选择按钮；
  output wire wash_led,rinse_led,dry_led,in_led,out_led,buzzer_led;//wash_led：洗涤指示灯,rinse_led：漂洗指示灯,dry_led：脱水指示灯，
  //buzzer_led:蜂鸣指示灯，, 
  output reg power_led,start_led;    //start_led：启动、暂停指示灯，power_led：电源指示灯
  output wire [7:0] state,count;      //state选择数码管的显示，count数码管显示数字的段位码
  output wire [3:0]water_level;   //water_level：水位
  output wire [2:0]model_now;   ////model_now:当前模式
  // time_now:当前模式剩余时间，time_all:总剩余时间
  output wire [5:0]time_all;
  output wire [5:0]time_now;
  output reg  if_finish,power_off;    // power_off:断电标识 ,if_finish：洗衣结束标识
         reg  [3:0] counter_power;    //自动断电计数器
         wire clk_sec,clk_KHZ,clk_buzzer;      //clk_sec：1HZ时钟频率时钟信号，clk_KHZ：1KHZ时钟频率时钟信号,clk_buzzer:四分之一秒级时钟信号用于蜂鸣
 initial begin
    if_finish=0;
    power_off=0;
    power_led=0;
    counter_power=0;
    end
   water_in  model1(reset,power_led,start_led,water_select,if_finish,water_level);      //进水模块
   Select_module model2(reset,power_led,start_pause,module_select,if_finish,model_now ); //模式选择模块
   Show_time model3(reset,clk,clk_sec,power_led,module_select,water_select,model_now,start_led,if_finish,water_level,time_now,time_all);
  //显示总剩余时间和当前模式剩余时间
  clk_div   model5(clk,clk_sec,clk,clk_buzzer);   //分频模块
   led_control  model6(reset,clk_sec,power_led,water_level,model_now,module_select,start_led,if_finish,wash_led,rinse_led,dry_led,in_led,out_led,time_now,time_all );
  //控制各指示灯闪亮模块
   led_shine  model7(clk,clk_KHZ,reset,if_finish,counter_power,water_level,time_now,power_off,time_all,state,count);
   //
  buzzer_led  model8(clk,buzzer_clk,reset,start_pause,module_select,water_select,buzzer_led );
  
    always@(*)    begin     //控制启动、暂停指示灯
      if(power_led==1&&if_finish==0&&start_pause==1)  //当电源指示灯亮且洗衣正在进行时，拨动启动、暂停按钮，启动、暂停指示灯亮
        begin 
         start_led=1;
         end
       else
         start_led=0;
      end    
      always@(reset or power_off) 
       begin
       if(reset==1&& power_off==0)//当电源开关关闭且未自动断电，电源指示灯亮
          power_led=1;
          else
          power_led=0;
       end
       
        always @(posedge clk)  
           begin
           if(time_all==0) //总剩余时间为0时洗衣结束标识为1
           if_finish=1;
       end     
        
         always @(posedge clk_sec)  begin    //自动断电
              if(if_finish==1) begin
              if(counter_power>=9)begin  //计数10s
                 power_off<=1;
              //  #100000000 power_off<=0;
                 end
              else
                 counter_power=counter_power+1;
              end    
              else power_off=0;
            end      
endmodule
