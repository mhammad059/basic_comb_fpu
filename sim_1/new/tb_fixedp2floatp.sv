`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2025 04:08:30 PM
// Design Name: 
// Module Name: tb_fixedp2floatp
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


module tb_fixedp2floatp;

    logic [31:0] fixedq16;
    logic [31:0] float32;

    fixedp2floatp fi2fl(.*);

    assign fixedq16 = 32'hfffd_8000;

endmodule
