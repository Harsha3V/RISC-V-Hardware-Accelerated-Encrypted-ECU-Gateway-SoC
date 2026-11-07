`timescale 1ns/1ps
interface gpio_if(input logic clk, input logic rst_n);
  logic [7:0] gpio_in_i;
  logic [7:0] gpio_out_o;
  logic [7:0] gpio_oe_o;
  logic gpio_irq_o;
endinterface
