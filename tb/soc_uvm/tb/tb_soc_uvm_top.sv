`timescale 1ns/1ps

module tb_soc_uvm_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import soc_uvm_pkg::*;

  // Clock & Reset Signals
  logic         clk;
  logic         rst_l;   // Active-high reset for VeeR core
  logic         rstn;    // Active-low reset for Interconnect and Peripherals
  logic [31:1]  rst_vec; // CPU boot reset vector
  logic         nmi_int;
  logic [31:1]  nmi_vec;

  // 100 MHz System Clock Generation (10 ns period)
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  // Power-on Reset Generator
  initial begin
    rst_l   = 1'b0;
    rstn    = 1'b0;
    rst_vec = 31'h4000_0000; // Boot ROM base: 0x8000_0000 >> 1
    nmi_int = 1'b0;
    nmi_vec = 31'h0;

    #250; // Hold reset for 25 cycles
    rst_l   = 1'b1;
    rstn    = 1'b1;
  end

  // =========================================================================
  // Instantiate the 5 SystemVerilog Peripheral Interfaces
  // =========================================================================
  uart_if     u_uart_if     (clk, rstn);
  spi_if      u_spi_if      (clk, rstn);
  gpio_if     u_gpio_if     (clk, rstn);
  systimer_if u_systimer_if (clk, rstn);
  dma_if      u_dma_if      (clk, rstn);

  // Initialize Default Passive Pin Driving State
  initial begin
    u_spi_if.spi_miso_i          = 1'b0;     // SPI MISO line idle
    u_gpio_if.gpio_in_i          = 8'h00;    // GPIO input pins idle
    u_systimer_if.timer_ctr_in_i = 1'b0;     // Timer pulse input idle
  end

  // =========================================================================
  // Instantiate the ACTUAL SoC Top RTL Module as "soc_dut"
  // =========================================================================
  soc_top #(
    .ROM_DEPTH (4096),
    .ROM_FILE  ("boot.hex")
  ) soc_dut (
    .clk            (clk),
    .rst_l          (rst_l),
    .rstn           (rstn),
    .rst_vec        (rst_vec),
    .nmi_int        (nmi_int),
    .nmi_vec        (nmi_vec),

    // UART External Pins -> uart_if
    .uart_rx_i      (u_uart_if.uart_rx_i),
    .uart_tx_o      (u_uart_if.uart_tx_o),
    .uart_irq_o     (u_uart_if.uart_irq_o),

    // SPI External Pins (MCP2515 CAN Controller) -> spi_if
    .spi_clk_o      (u_spi_if.spi_clk_o),
    .spi_mosi_o     (u_spi_if.spi_mosi_o),
    .spi_miso_i     (u_spi_if.spi_miso_i),
    .spi_cs_n_o     (u_spi_if.spi_cs_n_o),

    // GPIO External Pins (EF_GPIO8) -> gpio_if
    .gpio_in_i      (u_gpio_if.gpio_in_i),
    .gpio_out_o     (u_gpio_if.gpio_out_o),
    .gpio_oe_o      (u_gpio_if.gpio_oe_o),
    .gpio_irq_o     (u_gpio_if.gpio_irq_o),

    // Timer External Input / Output (EF_TCC32) -> systimer_if
    .timer_ctr_in_i (u_systimer_if.timer_ctr_in_i),
    .timer_irq_o    (u_systimer_if.timer_irq_o),

    // DMA Status Interrupts -> dma_if
    .dma_done_o     (u_dma_if.dma_done_o),
    .dma_error_o    (u_dma_if.dma_error_o)
  );

  // =========================================================================
  // Native Synopsys FSDB Waveform Recording
  // =========================================================================
  initial begin
    $fsdbDumpfile("dump_soc_uvm.fsdb");
    $fsdbDumpvars(0, tb_soc_uvm_top, "+all");
    $fsdbDumpSVA();
    $fsdbDumpMDA();
  end

  // =========================================================================
  // UVM Virtual Interface Registration & Test Trigger
  // =========================================================================
  initial begin
    uvm_config_db#(virtual uart_if)::set(null, "*", "vif_uart", u_uart_if);
    uvm_config_db#(virtual spi_if)::set(null, "*", "vif_spi", u_spi_if);
    uvm_config_db#(virtual gpio_if)::set(null, "*", "vif_gpio", u_gpio_if);
    uvm_config_db#(virtual systimer_if)::set(null, "*", "vif_systimer", u_systimer_if);
    uvm_config_db#(virtual dma_if)::set(null, "*", "vif_dma", u_dma_if);

    // Direct interface registrations for VIP agents
    uvm_config_db#(virtual uart_if)::set(null, "*uart_agt*", "vif", u_uart_if);
    uvm_config_db#(virtual spi_if)::set(null, "*spi_agt*", "vif", u_spi_if);
    uvm_config_db#(virtual gpio_if)::set(null, "*gpio_agt*", "vif", u_gpio_if);
    uvm_config_db#(virtual systimer_if)::set(null, "*systimer_agt*", "vif", u_systimer_if);
    uvm_config_db#(virtual dma_if)::set(null, "*dma_agt*", "vif", u_dma_if);

    // Launch Top-Level SoC UVM Test
    run_test("soc_test");
  end

endmodule
