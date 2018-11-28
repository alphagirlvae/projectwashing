`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 11:34:23
// Design Name: 
// Module Name: bin27seg
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

module bin27seg (data_in ,data_out );
input  wire [3:0] data_in ;
output reg  [7:0] data_out ;

always @(data_in)   
    begin
       case (data_in )
       0: data_out<= 8'b11000000; //0
       1: data_out<= 8'b11111001; //1
       2: data_out<= 8'b10100100; //2
       3: data_out<= 8'b10110000; //3
       4: data_out<= 8'b10011001; //4
       5: data_out<= 8'b10010010; //5
       6: data_out<= 8'b10000010; //6
       7: data_out<= 8'b11111000; //7
       8: data_out<= 8'b10000000; //8
       9: data_out<= 8'b10010000; //9
       default:data_out<= 8'b10111111; 
       endcase
  end
endmodule
