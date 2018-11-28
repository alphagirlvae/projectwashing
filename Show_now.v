`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 11:29:58
// Design Name: 
// Module Name: Show_now
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

module Show_time(reset,clk,clk_sec,power_led,module_select,water_select,model_now,start_led,if_finish,water_level,time_now,time_all);
  input wire reset,clk,clk_sec,module_select,water_select,power_led,start_led,if_finish;
 input wire [2:0] model_now;
 input wire [3:0] water_level;
 output reg [5:0] time_now,time_all;
       reg [4:0] wash_time,rinse_time,dry_time;  //洗漂脱时间
       reg    time1_ind,time2_ind,time3_ind;    //洗漂脱进行标识
 initial begin
        time1_ind=0;
        time2_ind=0;
        time3_ind=0;
        time_now=11;
        time_all=29;
  end
  always @(module_select or water_select )  //模式变化、水位选择均会导致时间变化
    begin
   case(model_now)
      3'b000:   begin //洗漂脱
         wash_time=9+water_level;
         rinse_time=9+water_level*2;
         dry_time=3+water_level;
         end
       3'b001:  begin   //单洗用时 
        wash_time=9+water_level;
        rinse_time=0;
        dry_time=0;
        end
       3'b010:   begin  //洗漂用时
        wash_time=9+water_level;
        rinse_time=9+water_level*2;
        dry_time=0;
        end
       3'b011:   begin //单漂用时
        wash_time=0;
        rinse_time=9+water_level*2;
        dry_time=0;
        end
       3'b100:   begin //漂脱用时
        wash_time=0;
        rinse_time=9+water_level*2;
        dry_time=3+water_level;
        end
       3'b101:  begin //单脱用时   
        wash_time=0;
        rinse_time=0;
        dry_time=3+water_level;
        end
    endcase
 end
 
  always@(posedge clk_sec )  //实现对当前模式剩余时间的控制
      begin    
          if(module_select || if_finish||water_select)            //模式选择、洗衣完成、水位选择均会导致当前剩余时间发生变化
           begin
            if(power_led&&~start_led)   begin                 //电源指示灯亮且处于暂停状态
            time_now=wash_time?wash_time:(rinse_time?rinse_time:dry_time);    //选择洗、漂、脱顺序中第一个不为0的值作为当前模式剩余时间
            time1_ind=0;                                      
            time2_ind=0;            
            time3_ind=0; 
           end
          end
          else  begin
          if(power_led&&start_led)          //电源指示灯亮且处于启动状态
          begin
            if(time1_ind==0)
            begin
            time_now=wash_time;
            time1_ind=1;
            end
            if(time_now>0)
            time_now=time_now-1;           //洗涤时间倒计时
            else  begin
              if(time2_ind==0)
              begin
              time_now=rinse_time;
              time2_ind=1;
              end
              if(time_now>0)
              time_now=time_now-1;        //漂洗时间倒计时
              else   begin
                if(time3_ind==0)
                begin
                time_now=dry_time;
                time3_ind=1;
                end
                if(time_now>0)
                time_now=time_now-1;      //脱水时间倒计时
                else   time_now=11;
                end
               end
              end
             end
            end
            
      always@(posedge clk_sec )    //实现对总剩余时间的控制
      begin
        if(module_select||water_select||if_finish)    //模式选择、水位选择、洗衣完成均会导致总剩余时间发生变化
        begin
        if(power_led && ~start_led)             //电源指示灯亮且处于暂停状态
       time_all=wash_time+rinse_time+dry_time;       //总剩余时间是洗涤、漂洗、脱水时间的总和
        end
      else  begin
      if(power_led  &&  start_led)             //电源指示灯亮且处于运行状态
      begin
         if(time_all>0)
         time_all=time_all-1;              //总剩余时间倒计时
         else  begin
         time_all=29;
         end
       end
      end
     end       
endmodule


