`timescale 1ns/1ps

class uart_driver_seq extends uvm_sequence #(uart_item);
  `uvm_object_utils(uart_driver_seq)

  function new(string name="uart_driver_seq");
    super.new(name);
  endfunction

  task body();
    byte test_payload[5] = '{8'h41, 8'h45, 8'h53, 8'hA5, 8'h5A}; // 'A', 'E', 'S', 0xA5, 0x5A

    `uvm_info("UART_SEQ", "Starting Sequence: Injecting 5 data frames to Driver...", UVM_LOW)

    for (int i = 0; i < 5; i++) begin
      req = uart_item::type_id::create($sformatf("req_%0d", i));
      start_item(req);
      req.data = test_payload[i];
      req.uart_rx_i = 1'b1;
      finish_item(req);
      #50; // inter-frame gap
    end

    `uvm_info("UART_SEQ", "Sequence finished: All 5 test frames delivered to Driver.", UVM_LOW)
  endtask
endclass
