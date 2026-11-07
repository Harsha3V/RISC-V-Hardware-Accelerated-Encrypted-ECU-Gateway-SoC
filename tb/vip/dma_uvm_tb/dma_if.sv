`timescale 1ns/1ps
interface dma_if(input logic clk, input logic rst_n);
  logic dma_done_o;
  logic dma_error_o;
endinterface
