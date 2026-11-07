class dma_test extends uvm_test;
  dma_env env;
  `uvm_component_utils(dma_test)

  function new(string n, uvm_component p);
    super.new(n, p);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = dma_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "DMA UVM VIP Test started...", UVM_LOW)
    #200;
    `uvm_info(get_type_name(), "DMA UVM VIP Test completed successfully!", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
