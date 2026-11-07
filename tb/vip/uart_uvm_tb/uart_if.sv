`timescale 1ns/1ps
interface uart_if(input logic clk, input logic rst_n);
  logic uart_rx_i;
  logic uart_tx_o;
  logic uart_irq_o;
endinterface
