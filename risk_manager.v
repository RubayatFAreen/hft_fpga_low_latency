`timescale 1ns / 1ps
// Risk Manager Module with Pipelining


module risk_manager(
    input wire clk, 
    input wire reset, 
    input wire [31:0] risk_min, 
    input wire [31:0] risk_max, 
    input wire [63:0] candidate_order, 
    input wire candidate_valid, 
    output reg [63:0] approved_order, 
    output reg approved_valid
    );
    
    // Pipeline stage for risk evaluation
    reg [31:0] stage1_price; 
    reg stage1_valid; 
    
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            stage1_price <= 32'b0; 
            stage1_valid <= 1'b0; 
        end else if (candidate_valid) begin 
            stage1_price <= candidate_order[31:0]; 
            stage1_valid <= 1'b1; 
        end else begin 
            stage1_valid <= 1'b0; 
        end 
        
    end 
    
    
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            approved_order <= 64'b0; 
            approved_valid <= 1'b0; 
        end else if (stage1_valid) begin 
            if (stage1_price >= risk_min && stage1_price <= risk_max) begin 
                approved_order <= candidate_order; 
                approved_valid <= 1'b1; 
            end else begin 
                approved_valid <= 1'b0; 
            end 
        end else begin  
            approved_valid <= 1'b0; 
        end
    end  
    
endmodule
