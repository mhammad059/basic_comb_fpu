`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2025 08:42:59 PM
// Design Name: 
// Module Name: tb_cel_2_fah
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


module tb_cel_2_fah;

    logic [3:0] celsius;
    logic [31:0] fahren;

    cel_2_fah c2f(.*);

    initial begin
        celsius = 32'd37;
    end
    
    
endmodule
