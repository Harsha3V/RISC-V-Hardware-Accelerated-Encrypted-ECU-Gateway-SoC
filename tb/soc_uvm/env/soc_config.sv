`timescale 1ns/1ps

class soc_config extends uvm_object;
  `uvm_object_utils(soc_config)

  // Virtual interface handles for all 5 SoC peripherals
  virtual uart_if     vif_uart;
  virtual spi_if      vif_spi;
  virtual gpio_if     vif_gpio;
  virtual systimer_if vif_systimer;
  virtual dma_if      vif_dma;

  // Active / Passive configuration settings for VIP agents
  uvm_active_passive_enum is_active_uart     = UVM_ACTIVE;
  uvm_active_passive_enum is_active_spi      = UVM_ACTIVE;
  uvm_active_passive_enum is_active_gpio     = UVM_ACTIVE;
  uvm_active_passive_enum is_active_systimer = UVM_ACTIVE;
  uvm_active_passive_enum is_active_dma      = UVM_PASSIVE;

  function new(string name = "soc_config");
    super.new(name);
  endfunction
endclass
