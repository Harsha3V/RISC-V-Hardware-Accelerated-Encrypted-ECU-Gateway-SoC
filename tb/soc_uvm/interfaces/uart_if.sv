`timescale 1ns/1ps

interface uart_if(input logic clk, input logic rst_n);
  // Physical SoC UART boundary signals
  logic uart_rx_i;  // Input to SoC (driven by VIP Driver / External Device)
  logic uart_tx_o;  // Output from SoC (monitored by VIP Monitor)
  logic uart_irq_o; // Output from SoC (monitored by VIP Monitor)

  // Clocking block for driver
  clocking drv_cb @(posedge clk);
    default input #1step output #1step;
    output uart_rx_i;
    input  uart_tx_o, uart_irq_o;
  endclocking

  // Clocking block for monitor
  clocking mon_cb @(posedge clk);
    default input #1step;
    input uart_rx_i, uart_tx_o, uart_irq_o;
  endclocking

  // Modports
  modport DRV (clocking drv_cb, input clk, input rst_n);
  modport MON (clocking mon_cb, input clk, input rst_n);
endinterface
