`timescale 1ns / 1ps
// Market Data Interface Module with 2-Stage Pipelining 

module market_data_interface(
    input wire clk, 
    input wire reset, 
    input wire [63:0] raw_market_data, 
    input wire raw_valid, 
    output reg [63:0] parsed_data, 
    output reg parsed_valid
    );
    
    reg [63:0] stage1_data; 
    reg stage1_valid;
    
    // Stage 1: Capture raw data
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            stage1_data <= 64'b0;
            stage1_valid <= 1'b0;
        end else if (raw_valid) begin 
            stage1_data <= raw_market_data;
            stage1_valid <= 1'b1;
        end else begin 
            stage1_valid <= 1'b0;
        end 
    end
    
    // Stage 2: Pass parsed data along
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            parsed_data <= 64'b0; 
            parsed_valid <= 1'b0; 
        end else begin 
            parsed_data <= stage1_data; 
            parsed_valid <= stage1_valid; 
        end 
    end 
    
    
endmodule
