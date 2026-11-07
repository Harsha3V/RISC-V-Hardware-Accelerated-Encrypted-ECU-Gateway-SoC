`timescale 1ns/1ps

interface dma_if(input logic clk, input logic rst_n);
  // Physical SoC DMA status interrupt signals
  logic dma_done_o;  // Transfer complete interrupt from SoC (monitored by VIP)
  logic dma_error_o; // Transfer error interrupt from SoC (monitored by VIP)

  // Clocking block for monitor
  clocking mon_cb @(posedge clk);
    default input #1step;
    input dma_done_o, dma_error_o;
  endclocking

  // Modport
  modport MON (clocking mon_cb, input clk, input rst_n);
endinterface
