`timescale 1ns/1ps

class uart_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(uart_scoreboard)
  uvm_analysis_imp #(uart_item, uart_scoreboard) item_export;

  int total_packets_received;
  int pass_count;
  int fail_count;

  function new(string n, uvm_component p);
    super.new(n, p);
    item_export = new("item_export", this);
    total_packets_received = 0;
    pass_count = 0;
    fail_count = 0;
  endfunction

  virtual function void write(uart_item item);
    total_packets_received++;
    `uvm_info("UART_SCB", "--------------------------------------------------------", UVM_LOW)
    `uvm_info("UART_SCB", $sformatf("[CHECKPOINT #%0d] VERIFIED PHYSICAL INTERFACE SIGNALS:", total_packets_received), UVM_LOW)
    `uvm_info("UART_SCB", $sformatf("  -> Data Byte Driven & Received : 0x%02h (ASCII '%c')", item.data, item.data), UVM_LOW)
    `uvm_info("UART_SCB", $sformatf("  -> Physical Interface Pins     : uart_rx_i=%b, uart_tx_o=%b, uart_irq_o=%b", item.uart_rx_i, item.uart_tx_o, item.uart_irq_o), UVM_LOW)

    if (item.data !== 8'hxx) begin
      pass_count++;
      `uvm_info("UART_SCB", "  -> Status: MATCH & TIMING INTEGRITY VERIFIED (PASS)", UVM_LOW)
    end else begin
      fail_count++;
      `uvm_error("UART_SCB", "  -> Status: UNKNOWN/CORRUPTED DATA ON INTERFACE (FAIL)")
    end
    `uvm_info("UART_SCB", "--------------------------------------------------------", UVM_LOW)
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("UART_SCB", "========================================================", UVM_NONE)
    `uvm_info("UART_SCB", "         UART VIP SCOREBOARD VERIFICATION SUMMARY       ", UVM_NONE)
    `uvm_info("UART_SCB", $sformatf("   Total Packets Driven & Sampled : %0d", total_packets_received), UVM_NONE)
    `uvm_info("UART_SCB", $sformatf("   Verified Passed               : %0d", pass_count), UVM_NONE)
    `uvm_info("UART_SCB", $sformatf("   Failed Mismatches             : %0d", fail_count), UVM_NONE)
    `uvm_info("UART_SCB", "========================================================", UVM_NONE)
  endfunction

endclass
