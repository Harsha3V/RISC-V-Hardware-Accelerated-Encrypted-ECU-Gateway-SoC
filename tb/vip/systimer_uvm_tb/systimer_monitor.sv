class systimer_monitor extends uvm_monitor;
  virtual systimer_if vif;
  uvm_analysis_port #(systimer_item) ap;
  `uvm_component_utils(systimer_monitor)

  function new(string n, uvm_component p);
    super.new(n, p);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    void'(uvm_config_db#(virtual systimer_if)::get(this, "", "vif", vif));
  endfunction
endclass
