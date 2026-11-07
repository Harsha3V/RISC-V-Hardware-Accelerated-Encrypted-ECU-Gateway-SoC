`timescale 1ns/1ps

class soc_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(soc_virtual_sequencer)

  // Sub-sequencer handles to each integrated peripheral VIP sequencer
  uart_sequencer     uart_seqr;
  spi_sequencer      spi_seqr;
  gpio_sequencer     gpio_seqr;
  systimer_sequencer systimer_seqr;
  dma_sequencer      dma_seqr;

  function new(string name = "soc_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass
