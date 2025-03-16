`timescale 1ns / 1ps
// Asynchronous FIFO for Clock Domain Crossing 
// Simplified dual-clokc FIFO for 128-bit wide data. 


module async_fifo(
    input wire wr_clk, 
    input wire rd_clk, 
    input wire reset, 
    input wire [127:0] wr_data, 
    input wire wr_en, 
    output reg [127:0] rd_data,
    output reg rd_valid, 
    output reg fifo_full, 
    output reg fifo_empty
    );
    
    parameter DEPTH = 16; 
    parameter ADDR_WIDTH = 4; // for DEPTH=16
    
    reg [127:0] mem [0:DEPTH-1]; 
    reg [ADDR_WIDTH:0] wr_ptr; 
    reg [ADDR_WIDTH:0] rd_ptr; 
    
    // Write domain 
    always @(posedge wr_clk or posedge reset) begin 
        if (reset) begin 
            wr_ptr <= 0; 
            fifo_full <= 1'b0; 
        end else if (wr_en && !fifo_full) begin 
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data; 
            wr_ptr <= wr_ptr + 1; 
        end
    end 
    
    // Read Domain 
    always @(posedge rd_clk or posedge reset) begin  
        if (reset) begin 
            rd_ptr <= 0; 
            rd_valid <= 1'b0; 
        end else begin 
            if (!fifo_empty) begin 
                rd_data <= mem[rd_ptr[ADDR_WIDTH-1:0]]; 
                rd_ptr <= rd_ptr + 1; 
                rd_valid <= 1'b1; 
            end else begin 
                rd_valid <= 1'b0; 
            end 
        end 
    end 
    
    always @(*) begin
        fifo_empty = (wr_ptr == rd_ptr); 
        fifo_full = ((wr_ptr - rd_ptr) == DEPTH); 
    end 
    
endmodule
