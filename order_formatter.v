`timescale 1ns / 1ps
// Order Formatter Module with Pipelining 

module order_formatter(
    input wire clk, 
    input wire reset, 
    input wire [63:0] approved_order, 
    input wire approved_valid, 
    output reg [127:0] formatted_order, 
    output reg formatted_valid
    );
    
    // Order sequence counter 
    reg [31:0] order_seq; 
    // Pipeline registers for approved signals 
    reg approved_valid_pipe; 
    reg [63:0] approved_order_pipe; 
    
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            approved_order_pipe <= 64'b0; 
            approved_valid_pipe <= 1'b0; 
        end else begin 
            approved_order_pipe <= approved_order; 
            approved_valid_pipe <= approved_valid; 
        end 
    end 
    
    // Formatting stage: add sequence and header fields 
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            order_seq <= 32'd0;
            formatted_order <= 128'b0; 
            formatted_valid <= 1'b0; 
        end else if (approved_valid_pipe) begin 
            order_seq <= order_seq + 1; 
            formatted_order <= {order_seq, approved_order_pipe, 32'd0};
            formatted_valid <= 1'b1; 
        end else begin 
            formatted_valid <= 1'b0;
        end 
     end 
    
endmodule
