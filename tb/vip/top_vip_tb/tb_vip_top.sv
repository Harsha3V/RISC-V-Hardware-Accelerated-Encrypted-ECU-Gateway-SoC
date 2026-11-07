`timescale 1ns/1ps

module tb_vip_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uart_pkg::*;
  import spi_pkg::*;
  import gpio_pkg::*;
  import systimer_pkg::*;
  import dma_pkg::*;
  import top_vip_pkg::*;

  logic clk;
  logic rst_n;

  // 100 MHz System Clock Generator
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Power-on Reset Generator
  initial begin
    rst_n = 0;
    #25 rst_n = 1;
  end

  // Instantiate All 5 Peripheral VIP Interfaces
  uart_if     u_uart_if(clk, rst_n);
  spi_if      u_spi_if(clk, rst_n);
  gpio_if     u_gpio_if(clk, rst_n);
  systimer_if u_systimer_if(clk, rst_n);
  dma_if      u_dma_if(clk, rst_n);

  initial begin
    // Register interfaces in UVM config DB
    uvm_config_db#(virtual uart_if)::set(null, "*uart_agt*", "vif", u_uart_if);
    uvm_config_db#(virtual spi_if)::set(null, "*spi_agt*", "vif", u_spi_if);
    uvm_config_db#(virtual gpio_if)::set(null, "*gpio_agt*", "vif", u_gpio_if);
    uvm_config_db#(virtual systimer_if)::set(null, "*systimer_agt*", "vif", u_systimer_if);
    uvm_config_db#(virtual dma_if)::set(null, "*dma_agt*", "vif", u_dma_if);

    // Launch Top-Level VIP Test
    run_test("top_vip_test");
  end

endmodule
