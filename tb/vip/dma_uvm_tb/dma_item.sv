class dma_item extends uvm_sequence_item;

  bit dma_done_o;
  bit dma_error_o;

  `uvm_object_utils(dma_item)

  function new(string name="dma_item");
    super.new(name);
  endfunction
endclass
