class gpio_item extends uvm_sequence_item;

  rand bit [7:0] gpio_in_i;
  bit [7:0] gpio_out_o;
  bit [7:0] gpio_oe_o;
  bit gpio_irq_o;

  `uvm_object_utils(gpio_item)

  function new(string name="gpio_item"); super.new(name); endfunction
endclass
