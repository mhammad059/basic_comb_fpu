`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/18/2025 02:23:11 PM
// Design Name: 
// Module Name: tb_uart_conv_top
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


module tb_uart_conv_top;

    // Testbench Signals
    logic rst;
    logic sys_clk;
    
    logic [1:0] sel_baud;
    
    logic tx_data;
    logic rx_data; 
        
    logic rx_status;
    logic tx_status;

    logic bclk;
    logic bclkx8;

    
    buadRateGen #(.SYS_CLK_FREQ(100_000_000)) brateGen(
        .sys_clk, .rst, .sel_baud, // 0:4800, 1:9600, 2:19200, 3:38400
        .bclk,
        .bclkx8    
        );

    // Instantiate the UART Top Module
    uart_conv_top uut (
        .rst(rst),
        .sys_clk(sys_clk),
        .sel_baud(sel_baud),
        .rx_data(rx_data),
        .tx_data(tx_data),
        .rx_status(rx_status),
        .tx_status(tx_status)
    );

    // Generate System Clock (100 MHz -> 10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        // Task to send a byte serially
    task send_byte;
        input [7:0] data;
        integer i;
        begin
            @(posedge bclk);
            
            // Start bit
            rx_data = 0;
            @(posedge bclk);
            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx_data = data[i];
                @(posedge bclk);
            end
            
            // Stop bit
            rx_data = 1;
            @(posedge bclk);
        end
    endtask

    task test_add;
        input [63:0] data;
        integer i;
        reg [7:0] byte_in;
        begin
            for (i = 7; i > -1; i = i - 1) begin
                byte_in = data >> (i * 8);
                send_byte(byte_in);
            end
            // wait for tx 
            #4500000; // 9600 !!
        end
    endtask
    
    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        sel_baud = 2'b01;  // 9600 baud
        rx_data = 1;
        //  
        #100;

        rst = 0;

        // Send test bytes
        test_add(64'h00000000_00000005);

        $finish;
    end
    
endmodule
