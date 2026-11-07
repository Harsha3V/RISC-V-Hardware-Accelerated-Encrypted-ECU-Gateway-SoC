`timescale 1ns/1ps

interface systimer_if(input logic clk, input logic rst_n);
  // Physical SoC Timer boundary signals (EF_TCC32)
  logic timer_ctr_in_i; // Input external clock/counter event to SoC (driven by VIP)
  logic timer_irq_o;    // Timer timeout/compare interrupt from SoC (monitored by VIP)

  // Clocking block for driver
  clocking drv_cb @(posedge clk);
    default input #1step output #1step;
    output timer_ctr_in_i;
    input  timer_irq_o;
  endclocking

  // Clocking block for monitor
  clocking mon_cb @(posedge clk);
    default input #1step;
    input timer_ctr_in_i, timer_irq_o;
  endclocking

  // Modports
  modport DRV (clocking drv_cb, input clk, input rst_n);
  modport MON (clocking mon_cb, input clk, input rst_n);
endinterface
