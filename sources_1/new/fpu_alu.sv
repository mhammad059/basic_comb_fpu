`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2025 05:09:32 PM
// Design Name: 
// Module Name: fpu_alu
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


module fpu_alu(
    input logic operation,
    input logic [31:0] operA_float32,
    input logic [31:0] operB_float32,
    output logic [31:0] result
    );

    logic sA, sB, sR; // sign
    logic [7:0] eA, eB, eR; // exponenets
    logic [23:0] mA, mB, mR; // mantissa

    logic cout;

    logic [7:0] exp_dif;

    logic [4:0] zero_count;


    always_comb begin
        eA = operA_float32[30:23];
        eB = operB_float32[30:23];
        sA = operA_float32[31];
        sB = operB_float32[31] ^ operation; // inverts B sign if subtract
        mA = {1'b1, operA_float32[22:0]};
        mB = {1'b1, operB_float32[22:0]};

        // sign and exponent
        if(eA > eB) begin
            eR = eA;
            sR = sA;
        end
        else begin 
            eR = eB; // if both exp equal, look at mantissa
            sR = sB;
            if(eA == eB) begin
                if(mA > mB)
                    sR = sA;
                else
                    sR = sB;
            end
        end
        
        // adder and subtractor
        exp_dif = eA - eB;
        exp_dif = exp_dif[7] ? ~exp_dif + 1'b1 : exp_dif; // abs(eA - eB)
        if(sA ^ sB) begin // if subraction
            if(eA > eB) {cout, mR} = mA - (mB >> exp_dif);
            else {cout, mR} = mB - (mA >> exp_dif);
            // logic to normalize again
            mR = mR[23] ? {1'b0, ~mR[22:0] + 1'b1} : mR; // abs(mR)
            zero_count = 0;
            for(int i = 23; i >= 0; i = i - 1) begin
                if(mR[i] == 1) break;
                zero_count = zero_count + 1'b1;
            end
            mR = mR << zero_count;
            eR = eR - zero_count;
            // if addition
        end else begin
            if(eA > eB) {cout, mR} = mA + (mB >> exp_dif);
            else {cout, mR} = mB + (mA >> exp_dif);
            if (cout) begin mR = mR >> 1; eR = eR + 1; end
        end

        result = {sR, eR, mR[22:0]};

    end

endmodule
