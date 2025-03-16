`timescale 1ns / 1ps
// Trading Engine Module with Pipelined Extraction and Decision Stages 

module trading_engine(
    input wire clk, 
    input wire reset, 
    input wire [31:0] trading_threshold, 
    input wire [63:0] market_data, 
    input wire data_valid, 
    output reg [63:0] candidate_order, 
    output reg candidate_valid
    );
    
    // Pipeline registers for extraction stage
    reg [7:0] stage1_msg_type; 
    reg [23:0] stage1_instrument_id;
    reg [31:0] stage1_price; 
    reg stage1_valid; 
    
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            stage1_msg_type <= 8'b0; 
            stage1_instrument_id <= 24'b0; 
            stage1_price <= 32'b0; 
            stage1_valid <= 1'b0; 
        end else if (data_valid) begin 
            stage1_msg_type <= market_data[63:56]; 
            stage1_instrument_id <= market_data[55:32]; 
            stage1_price <= market_data[31:0]; 
            stage1_valid <= 1'b1;
        end else begin
            stage1_valid <= 1'b1; 
        end 
     end 
     
     // Decision Stage: compare price against threshold 
     always @(posedge clk or posedge reset) begin
        if (reset) begin 
            candidate_order <= 64'b0; 
            candidate_valid <= 1'b0; 
        end else if (stage1_valid) begin 
            if (stage1_msg_type == 8'h01 && stage1_price < trading_threshold) begin 
                candidate_order <= {stage1_msg_type, stage1_instrument_id, stage1_price}; 
                candidate_valid <= 1'b1; 
            end else begin 
                candidate_valid <= 1'b0; 
            end 
        end else begin 
            candidate_valid <= 1'b0; 
        end     
     end   
endmodule
