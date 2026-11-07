`timescale 1ns/1ps
package dma_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "dma_item.sv"
  `include "dma_sequencer.sv"
  `include "dma_driver.sv"
  `include "dma_monitor.sv"
  `include "dma_agent.sv"
  `include "dma_scoreboard.sv"
  `include "dma_env.sv"
  `include "dma_test.sv"
endpackage
