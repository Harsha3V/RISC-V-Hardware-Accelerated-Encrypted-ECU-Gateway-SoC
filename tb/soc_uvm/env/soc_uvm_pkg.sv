`timescale 1ns/1ps

package soc_uvm_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Import the 5 Existing Peripheral VIP Packages
  import uart_pkg::*;
  import spi_pkg::*;
  import gpio_pkg::*;
  import systimer_pkg::*;
  import dma_pkg::*;

  // SoC-Level UVM Environment Components
  `include "soc_config.sv"
  `include "soc_virtual_sequencer.sv"
  `include "soc_virtual_sequence.sv"
  `include "soc_env.sv"
  `include "soc_test.sv"

endpackage
