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
    void'(uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif));
  endfunction
endclass
