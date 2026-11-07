class systimer_env extends uvm_env;
  systimer_agent agent;
  systimer_scoreboard sb;
  `uvm_component_utils(systimer_env)

  function new(string n, uvm_component p);
    super.new(n, p);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = systimer_agent::type_id::create("agent", this);
    sb = systimer_scoreboard::type_id::create("sb", this);
  endfunction
endclass
