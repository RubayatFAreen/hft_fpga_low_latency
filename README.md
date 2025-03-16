# Low-Latency HFT FPGA System

This repository contains a surface-level FPGA design for a high-frequency trading (HFT) system optimized for low latency. The project is an educational demonstration that mimics key aspects of a real HFT system, including market data processing, trading decision logic, risk management, order formatting, and network interfacing. It incorporates low-latency techniques such as pipelining and clock domain crossing using an asynchronous FIFO, along with a placeholder module for a multi‑gigabit transceiver.

## Project Overview

**Objective:**  
Design and implement a modular FPGA-based trading engine that minimizes latency by:
- Breaking down the processing pipeline into multiple stages.
- Implementing an asynchronous FIFO to safely cross clock domains.
- Preparing the system for integration with high-speed transceivers.

**Key Features:**
- **Modular Architecture:**  
  The design is organized into distinct modules:
  - `config_manager`: Manages configurable parameters like trading thresholds and risk limits.
  - `market_data_if`: Captures and processes raw market data using a two-stage pipeline.
  - `trading_engine`: Extracts key fields and makes trading decisions.
  - `risk_manager`: Evaluates candidate orders against risk parameters.
  - `order_formatter`: Formats approved orders with sequence numbers and header fields.
  - `async_fifo`: Provides clock domain crossing between processing and network domains.
  - `network_interface`: Handles data transfer to the network domain.
  - `mg_transceiver`: A placeholder for a multi‑gigabit transceiver.
  - `hft_fpga_low_latency`: The top-level module integrating all components.
  
- **Low-Latency Optimizations:**
  - **Pipelining:** Critical operations are pipelined to minimize combinatorial delays and support high clock frequencies.
  - **Clock Domain Crossing:** An asynchronous FIFO safely transfers data between the core processing domain and the network (transceiver) domain.
  - **High-Speed Networking Placeholder:** A simulated multi‑gigabit transceiver module demonstrates the complete data flow.

## Design Details

### 1. Configuration Manager (`config_manager`)
- **Function:** Provides default and configurable trading thresholds and risk limits.
- **Rationale:** Flexibility is key in trading systems. These parameters can be adjusted dynamically in a real implementation without modifying the core logic.

### 2. Market Data Interface (`market_data_if`)
- **Function:** Receives 64-bit raw market data and processes it using a 2-stage pipeline.
- **Rationale:** Pipelining minimizes delay during data capture and decoding, ensuring fast data availability for decision making.

### 3. Trading Engine (`trading_engine`)
- **Function:** Extracts message type, instrument ID, and price; compares the price against a configurable threshold.
- **Rationale:** Separating the extraction and decision-making stages allows for higher clock speeds and facilitates the integration of more advanced trading strategies in the future.

### 4. Risk Manager (`risk_manager`)
- **Function:** Validates candidate orders by checking if the price falls within acceptable risk limits.
- **Rationale:** Protects the system from executing trades outside predefined risk parameters, an essential safety feature in HFT.

### 5. Order Formatter (`order_formatter`)
- **Function:** Formats approved orders into a 128-bit packet by adding sequence numbers and header information.
- **Rationale:** Structured order packets are necessary for downstream processing and tracking in a real trading system.

### 6. Asynchronous FIFO (`async_fifo`)
- **Function:** Enables safe clock domain crossing by buffering data between the core and network clock domains.
- **Rationale:** Ensures data integrity and prevents metastability issues when transferring data between asynchronous clock domains.

### 7. Network Interface (`network_interface`)
- **Function:** Uses the FIFO to bridge the core processing domain with the network domain.
- **Rationale:** Provides a clean separation between the processing logic and the high-speed network interface.

### 8. Multi‑Gigabit Transceiver Placeholder (`mg_transceiver`)
- **Function:** Simulates a high-speed transceiver interface.
- **Rationale:** In a production environment, this module would handle serialization, clock recovery, and error correction at multi‑gigabit rates. Its inclusion demonstrates a full end-to-end design flow.

### 9. Top-Level Module (`hft_fpga_low_latency`)
- **Function:** Integrates all submodules into a cohesive low-latency HFT system.
- **Rationale:** Demonstrates the complete flow from market data input to order transmission while addressing low-latency design challenges.

## How It Works

1. **Data Capture:**  
   Raw market data is input to the `market_data_if` module, which uses pipelining to quickly capture and process the data.

2. **Trading Decision:**  
   The `trading_engine` extracts relevant fields and compares the price against a trading threshold. If the criteria are met, a candidate order is generated.

3. **Risk Evaluation:**  
   The candidate order is passed to the `risk_manager`, which approves it only if it meets predefined risk criteria.

4. **Order Formatting:**  
   Approved orders are formatted by the `order_formatter`, adding sequence numbers and headers to create a 128-bit packet.

5. **Clock Domain Crossing and Transmission:**  
   The `network_interface` uses an asynchronous FIFO to transfer the formatted order from the core clock domain to the network domain. The `mg_transceiver` module then simulates the high-speed transmission of this data.

## Getting Started

### Prerequisites
- **Verilog Simulation Tools:** Icarus Verilog, ModelSim, Xilinx Vivado, or Intel Quartus.
- **FPGA Development Board:** (Optional, for hardware testing.)
- **Basic Knowledge:** Understanding of Verilog and FPGA design concepts.

### Building and Simulation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/low-latency-hft-fpga.git
   cd low-latency-hft-fpga
