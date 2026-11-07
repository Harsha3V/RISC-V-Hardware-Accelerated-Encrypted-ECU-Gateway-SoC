`timescale 1ns/1ps
interface systimer_if(input logic clk, input logic rst_n);
  logic timer_ctr_in_i;
  logic timer_irq_o;
endinterface
