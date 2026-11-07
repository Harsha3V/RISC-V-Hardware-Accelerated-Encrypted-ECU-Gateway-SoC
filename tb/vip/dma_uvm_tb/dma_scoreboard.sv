class dma_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(dma_scoreboard)
  function new(string n, uvm_component p);
    super.new(n, p);
  endfunction
endclass
