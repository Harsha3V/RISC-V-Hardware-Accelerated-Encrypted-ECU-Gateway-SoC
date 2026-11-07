`timescale 1ns/1ps

interface gpio_if(input logic clk, input logic rst_n);
  // Physical SoC 8-bit GPIO boundary signals (EF_GPIO8)
  logic [7:0] gpio_in_i;  // Input to SoC (driven by VIP Driver)
  logic [7:0] gpio_out_o; // Output from SoC (monitored by VIP Monitor)
  logic [7:0] gpio_oe_o;  // Output Enable from SoC (monitored by VIP Monitor)
  logic       gpio_irq_o; // GPIO Interrupt output from SoC (monitored by VIP)

  // Clocking block for driver (driving external pin inputs)
  clocking drv_cb @(posedge clk);
    default input #1step output #1step;
    output gpio_in_i;
    input  gpio_out_o, gpio_oe_o, gpio_irq_o;
  endclocking

  // Clocking block for monitor (sampling inputs and outputs)
  clocking mon_cb @(posedge clk);
    default input #1step;
    input gpio_in_i, gpio_out_o, gpio_oe_o, gpio_irq_o;
  endclocking

  // Modports
  modport DRV (clocking drv_cb, input clk, input rst_n);
  modport MON (clocking mon_cb, input clk, input rst_n);
endinterface
