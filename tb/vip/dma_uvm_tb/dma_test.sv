class dma_test extends uvm_test;
dma_env env;
`uvm_component_utils(dma_test)
function new(string n,uvm_component p);super.new(n,p);endfunction
function void build_phase(uvm_phase phase); env=dma_env::type_id::create("env",this); endfunction
endclass
