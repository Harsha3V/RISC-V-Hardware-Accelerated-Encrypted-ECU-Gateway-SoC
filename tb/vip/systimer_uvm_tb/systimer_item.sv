class systimer_item extends uvm_sequence_item;

  rand bit timer_ctr_in_i;
  bit timer_irq_o;

  `uvm_object_utils(systimer_item)

  function new(string name="systimer_item"); super.new(name); endfunction
endclass
