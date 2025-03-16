`timescale 1ns / 1ps
// Config Manager Module
// Provides configurable parameters (e.g. trading thresholds and risk limits)

module config_manager(
    input wire clk, 
    input wire reset, 
    output reg [31:0] trading_threshold, 
    output reg [31:0] risk_min, 
    output reg [31:0] risk_max
    );
    
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            trading_threshold <= 32'd1000; // Default Trading Threshold 
            risk_min <= 32'd1000; // Minimum risk limit 
            risk_max <= 32'd5000; // Maximum risk limit 
        end else begin 
            trading_threshold <= trading_threshold; 
            risk_min <= risk_min; 
            risk_max <= risk_max;
        end 
    end 
endmodule
