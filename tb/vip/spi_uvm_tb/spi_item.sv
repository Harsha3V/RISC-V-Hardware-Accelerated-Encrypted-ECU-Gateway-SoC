class spi_item extends uvm_sequence_item;

  bit spi_clk_o;
  bit spi_mosi_o;
  rand bit spi_miso_i;
  bit spi_cs_n_o;

  `uvm_object_utils(spi_item)

  function new(string name="spi_item"); super.new(name); endfunction
endclass
