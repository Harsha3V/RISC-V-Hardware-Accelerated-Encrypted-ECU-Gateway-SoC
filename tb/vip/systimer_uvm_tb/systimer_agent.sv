class systimer_agent extends uvm_agent;
systimer_driver drv; systimer_monitor mon; systimer_sequencer seqr;
`uvm_component_utils(systimer_agent)
function new(string n,uvm_component p);super.new(n,p);endfunction
function void build_phase(uvm_phase phase); drv=systimer_driver::type_id::create("drv",this); mon=systimer_monitor::type_id::create("mon",this); seqr=systimer_sequencer::type_id::create("seqr",this); endfunction
function void connect_phase(uvm_phase phase); drv.seq_item_port.connect(seqr.seq_item_export); endfunction
endclass
