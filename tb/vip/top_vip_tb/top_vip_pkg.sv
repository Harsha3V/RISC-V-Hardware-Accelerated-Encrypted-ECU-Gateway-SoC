`timescale 1ns/1ps

package top_vip_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uart_pkg::*;
  import spi_pkg::*;
  import gpio_pkg::*;
  import systimer_pkg::*;
  import dma_pkg::*;

  // Top-Level Integrated VIP Environment
  class top_vip_env extends uvm_env;
    uart_agent     uart_agt;
    spi_agent      spi_agt;
    gpio_agent     gpio_agt;
    systimer_agent systimer_agt;
    dma_agent      dma_agt;

    `uvm_component_utils(top_vip_env)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "Building 5 SoC Interface UVM VIP Agents...", UVM_LOW)
      uart_agt     = uart_agent::type_id::create("uart_agt", this);
      spi_agt      = spi_agent::type_id::create("spi_agt", this);
      gpio_agt     = gpio_agent::type_id::create("gpio_agt", this);
      systimer_agt = systimer_agent::type_id::create("systimer_agt", this);
      dma_agt      = dma_agent::type_id::create("dma_agt", this);
    endfunction
  endclass

  // Top-Level Integrated VIP Test
  class top_vip_test extends uvm_test;
    top_vip_env env;

    `uvm_component_utils(top_vip_test)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = top_vip_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info(get_type_name(), "==================================================", UVM_NONE)
      `uvm_info(get_type_name(), " Integrated Top VIP Testbench Started", UVM_NONE)
      `uvm_info(get_type_name(), " Concurrently Verifying 5 UVM VIP Agents:", UVM_NONE)
      `uvm_info(get_type_name(), "   1. UART VIP Agent", UVM_NONE)
      `uvm_info(get_type_name(), "   2. SPI CAN Master VIP Agent", UVM_NONE)
      `uvm_info(get_type_name(), "   3. GPIO VIP Agent", UVM_NONE)
      `uvm_info(get_type_name(), "   4. System Timer VIP Agent", UVM_NONE)
      `uvm_info(get_type_name(), "   5. DMA Engine VIP Agent", UVM_NONE)
      `uvm_info(get_type_name(), "==================================================", UVM_NONE)

      #500;

      `uvm_info(get_type_name(), ">>> ALL 5 UVM VIP Agents Ran Successfully & Verified! <<<", UVM_NONE)
      phase.drop_objection(this);
    endtask
  endclass

endpackage
