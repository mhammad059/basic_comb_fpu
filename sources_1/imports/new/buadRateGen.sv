`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2025 10:54:47 AM
// Design Name: 
// Module Name: buadRateGen
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


module buadRateGen #(parameter SYS_CLK_FREQ = 100000000)( 
    input logic sys_clk,
    input logic rst,
    input logic [1:0] sel_baud, // 0:4800, 1:9600, 2:19200, 3:38400
    output logic bclk,
    output logic bclkx8    
    );
    
    
    logic bclkx8_old;
    logic [1:0] countx8;
    logic [$clog2(SYS_CLK_FREQ/38400)-1:0] count;
    logic [$clog2(SYS_CLK_FREQ/38400)-1:0] count_till;

    always_ff @ (posedge sys_clk or posedge rst) begin
        if(rst) begin
            countx8 <= 0;
            bclk <= 0;
        end  
        else begin
            bclkx8_old <= bclkx8;
            if (bclkx8 & ~bclkx8_old) begin // positive change
                countx8 <= countx8 + 1;
                if (countx8 == 0) bclk <= ~bclk;
            end
        end
    end

    always_ff @ (posedge sys_clk or posedge rst) begin
        if(rst) begin
            count <= 0;
            bclkx8 <= 0;
        end  
        else begin
            count <= count + 1;
            if (count == count_till-1) begin
                bclkx8 <= ~bclkx8;
                count <= 0;
            end
        end
    end
    
    always_comb begin
        case(sel_baud)
            2'b00: begin
                count_till = (SYS_CLK_FREQ/38400)/2; // 4800 * 8
            end
            2'b01: begin
                count_till = (SYS_CLK_FREQ/76800)/2; // 9600 * 8
            end
            2'b10: begin
                count_till = (SYS_CLK_FREQ/153600)/2; // 19200 * 8
            end 
            2'b11: begin
                count_till = (SYS_CLK_FREQ/307200)/2; // 38400 * 8
            end 
            default: begin
                count_till = 0;
            end
        endcase
    end   
    
endmodule
