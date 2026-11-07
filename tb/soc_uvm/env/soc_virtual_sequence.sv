`timescale 1ns/1ps

class soc_virtual_sequence extends uvm_sequence;
  `uvm_object_utils(soc_virtual_sequence)
  `uvm_declare_p_sequencer(soc_virtual_sequencer)

  function new(string name = "soc_virtual_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("SOC_VSEQ", "Base soc_virtual_sequence started — coordinating 5 VIP sub-sequencers", UVM_LOW)
    #100;
    `uvm_info("SOC_VSEQ", "Base soc_virtual_sequence completed successfully", UVM_LOW)
  endtask
endclass

// =============================================================================
// soc_uart_tx_vseq: Virtual sequence that drives test transactions via UART VIP
// =============================================================================
class soc_uart_tx_vseq extends soc_virtual_sequence;
  `uvm_object_utils(soc_uart_tx_vseq)

  function new(string name = "soc_uart_tx_vseq");
    super.new(name);
  endfunction

  virtual task body();
    uart_driver_seq u_seq;
    `uvm_info("SOC_VSEQ", "==========================================================", UVM_NONE)
    `uvm_info("SOC_VSEQ", " >>> STARTING UART VIP TRANSACTION ONTO SOC INTERFACE <<<", UVM_NONE)
    `uvm_info("SOC_VSEQ", "==========================================================", UVM_NONE)

    u_seq = uart_driver_seq::type_id::create("u_seq");
    u_seq.start(p_sequencer.uart_seqr);

    `uvm_info("SOC_VSEQ", "==========================================================", UVM_NONE)
    `uvm_info("SOC_VSEQ", " >>> UART VIP TRANSACTION TO SOC COMPLETED SUCCESSFULLY <<<", UVM_NONE)
    `uvm_info("SOC_VSEQ", "==========================================================", UVM_NONE)
  endtask
endclass
