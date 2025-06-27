`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2025 09:25:37 PM
// Design Name: 
// Module Name: uart_conv_top
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


module uart_conv_top(
    input logic rst,
    input logic sys_clk,

    input logic [1:0] sel_baud, // 0:4800, 1:9600, 2:19200, 3:38400
    
    input logic rx_data,
    output logic tx_data,

    output logic rx_status,
    output logic tx_status

    );

    logic [31:0] ALUout;
    logic [31:0] operA;
    logic [31:0] operB;
    logic [63:0] operAB;

    multiByteUART_top UART_SB(
    .rst,
    .sys_clk,
    .sel_baud, // 0:4800, 1:9600, 2:19200, 3:38400
    .rx_data,
    .serial_out_TX(ALUout),
    .serial_in_RX(operAB),
    .tx_data,  
    .rx_status,
    .tx_status
    );

    cel_2_fah c2f(.celsius(operAB[3:0]), .fahren(ALUout));

endmodule

