`timescale 1ns/1ps
interface spi_if(input logic clk, input logic rst_n);
  logic spi_clk_o;
  logic spi_mosi_o;
  logic spi_miso_i;
  logic spi_cs_n_o;
endinterface
