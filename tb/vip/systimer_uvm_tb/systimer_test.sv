class systimer_test extends uvm_test;
systimer_env env;
`uvm_component_utils(systimer_test)
function new(string n,uvm_component p);super.new(n,p);endfunction
function void build_phase(uvm_phase phase); env=systimer_env::type_id::create("env",this); endfunction
endclass
