`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2025 06:58:08 PM
// Design Name: 
// Module Name: cel_2_fah
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


module cel_2_fah(
    input logic [3:0] celsius,
    output logic [31:0] fahren
    );
    
    logic [31:0] celsius_q16_16;
    logic [31:0] celsius_f32;
    logic [63:0] prod;

    always_comb begin
        celsius_q16_16 = celsius << 16;
        prod = 32'd117965 * celsius_q16_16;
        celsius_q16_16 = prod >> 16;        
    end

    fixedp2floatp f2fp(.fixedq16(celsius_q16_16), .float32(celsius_f32));

    fpu_alu fpu(.operation(1'b0), .operA_float32(celsius_f32), .operB_float32(32'h42000000), .result(fahren));

endmodule
