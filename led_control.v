`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 11:32:23
// Design Name: 
// Module Name: led_control
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

module led_control(reset,clk_sec,power_led,water_level,model_now,module_select,start_led,
if_finish,wash_led,rinse_led,dry_led,in_led,out_led,time_now,time_all );  
    input   wire   reset,clk_sec,power_led,module_select,start_led,if_finish;
    input   wire   [2:0]model_now;
    input   wire   [3:0]water_level;
    input   wire   [5:0]time_now,time_all;
    output  wire   in_led,out_led,wash_led,rinse_led,dry_led; 
            reg    [2:0]led_light,light_state;  //led_light�����ƵƵ�����,light_state�����Ƶ�����״̬��������1������������0����
            reg    water_in,water_out;  //water_in:��ˮָʾ�м����,water_out����ˮָʾ�м����
            
           initial    begin   //Ĭ��ϴ��Ư����ָʾ�Ƴ�������ˮ����ˮָʾ�Ʋ���
           led_light=3'b111;
           light_state=3'b111;
           water_in=0;
           water_out=0;
           end 
    //����ϴ�ӡ���ˮ��Ưϴ����ˮ����ˮ�ƣ������������˿��ƵƱ�ʶ��ʱ����򣬿ɻ��ָʾ�������ķ���
          assign wash_led=led_light[2]&&(clk_sec||light_state[2]||(~start_led))&&power_led;
          assign rinse_led=led_light[1]&&(clk_sec||light_state[1]||(~start_led))&&power_led;
          assign dry_led=led_light[0]&&(clk_sec||light_state[0]||(~start_led))&&power_led;
          assign in_led=water_in&&power_led&&start_led;
          assign out_led=water_out&&power_led&&start_led;
          
    //���Ʋ�ͬģʽ�½�ˮ����ˮ�ƣ�ϴ�ӡ�Ưϴ����ˮ�Ƶİ����仯������������������ź�
          always @(time_all)  
          begin
            case (model_now)
               3'b000 : begin//����ϴ�ӽ�ˮ״̬����Ưϴ��ˮ״̬
                if(time_all >= (21+water_level*3)||(time_all <=(9+water_level*2)&& time_all >= (9+water_level)))//����ϴ�ӽ�ˮ״̬����Ưϴ��ˮ״̬
                  water_in=1;
                else 
                  water_in=0;
                 //����Ưϴ��ˮ״̬������ˮ��ˮ״̬
                if( (time_all <=(12+water_level*3) && time_all >=(12+water_level*2)) || (time_all <=(3+water_level) && time_all >=3) )//����Ưϴ��ˮ״̬������ˮ��ˮ״̬
                  water_out=1;
                else
                  water_out=0;
                  //ϴ�ӽ׶Σ�ϴ�ӵ�������Ưϴ����ˮ�Ƴ���
                if (time_all >= (12+water_level*3)) 
                  begin
                  led_light = 3'b111;          
                  light_state = 3'b011;     
                  end
                else if (time_all >= (3+water_level))  //Ưϴ�׶Σ�Ưϴϴ����������ˮ�Ƴ���
                  begin 
                  led_light = 3'b011;           
                  light_state = 3'b001;
                  end
                else if (time_all >= 5'b00000)  //��ˮ�׶Σ���ˮ������
                  begin
                  led_light = 3'b001;           
                  light_state = 3'b000;        
                  end
                else               
                  begin                       
                  led_light = 3'b000;             //ϴ�ӡ�Ưϴ����ˮָʾ�ƾ�����
                  light_state = 3'b000;
                  end
                 end
    
               3'b001 : begin       //����ϴ�ӽ�ˮ״̬
                  water_out=0;
                if(time_all >= 9)         
                  water_in=1;
                else 
                   water_in=0;
                if (time_all >= 6'b000000)   //����ϴ��״̬��ϴ�ӵ�����
                   begin
                   led_light = 3'b100;
                   light_state = 3'b000;     
                   end
                else              //ϴ�ӡ�Ưϴ����ˮָʾ�ƾ�����
                 begin                      
                   led_light = 3'b000;       
                   light_state = 3'b000;
                   end
                  end
    
               3'b010 : begin//����ϴ�ӽ�ˮ״̬����Ưϴ��ˮ״̬
                if(time_all >=(18+water_level*2)|| (time_all<=(6+water_level) && time_all>=6))
                   water_in=1;
                else  
                   water_in=0;
                if(time_all<=(9+water_level*2) && time_all>=9+water_level) 
                 //����Ưϴ��ˮ״̬ 
                   water_out=1;
                else  
                   water_out=0;
                if(time_all >= (9+water_level*2))   //����ϴ��״̬��ϴ�ӵ�������Ưϴ�Ƴ���       
                   begin
                   led_light = 3'b110;
                   light_state = 3'b010;
                   end
                else if(time_all >= 6'b000000)       //����Ưϴ״̬��Ưϴ������    
                   begin
                   led_light = 3'b010;
                   light_state = 3'b000;
                   end
                 else //ϴ�ӡ�Ưϴ����ˮָʾ�ƾ�����
                   begin                               
                   led_light = 3'b000;
                   light_state = 3'b000;
                   end
                  end
    
               3'b011 : begin
                if(time_all<=(6+water_level) && time_all>=6)   //����Ưϴ��ˮ״̬
                   water_in=1;
                else 
                   water_in=0;
                if(time_all>=(9+water_level))            //����Ưϴ��ˮ״̬
                   water_out=1;
                else 
                   water_out=0; 
                if (time_all >= 6'b000000)           //����Ưϴ״̬��Ưϴ������   
                   begin
                   led_light = 3'b010;
                   light_state = 3'b000;
                   end
                else                      //ϴ�ӡ�Ưϴ����ˮָʾ�ƾ�����
                  begin                            
                  led_light = 3'b000;
                  light_state = 3'b000;
                  end
                 end
                 
               3'b100 : begin
                if (time_all<=(9+water_level*2) && time_all>=(9+water_level))  //����Ưϴ��ˮ״̬ 
                   water_in=1;
                else 
                   water_in=0;
                if (time_all>=(12+water_level*2)|| (time_all<= (3+water_level) && time_all >=3))  
                   //����Ưϴ��ˮ״̬������ˮ��ˮ״̬
                   water_out=1;
                else 
                   water_out=0;
                if (time_all>= (3+water_level))  //����Ưϴ״̬,Ưϴ����������ˮ�Ƴ���   
                   begin                                
                   led_light = 3'b011;
                   light_state = 3'b001;
                   end
                else if (time_all >= 6'b000000)    //������ˮ״̬����ˮ������   
                   begin
                   led_light = 3'b001;
                   light_state = 3'b000;
                   end
                   else
                   begin                      //ϴ�ӡ�Ưϴ����ˮָʾ�ƾ�����   
                   led_light = 3'b000;
                   light_state = 3'b000;
                   end
                  end
                  
               3'b101 : begin
                   water_in=0;                  //��ˮ�Ʋ���
                if(time_all >= 3)            //������ˮ��ˮ״̬
                   water_out=1;
                else 
                   water_out=0; 
                if (time_all >= 6'b000000)  //������ˮ״̬
                   begin
                   led_light = 3'b001;       //��ˮ������
                   light_state = 3'b000;
                   end
                else
                   begin                     
                   led_light = 3'b000;          //ϴ�ӡ�Ưϴ����ˮָʾ�ƾ�����
                   light_state = 3'b000;
                   end
                  end
                 endcase
                end
    endmodule