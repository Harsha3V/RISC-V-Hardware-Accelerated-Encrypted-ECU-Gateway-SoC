`timescale 1ns/1ps

class uart_monitor extends uvm_monitor;
  virtual uart_if vif;
  uvm_analysis_port #(uart_item) ap;
  `uvm_component_utils(uart_monitor)

  function new(string n, uvm_component p);
    super.new(n, p);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "virtual interface 'vif' not set for uart_monitor")
    end
  endfunction

  task run_phase(uvm_phase phase);
    uart_item item;
    @(posedge vif.rst_n);
    `uvm_info("UART_MON", "UART Monitor active and snooping interface signals", UVM_LOW)

    forever begin
      // Wait for Start Bit (falling edge on uart_rx_i)
      @(negedge vif.uart_rx_i);
      `uvm_info("UART_MON", "Detected START bit falling edge on interface pin vif.uart_rx_i", UVM_MEDIUM)

      // Align to middle of start bit (2 cycles after edge)
      repeat (2) @(posedge vif.clk);

      if (vif.uart_rx_i == 1'b0) begin
        item = uart_item::type_id::create("item");

        // Wait to first data bit center (4 cycles)
        repeat (4) @(posedge vif.clk);

        // Sample 8 data bits (center of each bit)
        for (int i = 0; i < 8; i++) begin
          item.data[i] = vif.uart_rx_i;
          `uvm_info("UART_MON", $sformatf("  Sampled bit %0d = %b from interface", i, item.data[i]), UVM_HIGH)
          repeat (4) @(posedge vif.clk);
        end

        // Sample interface output pins
        item.uart_rx_i = vif.uart_rx_i;
        item.uart_tx_o = vif.uart_tx_o;
        item.uart_irq_o = vif.uart_irq_o;

        `uvm_info("UART_MON", $sformatf(">>> MONITORED PACKET: Reconstructed Byte 0x%02h ('%c') from physical interface", item.data, item.data), UVM_LOW)
        ap.write(item);
      end
    end
  endtask

endclass
