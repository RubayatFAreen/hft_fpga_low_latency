`timescale 1ns / 1ps
// Network Interface Module with Clock Domain Crossing 
// Uses the async_fifo to pass formatted orders from the core domain 
// to the netowrk (transceiver) domain. 

module network_interface(
    input wire core_clk, 
    input wire reet, 
    input wire [127:0] formatted_order, 
    input wire formatted_valid, 
    output wire [127:0] tx_data,
    output wire tx_valid
    );
    
    // For a real design, rd_clk would be high-speed network clock. 
    // Here, for simplicity, we use the core clock. 
    wire fifo_full;
    wire fofo_empty; 
    wire rd_valid; 
    wire [127:0] rd_data; 
    
    aysnc_fifo fifo_inst(
        .wr_clk(core_clk), 
        .rd_clk(core_clk), 
        .reset(reset), 
        .wr_data(formatted_order), 
        .wr_en(formatted_valid), 
        .rd_data(rd_data), 
        .rd_valid(rd_valid), 
        .fifo_full(fifo_full), 
        .fifo_empty(fifo_empty)
    ); 
    
    assign tx_data = rd_data; 
    assign tx_valid = rd_valid; 
    
endmodule
