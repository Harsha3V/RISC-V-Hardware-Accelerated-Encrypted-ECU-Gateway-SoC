`timescale 1ns/1ps

class uart_driver extends uvm_driver #(uart_item);
  virtual uart_if vif;
  `uvm_component_utils(uart_driver)

  function new(string n, uvm_component p);
    super.new(n, p);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "virtual interface 'vif' not set for uart_driver")
    end
  endfunction

  task run_phase(uvm_phase phase);
    // Initialize UART line to idle (High)
    vif.uart_rx_i <= 1'b1;

    // Wait for reset release
    @(posedge vif.rst_n);
    @(posedge vif.clk);
    `uvm_info("UART_DRV", "Reset released. UART Driver initialized in IDLE (rx_i=1)", UVM_LOW)

    forever begin
      seq_item_port.get_next_item(req);
      drive_uart_frame(req);
      seq_item_port.item_done();
    end
  endtask

  task drive_uart_frame(uart_item tr);
    `uvm_info("UART_DRV", $sformatf(">>> DRIVING INTERFACE: Sending Byte 0x%02h ('%c') on vif.uart_rx_i", tr.data, tr.data), UVM_LOW)

    // 1. Start Bit (Low)
    @(posedge vif.clk);
    vif.uart_rx_i <= 1'b0;
    `uvm_info("UART_DRV", "  [START BIT] Drove vif.uart_rx_i = 0", UVM_HIGH)
    repeat (4) @(posedge vif.clk);

    // 2. Eight Data Bits (LSB first)
    for (int i = 0; i < 8; i++) begin
      vif.uart_rx_i <= tr.data[i];
      `uvm_info("UART_DRV", $sformatf("  [DATA BIT %0d] Drove vif.uart_rx_i = %b", i, tr.data[i]), UVM_HIGH)
      repeat (4) @(posedge vif.clk);
    end

    // 3. Stop Bit (High)
    vif.uart_rx_i <= 1'b1;
    `uvm_info("UART_DRV", "  [STOP BIT] Drove vif.uart_rx_i = 1", UVM_HIGH)
    repeat (4) @(posedge vif.clk);

    `uvm_info("UART_DRV", $sformatf("<<< COMPLETED DRIVING: Byte 0x%02h successfully transmitted on interface pin", tr.data), UVM_LOW)
  endtask

endclass
