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

  input wire clk,reset,start_pause,module_select,water_select;// clk��100Mhzʱ��,reset����Դ����,start_pause����������ͣ����,
  //module_select��ģʽѡ��ť,water_select��ˮλѡ��ť��
  output wire wash_led,rinse_led,dry_led,in_led,out_led,buzzer_led;//wash_led��ϴ��ָʾ��,rinse_led��Ưϴָʾ��,dry_led����ˮָʾ�ƣ�
  //buzzer_led:����ָʾ�ƣ�, 
  output reg power_led,start_led;    //start_led����������ָͣʾ�ƣ�power_led����Դָʾ��
  output wire [7:0] state,count;      //stateѡ������ܵ���ʾ��count�������ʾ���ֵĶ�λ��
  output wire [3:0]water_level;   //water_level��ˮλ
  output wire [2:0]model_now;   ////model_now:��ǰģʽ
  // time_now:��ǰģʽʣ��ʱ�䣬time_all:��ʣ��ʱ��
  output wire [5:0]time_all;
  output wire [5:0]time_now;
  output reg  if_finish,power_off;    // power_off:�ϵ��ʶ ,if_finish��ϴ�½�����ʶ
         reg  [3:0] counter_power;    //�Զ��ϵ������
         wire clk_sec,clk_KHZ,clk_buzzer;      //clk_sec��1HZʱ��Ƶ��ʱ���źţ�clk_KHZ��1KHZʱ��Ƶ��ʱ���ź�,clk_buzzer:�ķ�֮һ�뼶ʱ���ź����ڷ���
 initial begin
    if_finish=0;
    power_off=0;
    power_led=0;
    counter_power=0;
    end
   water_in  model1(reset,power_led,start_led,water_select,if_finish,water_level);      //��ˮģ��
   Select_module model2(reset,power_led,start_pause,module_select,if_finish,model_now ); //ģʽѡ��ģ��
   Show_time model3(reset,clk,clk_sec,power_led,module_select,water_select,model_now,start_led,if_finish,water_level,time_now,time_all);
  //��ʾ��ʣ��ʱ��͵�ǰģʽʣ��ʱ��
  clk_div   model5(clk,clk_sec,clk,clk_buzzer);   //��Ƶģ��
   led_control  model6(reset,clk_sec,power_led,water_level,model_now,module_select,start_led,if_finish,wash_led,rinse_led,dry_led,in_led,out_led,time_now,time_all );
  //���Ƹ�ָʾ������ģ��
   led_shine  model7(clk,clk_KHZ,reset,if_finish,counter_power,water_level,time_now,power_off,time_all,state,count);
   //
  buzzer_led  model8(clk,buzzer_clk,reset,start_pause,module_select,water_select,buzzer_led );
  
    always@(*)    begin     //������������ָͣʾ��
      if(power_led==1&&if_finish==0&&start_pause==1)  //����Դָʾ������ϴ�����ڽ���ʱ��������������ͣ��ť����������ָͣʾ����
        begin 
         start_led=1;
         end
       else
         start_led=0;
      end    
      always@(reset or power_off) 
       begin
       if(reset==1&& power_off==0)//����Դ���عر���δ�Զ��ϵ磬��Դָʾ����
          power_led=1;
          else
          power_led=0;
       end
       
        always @(posedge clk)  
           begin
           if(time_all==0) //��ʣ��ʱ��Ϊ0ʱϴ�½�����ʶΪ1
           if_finish=1;
       end     
        
         always @(posedge clk_sec)  begin    //�Զ��ϵ�
              if(if_finish==1) begin
              if(counter_power>=9)begin  //����10s
                 power_off<=1;
              //  #100000000 power_off<=0;
                 end
              else
                 counter_power=counter_power+1;
              end    
              else power_off=0;
            end      
endmodule
