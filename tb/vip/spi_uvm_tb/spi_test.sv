class spi_test extends uvm_test;
  spi_env env;
  `uvm_component_utils(spi_test)

  function new(string n, uvm_component p);
    super.new(n, p);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = spi_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "SPI UVM VIP Test started...", UVM_LOW)
    #200;
    `uvm_info(get_type_name(), "SPI UVM VIP Test completed successfully!", UVM_LOW)
    phase.drop_objection(this);
  endtask
endclass
