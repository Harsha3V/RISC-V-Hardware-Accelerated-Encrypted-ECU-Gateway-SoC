`timescale 1ns/1ps

module tb_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uart_pkg::*;

  logic clk;
  logic rst_n;

  // 100 MHz system clock generator
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Power-on reset generator
  initial begin
    rst_n = 0;
    #25 rst_n = 1;
  end

  // Interface instantiation
  uart_if vif(clk, rst_n);

  // Loopback / response so output interface signals are also active and observable
  assign vif.uart_tx_o = vif.uart_rx_i;
  assign vif.uart_irq_o = ~vif.uart_rx_i;

  // Native Synopsys FSDB Waveform Dumping
  initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars(0, tb_top, "+all");
    $fsdbDumpSVA();
    $fsdbDumpMDA();
  end

  initial begin
    uvm_config_db#(virtual uart_if)::set(null, "*", "vif", vif);
    run_test("uart_test");
  end

endmodule
