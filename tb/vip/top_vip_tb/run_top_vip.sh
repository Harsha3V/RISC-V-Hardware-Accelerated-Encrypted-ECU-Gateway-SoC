#!/usr/bin/env bash
# =============================================================================
# run_top_vip.sh — Compile and Run Integrated Top UVM VIP Testbench
# =============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VIP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

export SNPSLMD_LICENSE_FILE="27021@14.139.1.126"
export VCS_HOME="/home/student/snps_tools_target/vcs/U-2023.03"
export VERDI_HOME="/home/student/snps_tools_target/verdi/U-2023.03-SP1"
export PATH="$VCS_HOME/bin:$VERDI_HOME/bin:$PATH"

cd "$SCRIPT_DIR"

echo "=========================================================="
echo " Compiling Integrated Top VIP Testbench (tb_vip_top)"
echo "=========================================================="

vcs -full64 -sverilog -ntb_opts uvm-1.2 -timescale=1ns/1ps \
    +incdir+"$VIP_DIR/uart_uvm_tb" \
    +incdir+"$VIP_DIR/spi_uvm_tb" \
    +incdir+"$VIP_DIR/gpio_uvm_tb" \
    +incdir+"$VIP_DIR/systimer_uvm_tb" \
    +incdir+"$VIP_DIR/dma_uvm_tb" \
    +incdir+"$SCRIPT_DIR" \
    "$VIP_DIR/uart_uvm_tb/uart_if.sv" "$VIP_DIR/uart_uvm_tb/uart_pkg.sv" \
    "$VIP_DIR/spi_uvm_tb/spi_if.sv" "$VIP_DIR/spi_uvm_tb/spi_pkg.sv" \
    "$VIP_DIR/gpio_uvm_tb/gpio_if.sv" "$VIP_DIR/gpio_uvm_tb/gpio_pkg.sv" \
    "$VIP_DIR/systimer_uvm_tb/systimer_if.sv" "$VIP_DIR/systimer_uvm_tb/systimer_pkg.sv" \
    "$VIP_DIR/dma_uvm_tb/dma_if.sv" "$VIP_DIR/dma_uvm_tb/dma_pkg.sv" \
    top_vip_pkg.sv tb_vip_top.sv \
    -o simv_top_vip -l compile_top_vip.log

echo "=========================================================="
echo " Executing Integrated Top VIP Testbench (simv_top_vip)"
echo "=========================================================="

./simv_top_vip +UVM_NO_RELNOTES -l run_top_vip.log
