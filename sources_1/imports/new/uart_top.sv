`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2025 10:43:01 AM
// Design Name: 
// Module Name: uart_top
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

`ifdef CLOCK_HZ
  localparam int SYS_CLK_FREQ = `CLOCK_HZ; // if clock defined in script file
`else
  localparam int SYS_CLK_FREQ = 100_000_000; // default
`endif

module uart_top(
    input logic rst,
    input logic sys_clk,

    input logic tx_en,
    input logic [1:0] sel_baud, // 0:4800, 1:9600, 2:19200, 3:38400
    input logic [7:0] tx_d_in, //switches
    
    input logic rx_data,
    output logic tx_data,
    
    output logic [7:0] rx_d_out, //leds
    
    output logic rx_status,
    output logic tx_status
    );
    
    logic bclk;
    logic bclkx8;    
    
    buadRateGen #(.SYS_CLK_FREQ(SYS_CLK_FREQ)) brateGen(
        .sys_clk, .rst, .sel_baud, // 0:4800, 1:9600, 2:19200, 3:38400
        .bclk,
        .bclkx8    
        );
    
    transmitter tx(.sys_clk, .rst, .bclk,
        .THR(tx_d_in),
        .tx_en,
        .tx_status,
        .tx_data
        );
    
    receiver rx(.sys_clk, .rst, .bclkx8,
        .rx_data,
        .rx_status,
        .RHR(rx_d_out)
        );
    
    endmodule
