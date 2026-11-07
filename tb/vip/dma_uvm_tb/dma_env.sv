class dma_env extends uvm_env;
  dma_agent agent;
  dma_scoreboard sb;
  `uvm_component_utils(dma_env)

  function new(string n, uvm_component p);
    super.new(n, p);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = dma_agent::type_id::create("agent", this);
    sb = dma_scoreboard::type_id::create("sb", this);
  endfunction
endclass
