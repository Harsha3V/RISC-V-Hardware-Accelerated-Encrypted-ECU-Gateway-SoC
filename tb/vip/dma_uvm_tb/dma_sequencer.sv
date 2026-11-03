class dma_sequencer extends uvm_sequencer #(dma_item);
`uvm_component_utils(dma_sequencer)
function new(string n,uvm_component p);super.new(n,p);endfunction
endclass
