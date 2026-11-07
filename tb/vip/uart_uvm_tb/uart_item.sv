`timescale 1ns/1ps

class uart_item extends uvm_sequence_item;
  rand bit [7:0] data;
  rand bit       uart_rx_i;
  bit            uart_tx_o;
  bit            uart_irq_o;

  `uvm_object_utils_begin(uart_item)
    `uvm_field_int(data, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(uart_rx_i, UVM_ALL_ON | UVM_BIN)
    `uvm_field_int(uart_tx_o, UVM_ALL_ON | UVM_BIN)
    `uvm_field_int(uart_irq_o, UVM_ALL_ON | UVM_BIN)
  `uvm_object_utils_end

  function new(string name="uart_item");
    super.new(name);
  endfunction

  virtual function string convert2string();
    return $sformatf("data=0x%02h ('%c') rx_pin=%b tx_pin=%b irq_pin=%b",
                     data, data, uart_rx_i, uart_tx_o, uart_irq_o);
  endfunction
endclass
