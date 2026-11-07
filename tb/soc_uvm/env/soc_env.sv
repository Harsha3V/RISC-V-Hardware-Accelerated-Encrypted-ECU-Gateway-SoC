`timescale 1ns/1ps

class soc_env extends uvm_env;
  `uvm_component_utils(soc_env)

  soc_config            cfg;
  soc_virtual_sequencer v_seqr;

  // The 5 Integrated SoC Peripheral VIP Agents
  uart_agent     uart_agt;
  spi_agent      spi_agt;
  gpio_agent     gpio_agt;
  systimer_agent systimer_agt;
  dma_agent      dma_agt;

  function new(string name = "soc_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Retrieve SoC Configuration
    if (!uvm_config_db#(soc_config)::get(this, "", "soc_cfg", cfg)) begin
      `uvm_info("SOC_ENV", "soc_config not found in config_db; creating default instance", UVM_MEDIUM)
      cfg = soc_config::type_id::create("cfg");
    end

    // Distribute virtual interface handles to respective VIP agents
    if (cfg.vif_uart != null) begin
      uvm_config_db#(virtual uart_if)::set(this, "uart_agt*", "vif", cfg.vif_uart);
    end
    if (cfg.vif_spi != null) begin
      uvm_config_db#(virtual spi_if)::set(this, "spi_agt*", "vif", cfg.vif_spi);
    end
    if (cfg.vif_gpio != null) begin
      uvm_config_db#(virtual gpio_if)::set(this, "gpio_agt*", "vif", cfg.vif_gpio);
    end
    if (cfg.vif_systimer != null) begin
      uvm_config_db#(virtual systimer_if)::set(this, "systimer_agt*", "vif", cfg.vif_systimer);
    end
    if (cfg.vif_dma != null) begin
      uvm_config_db#(virtual dma_if)::set(this, "dma_agt*", "vif", cfg.vif_dma);
    end

    // Instantiate all 5 peripheral VIP agents
    uart_agt     = uart_agent::type_id::create("uart_agt", this);
    spi_agt      = spi_agent::type_id::create("spi_agt", this);
    gpio_agt     = gpio_agent::type_id::create("gpio_agt", this);
    systimer_agt = systimer_agent::type_id::create("systimer_agt", this);
    dma_agt      = dma_agent::type_id::create("dma_agt", this);

    // Instantiate SoC Virtual Sequencer
    v_seqr       = soc_virtual_sequencer::type_id::create("v_seqr", this);

    `uvm_info("SOC_ENV", "soc_env: all 5 VIP agents and virtual sequencer successfully constructed", UVM_LOW)
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect individual VIP sequencers into the virtual sequencer handles
    v_seqr.uart_seqr     = uart_agt.seqr;
    v_seqr.spi_seqr      = spi_agt.seqr;
    v_seqr.gpio_seqr     = gpio_agt.seqr;
    v_seqr.systimer_seqr = systimer_agt.seqr;
    v_seqr.dma_seqr      = dma_agt.seqr;

    `uvm_info("SOC_ENV", "soc_env: all 5 VIP sequencers connected to soc_virtual_sequencer", UVM_LOW)
  endfunction
endclass
