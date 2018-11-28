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
            reg    [2:0]led_light,light_state;  //led_light：控制灯的亮灭,light_state：控制灯亮的状态（常亮（1）或者闪亮（0））
            reg    water_in,water_out;  //water_in:进水指示中间变量,water_out：排水指示中间变量
            
           initial    begin   //默认洗、漂、脱指示灯常亮，进水、排水指示灯不亮
           led_light=3'b111;
           light_state=3'b111;
           water_in=0;
           water_out=0;
           end 
    //控制洗涤、脱水、漂洗、进水、排水灯，在这里利用了控制灯标识与时钟相或，可获得指示灯闪亮的方法
          assign wash_led=led_light[2]&&(clk_sec||light_state[2]||(~start_led))&&power_led;
          assign rinse_led=led_light[1]&&(clk_sec||light_state[1]||(~start_led))&&power_led;
          assign dry_led=led_light[0]&&(clk_sec||light_state[0]||(~start_led))&&power_led;
          assign in_led=water_in&&power_led&&start_led;
          assign out_led=water_out&&power_led&&start_led;
          
    //控制不同模式下进水、排水灯，洗涤、漂洗、脱水灯的暗亮变化，并输出常亮或闪亮信号
          always @(time_all)  
          begin
            case (model_now)
               3'b000 : begin//处于洗涤进水状态或者漂洗进水状态
                if(time_all >= (21+water_level*3)||(time_all <=(9+water_level*2)&& time_all >= (9+water_level)))//锟斤拷锟斤拷洗锟接斤拷水状态锟斤拷锟斤拷漂洗锟斤拷水状态
                  water_in=1;
                else 
                  water_in=0;
                 //处于漂洗排水状态或者脱水排水状态
                if( (time_all <=(12+water_level*3) && time_all >=(12+water_level*2)) || (time_all <=(3+water_level) && time_all >=3) )//锟斤拷锟斤拷漂洗锟斤拷水状态锟斤拷锟斤拷锟斤拷水锟斤拷水状态
                  water_out=1;
                else
                  water_out=0;
                  //洗涤阶段，洗涤灯闪亮，漂洗、脱水灯常亮
                if (time_all >= (12+water_level*3)) 
                  begin
                  led_light = 3'b111;          
                  light_state = 3'b011;     
                  end
                else if (time_all >= (3+water_level))  //漂洗阶段，漂洗洗灯闪亮，脱水灯常亮
                  begin 
                  led_light = 3'b011;           
                  light_state = 3'b001;
                  end
                else if (time_all >= 5'b00000)  //脱水阶段，脱水灯闪亮
                  begin
                  led_light = 3'b001;           
                  light_state = 3'b000;        
                  end
                else               
                  begin                       
                  led_light = 3'b000;             //洗涤、漂洗、脱水指示灯均不亮
                  light_state = 3'b000;
                  end
                 end
    
               3'b001 : begin       //处于洗涤进水状态
                  water_out=0;
                if(time_all >= 9)         
                  water_in=1;
                else 
                   water_in=0;
                if (time_all >= 6'b000000)   //处于洗涤状态，洗涤灯闪亮
                   begin
                   led_light = 3'b100;
                   light_state = 3'b000;     
                   end
                else              //洗涤、漂洗、脱水指示灯均不亮
                 begin                      
                   led_light = 3'b000;       
                   light_state = 3'b000;
                   end
                  end
    
               3'b010 : begin//处于洗涤进水状态或者漂洗进水状态
                if(time_all >=(18+water_level*2)|| (time_all<=(6+water_level) && time_all>=6))
                   water_in=1;
                else  
                   water_in=0;
                if(time_all<=(9+water_level*2) && time_all>=9+water_level) 
                 //处于漂洗排水状态 
                   water_out=1;
                else  
                   water_out=0;
                if(time_all >= (9+water_level*2))   //处于洗涤状态，洗涤灯闪亮，漂洗灯常亮       
                   begin
                   led_light = 3'b110;
                   light_state = 3'b010;
                   end
                else if(time_all >= 6'b000000)       //处于漂洗状态，漂洗灯闪亮    
                   begin
                   led_light = 3'b010;
                   light_state = 3'b000;
                   end
                 else //洗涤、漂洗、脱水指示灯均不亮
                   begin                               
                   led_light = 3'b000;
                   light_state = 3'b000;
                   end
                  end
    
               3'b011 : begin
                if(time_all<=(6+water_level) && time_all>=6)   //处于漂洗进水状态
                   water_in=1;
                else 
                   water_in=0;
                if(time_all>=(9+water_level))            //处于漂洗排水状态
                   water_out=1;
                else 
                   water_out=0; 
                if (time_all >= 6'b000000)           //处于漂洗状态，漂洗灯闪亮   
                   begin
                   led_light = 3'b010;
                   light_state = 3'b000;
                   end
                else                      //洗涤、漂洗、脱水指示灯均不亮
                  begin                            
                  led_light = 3'b000;
                  light_state = 3'b000;
                  end
                 end
                 
               3'b100 : begin
                if (time_all<=(9+water_level*2) && time_all>=(9+water_level))  //处于漂洗进水状态 
                   water_in=1;
                else 
                   water_in=0;
                if (time_all>=(12+water_level*2)|| (time_all<= (3+water_level) && time_all >=3))  
                   //处于漂洗排水状态或者脱水排水状态
                   water_out=1;
                else 
                   water_out=0;
                if (time_all>= (3+water_level))  //处于漂洗状态,漂洗灯闪亮，脱水灯常亮   
                   begin                                
                   led_light = 3'b011;
                   light_state = 3'b001;
                   end
                else if (time_all >= 6'b000000)    //处于脱水状态，脱水灯闪亮   
                   begin
                   led_light = 3'b001;
                   light_state = 3'b000;
                   end
                   else
                   begin                      //洗涤、漂洗、脱水指示灯均不亮   
                   led_light = 3'b000;
                   light_state = 3'b000;
                   end
                  end
                  
               3'b101 : begin
                   water_in=0;                  //进水灯不亮
                if(time_all >= 3)            //处于脱水排水状态
                   water_out=1;
                else 
                   water_out=0; 
                if (time_all >= 6'b000000)  //处于脱水状态
                   begin
                   led_light = 3'b001;       //脱水灯闪亮
                   light_state = 3'b000;
                   end
                else
                   begin                     
                   led_light = 3'b000;          //洗涤、漂洗、脱水指示灯均不亮
                   light_state = 3'b000;
                   end
                  end
                 endcase
                end
    endmodule