class dma_monitor extends uvm_monitor;
virtual dma_if vif;
uvm_analysis_port #(dma_item) ap;
`uvm_component_utils(dma_monitor)
function new(string n,uvm_component p); super.new(n,p); ap=new("ap",this); endfunction
endclass
