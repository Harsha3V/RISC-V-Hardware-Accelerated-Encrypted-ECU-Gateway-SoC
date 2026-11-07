`timescale 1ns/1ps

class uart_env extends uvm_env;
  uart_agent agent;
  uart_scoreboard sb;
  `uvm_component_utils(uart_env)

  function new(string n, uvm_component p);
    super.new(n, p);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = uart_agent::type_id::create("agent", this);
    sb = uart_scoreboard::type_id::create("sb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.mon.ap.connect(sb.item_export);
  endfunction
endclass
