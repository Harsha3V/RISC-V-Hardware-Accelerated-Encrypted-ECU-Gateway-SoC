`timescale 1ns/1ps

class uart_test extends uvm_test;
  uart_env env;
  uart_driver_seq seq;

  `uvm_component_utils(uart_test)

  function new(string n, uvm_component p);
    super.new(n, p);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = uart_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "==========================================================", UVM_LOW)
    `uvm_info(get_type_name(), " [TEST] Starting UART Interface Driving Verification Test", UVM_LOW)
    `uvm_info(get_type_name(), "==========================================================", UVM_LOW)

    seq = uart_driver_seq::type_id::create("seq");
    seq.start(env.agent.seqr);

    #200; // Allow monitor and scoreboard to finish processing final bit

    `uvm_info(get_type_name(), "==========================================================", UVM_LOW)
    `uvm_info(get_type_name(), " [TEST] UART Interface Driving Verification COMPLETE!", UVM_LOW)
    `uvm_info(get_type_name(), "==========================================================", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
