module tb_top;
import uvm_pkg::*; import systimer_pkg::*;
systimer_if vif();
initial run_test("systimer_test");
endmodule
