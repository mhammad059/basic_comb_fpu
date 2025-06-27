`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2025 06:14:41 PM
// Design Name: 
// Module Name: tb_fpu_alu
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


module tb_fpu_alu;
    
    logic operation;
    logic [31:0] operA_float32;
    logic [31:0] operB_float32;
    logic [31:0] result;

    logic [31:0] fixedq16_A;
    logic [31:0] fixedq16_B;

    fixedp2floatp converterA(.fixedq16(fixedq16_A), .float32(operA_float32));
    fixedp2floatp converterB(.fixedq16(fixedq16_B), .float32(operB_float32));

    fpu_alu dut(.*);

    // Task to display result as float
    task print_result;
        shortreal real_result;
        shortreal A_real;
        shortreal B_real;
        begin
            A_real = $bitstoshortreal({32'b0, operA_float32});
            B_real = $bitstoshortreal({32'b0, operB_float32});
            real_result = $bitstoshortreal({32'b0, result});
            $display("A: %f, B: %f, A-B: %f", A_real, B_real, real_result);
        end
    endtask

    // Stimulus
    initial begin
        $display("=== FPU ALU Test: Subtraction ===");

        // Set to subtraction
        operation = 1'b1;

        // Example fixed-point values (e.g., 3.5 - 1.25)
        fixedq16_A = 32'd2097152;   // 3.5 in Q16.16 (3.5 * 2^16 = 229376)
        fixedq16_B = 32'd589824;    // 1.25 in Q16.16 (1.25 * 2^16 = 81920)

        #10;

        // Set to addition
        operation = 1'b0;
        
        #10;

        // Display result
        $display("Float32 Result (hex): %h", result);
        print_result();

        // You can add more test cases here...
        $finish;
    end

endmodule
