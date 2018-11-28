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
       reg [4:0] wash_time,rinse_time,dry_time;  //ϴƯ��ʱ��
       reg    time1_ind,time2_ind,time3_ind;    //ϴƯ�ѽ��б�ʶ
 initial begin
        time1_ind=0;
        time2_ind=0;
        time3_ind=0;
        time_now=11;
        time_all=29;
  end
  always @(module_select or water_select )  //ģʽ�仯��ˮλѡ����ᵼ��ʱ��仯
    begin
   case(model_now)
      3'b000:   begin //ϴƯ��
         wash_time=9+water_level;
         rinse_time=9+water_level*2;
         dry_time=3+water_level;
         end
       3'b001:  begin   //��ϴ��ʱ 
        wash_time=9+water_level;
        rinse_time=0;
        dry_time=0;
        end
       3'b010:   begin  //ϴƯ��ʱ
        wash_time=9+water_level;
        rinse_time=9+water_level*2;
        dry_time=0;
        end
       3'b011:   begin //��Ư��ʱ
        wash_time=0;
        rinse_time=9+water_level*2;
        dry_time=0;
        end
       3'b100:   begin //Ư����ʱ
        wash_time=0;
        rinse_time=9+water_level*2;
        dry_time=3+water_level;
        end
       3'b101:  begin //������ʱ   
        wash_time=0;
        rinse_time=0;
        dry_time=3+water_level;
        end
    endcase
 end
 
  always@(posedge clk_sec )  //ʵ�ֶԵ�ǰģʽʣ��ʱ��Ŀ���
      begin    
          if(module_select || if_finish||water_select)            //ģʽѡ��ϴ����ɡ�ˮλѡ����ᵼ�µ�ǰʣ��ʱ�䷢���仯
           begin
            if(power_led&&~start_led)   begin                 //��Դָʾ�����Ҵ�����ͣ״̬
            time_now=wash_time?wash_time:(rinse_time?rinse_time:dry_time);    //ѡ��ϴ��Ư����˳���е�һ����Ϊ0��ֵ��Ϊ��ǰģʽʣ��ʱ��
            time1_ind=0;                                      
            time2_ind=0;            
            time3_ind=0; 
           end
          end
          else  begin
          if(power_led&&start_led)          //��Դָʾ�����Ҵ�������״̬
          begin
            if(time1_ind==0)
            begin
            time_now=wash_time;
            time1_ind=1;
            end
            if(time_now>0)
            time_now=time_now-1;           //ϴ��ʱ�䵹��ʱ
            else  begin
              if(time2_ind==0)
              begin
              time_now=rinse_time;
              time2_ind=1;
              end
              if(time_now>0)
              time_now=time_now-1;        //Ưϴʱ�䵹��ʱ
              else   begin
                if(time3_ind==0)
                begin
                time_now=dry_time;
                time3_ind=1;
                end
                if(time_now>0)
                time_now=time_now-1;      //��ˮʱ�䵹��ʱ
                else   time_now=11;
                end
               end
              end
             end
            end
            
      always@(posedge clk_sec )    //ʵ�ֶ���ʣ��ʱ��Ŀ���
      begin
        if(module_select||water_select||if_finish)    //ģʽѡ��ˮλѡ��ϴ����ɾ��ᵼ����ʣ��ʱ�䷢���仯
        begin
        if(power_led && ~start_led)             //��Դָʾ�����Ҵ�����ͣ״̬
       time_all=wash_time+rinse_time+dry_time;       //��ʣ��ʱ����ϴ�ӡ�Ưϴ����ˮʱ����ܺ�
        end
      else  begin
      if(power_led  &&  start_led)             //��Դָʾ�����Ҵ�������״̬
      begin
         if(time_all>0)
         time_all=time_all-1;              //��ʣ��ʱ�䵹��ʱ
         else  begin
         time_all=29;
         end
       end
      end
     end       
endmodule


