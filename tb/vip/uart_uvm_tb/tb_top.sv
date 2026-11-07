`timescale 1ns/1ps
module tb_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uart_pkg::*;

  logic clk;
  logic rst_n;

  // 100 MHz clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generation
  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end

  // Virtual interface instantiation
  uart_if vif(clk, rst_n);

  initial begin
    uvm_config_db#(virtual uart_if)::set(null, "*", "vif", vif);
    run_test("uart_test");
  end
endmodule
