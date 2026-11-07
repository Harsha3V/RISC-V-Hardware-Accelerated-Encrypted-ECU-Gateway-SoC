`timescale 1ns/1ps

interface spi_if(input logic clk, input logic rst_n);
  // Physical SoC SPI Master boundary signals (MCP2515 CAN controller interface)
  logic spi_clk_o;  // Output from SoC (monitored by VIP)
  logic spi_mosi_o; // Output from SoC (monitored by VIP)
  logic spi_miso_i; // Input to SoC (driven by VIP CAN Responder)
  logic spi_cs_n_o; // Output from SoC (monitored by VIP)

  // Clocking block for driver (driving MISO response to SoC)
  clocking drv_cb @(posedge clk);
    default input #1step output #1step;
    output spi_miso_i;
    input  spi_clk_o, spi_mosi_o, spi_cs_n_o;
  endclocking

  // Clocking block for monitor (snooping SPI transactions)
  clocking mon_cb @(posedge clk);
    default input #1step;
    input spi_clk_o, spi_mosi_o, spi_miso_i, spi_cs_n_o;
  endclocking

  // Modports
  modport DRV (clocking drv_cb, input clk, input rst_n);
  modport MON (clocking mon_cb, input clk, input rst_n);
endinterface
