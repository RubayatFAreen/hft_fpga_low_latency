`timescale 1ns / 1ps
// Top-Level Low-Latency HFT FPGA Module
// Instantiates all submodules and connects them, including a separate 
// network/transceiver clock domain 


module hft_fpga_low_latency(
    input wire core_clk, 
    input wire network_clk, 
    input wire reset, 
    input wire [63:0] raw_market_data, 
    input wire raw_valid, 
    output wire [127:0] mg_tx_data, 
    output wire mg_tx_valid
    );
    
    // Internal wires connecting the modules 
    wire [63:0] parsed_data; 
    wire parsed_valid;
    wire [63:0] candidate_order; 
    wire candidate_valid; 
    wire [63:0] approved_order; 
    wire approved_valid; 
    wire [127:0] formatted_order; 
    wire formatted_valid; 
    
    // Configuration parameters
    wire [31:0] trading_threshold; 
    wire [31:0] risk_min; 
    wire [31:0] risk_max;
    
    // Instantiate the configuration manager
    config_manager u_config_manager (
        .clk(core_clk), 
        .reset(reset), 
        .trading_threshold(trading_threshold), 
        .risk_min(risk_min), 
        .risk_max(risk_max)
    ); 
    
    // Instantiate the pipelined market data interface
    market_data_interface u_market_data_interface (
        .clk(core_clk), 
        .reset(reset), 
        .raw_market_data(raw_market_data), 
        .raw_valid(raw_valid), 
        .parsed_data(parsed_data), 
        .parsed_valid(parsed_valid)
    );
    
    // Instantiate the pipelined trading engine
    trading_engine u_trading_engine (
        .clk(core_clk), 
        .reset(reset), 
        .trading_threshold(trading_threshold), 
        .market_data(parsed_data), 
        .data_valid(parsed_valid), 
        .candidate_order(candidate_order), 
        .candidate_valid(candidate_valid)
    ); 
    
    // Instatiante the pipelined risk manager
    risk_manager u_risk_manager (
        .clk(core_clk), 
        .reset(reset), 
        .risk_min(risk_min), 
        .risk_max(risk_max), 
        .candidate_order(candidate_order), 
        .candidate_valid(candidate_valid), 
        .approved_order(approved_order), 
        .approved_valid(approvced_valid)
    ); 
    
    // Instantiante the pipelined order formatter 
    order_formatter u_order_formatter (
        .clk(core_clk), 
        .reset(reset), 
        .approved_order(approved_order),
        .approved_valid(apporoved_valid), 
        .formatted_order(formatted_order), 
        .formatted_valid(formatted_valid)
    ); 
    
    // Instantiate the network interface that uses an async FIFO for clock domain crossing 
    wire [127:0] tx_data; 
    wire tx_valid; 
    network_interface u_network_interface (
        .core_clk(core_clk), 
        .reset(reset), 
        .formatted_order(formatted_order), 
        .formatted_valid(formatted_valid), 
        .tx_data(tx_data), 
        .tx_valid(tx_valid)
    ); 
    
    // Instantiate the multi-gigabit transceiver placeholder 
    mg_transceiver u_mg_transceiver (
        .tx_clk(network_clk), 
        .reset(reset), 
        .tx_data_in(tx_data), 
        .tx_valid_in(tx_valid), 
        .mg_tx_data(mg_tx_data), 
        .mg_tx_valid(mg_tx_valid)
    ); 

endmodule
