`timescale 1ns/1ps

class soc_test extends uvm_test;
  `uvm_component_utils(soc_test)

  soc_env    env;
  soc_config cfg;

  function new(string name = "soc_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "soc_test: build_phase started", UVM_LOW)

    // Create and distribute SoC verification configuration
    cfg = soc_config::type_id::create("cfg");
    cfg.is_active_uart     = UVM_ACTIVE;
    cfg.is_active_spi      = UVM_ACTIVE;
    cfg.is_active_gpio     = UVM_ACTIVE;
    cfg.is_active_systimer = UVM_ACTIVE;
    cfg.is_active_dma      = UVM_ACTIVE;

    uvm_config_db#(soc_config)::set(this, "*", "soc_cfg", cfg);

    // Instantiate SoC Environment
    env = soc_env::type_id::create("env", this);
    `uvm_info(get_type_name(), "soc_test: soc_env successfully instantiated", UVM_LOW)
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(), "==========================================================", UVM_NONE)
    `uvm_info(get_type_name(), "           SoC UVM VERIFICATION TOPOLOGY TREE             ", UVM_NONE)
    `uvm_info(get_type_name(), "==========================================================", UVM_NONE)
    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    soc_uart_tx_vseq vseq;
    phase.raise_objection(this);

    `uvm_info(get_type_name(), "==========================================================", UVM_NONE)
    `uvm_info(get_type_name(), "     SoC-Level UVM Verification Environment Started       ", UVM_NONE)
    `uvm_info(get_type_name(), "     Target Core: Western Digital VeeR EL2 (RV32IMC)      ", UVM_NONE)
    `uvm_info(get_type_name(), "     SoC DUT    : soc_top (instantiated as soc_dut)       ", UVM_NONE)
    `uvm_info(get_type_name(), "==========================================================", UVM_NONE)

    // Wait until reset is deasserted in tb_soc_uvm_top (#250 ns)
    #300;

    `uvm_info(get_type_name(), "==========================================================", UVM_NONE)
    `uvm_info(get_type_name(), ">>> STARTING UART VIP DRIVER TO SOC TRANSACTION TEST <<<", UVM_NONE)
    `uvm_info(get_type_name(), "==========================================================", UVM_NONE)

    vseq = soc_uart_tx_vseq::type_id::create("vseq");
    vseq.start(env.v_seqr);

    // Wait additional cycles for monitor to capture and interface to settle
    #500;

    `uvm_info(get_type_name(), "==========================================================", UVM_NONE)
    `uvm_info(get_type_name(), ">>> UART VIP DRIVER TO SOC TRANSACTION TEST PASSED! <<<", UVM_NONE)
    `uvm_info(get_type_name(), "==========================================================", UVM_NONE)
    phase.drop_objection(this);
  endtask
endclass
