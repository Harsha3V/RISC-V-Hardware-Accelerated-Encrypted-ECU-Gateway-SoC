module tb_top;
import uvm_pkg::*; import dma_pkg::*;
dma_if vif();
initial run_test("dma_test");
endmodule
