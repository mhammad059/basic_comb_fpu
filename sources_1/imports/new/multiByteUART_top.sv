`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2025 02:27:20 PM
// Design Name: 
// Module Name: multiByteUART_top
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


module multiByteUART_top(
    input logic rst,
    input logic sys_clk,

    input logic [1:0] sel_baud, // 0:4800, 1:9600, 2:19200, 3:38400
    
    input logic rx_data,
    
    input logic [31:0] serial_out_TX,
    output logic [63:0] serial_in_RX,

    output logic tx_data,
        
    output logic rx_status,
    output logic tx_status
    );

    // uart THR and RHR
    logic [7:0] tx_d_in;
    logic [7:0] rx_d_out;

    // counts number of bytes rx/tx
    logic [3:0] byte_count;
    logic [1:0] byte_count_tx;

    // to detect edges
    logic rx_status_old;
    logic tx_status_old;

    // to start tx
    logic tx_en;

    uart_top UART( .rst, .sys_clk,
    .tx_en, .sel_baud,

    .tx_d_in, // byte_in
    .rx_data, .tx_data,
    .rx_d_out, // byte_out

    .rx_status, .tx_status
    );

    //assign tx_d_in = |byte_count_tx ? (byte_count_tx[0] ? (byte_count_tx[1] ? ALUout[31:24] : ALUout[15:8]) : ALUout[23:16] ) : ALUout[7:0];

    // transmitter out logic
    always_comb begin
        case(byte_count_tx)
            2'b00: tx_d_in = serial_out_TX[31:24];
            2'b01: tx_d_in = serial_out_TX[23:16];
            2'b10: tx_d_in = serial_out_TX[15:8];
            2'b11: tx_d_in = serial_out_TX[7:0];
            default: tx_d_in = 10; // newline
        endcase
    end

    // recieve logic
    always_ff @ (posedge sys_clk or posedge rst) begin
        if(rst) begin
            byte_count <= 0;
            byte_count_tx <= 0;
            serial_in_RX <= 0;
            rx_status_old <= 0;
            tx_status_old <= 0;
            tx_en <= 0;
        end
        else begin
            rx_status_old <= rx_status;
            /// --- time to settle alu output
            if(&byte_count) begin //  if == max val
                tx_en <= 1;
                byte_count <= 0;
            end
            if(byte_count[3]) byte_count <= byte_count + 1; // if == 8      
            /// ---          
            else begin
                if(rx_status_old & ~rx_status) begin // data received (negedge of rx_status)
                    serial_in_RX <= {serial_in_RX[55:0], rx_d_out}; // shift left and recieve
                    byte_count <= byte_count + 1;
                end
            end
            tx_status_old <= tx_status;
            if(tx_status_old & ~tx_status) begin // transmitted (negedge of tx_status)
                if (&byte_count_tx) begin // if == max val
                    byte_count_tx <= 0;
                    tx_en <= 0;
                end
                else byte_count_tx <= byte_count_tx + 1;
            end
        end
    end

endmodule
