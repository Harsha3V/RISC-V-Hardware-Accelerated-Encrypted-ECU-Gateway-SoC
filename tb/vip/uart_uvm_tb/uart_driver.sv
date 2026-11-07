class uart_driver extends uvm_driver #(uart_item);
  virtual uart_if vif;
  `uvm_component_utils(uart_driver)

  function new(string n, uvm_component p);
    super.new(n, p);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    void'(uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif));
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      if (vif != null) @(posedge vif.clk);
      seq_item_port.item_done();
    end
  endtask
endclass
