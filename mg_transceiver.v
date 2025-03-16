`timescale 1ns / 1ps
// Placeholder Multi-Gigabit Transceivcer Module 

module mg_transceiver(
    input wire tx_clk, 
    input wire reset, 
    input wire [127:0] tx_data_in, 
    input wire tx_valid_in, 
    output reg [127:0] mg_tx_data, 
    output reg mg_tx_valid
    );
    
    // For simulation, we simply pass the data through with one pipeline stage. 
    always @(posedge tx_clk or posedge reset) begin 
        if (reset) begin 
            mg_tx_data <= 128'b0;
            mg_tx_valid <= 1'b0; 
        end else begin 
            mg_tx_data <= tx_data_in; 
            mg_tx_valid <= tx_valid_in; 
        end 
     end 
endmodule
