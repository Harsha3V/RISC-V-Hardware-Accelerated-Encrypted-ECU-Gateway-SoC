#!/usr/bin/env bash
# =============================================================================
# run_soc_uvm.sh — Compile and Execute Complete SoC-Level UVM Testbench
# =============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJ_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# 1. Setup Synopsys License & Tools
export SNPSLMD_LICENSE_FILE="27021@14.139.1.126"
export VCS_HOME="/home/student/snps_tools_target/vcs/U-2023.03"
export VERDI_HOME="/home/student/snps_tools_target/verdi/U-2023.03-SP1"
export PATH="$VCS_HOME/bin:$VERDI_HOME/bin:$PATH"
export RV_ROOT="$PROJ_ROOT/rtl/Cores-VeeR-EL2"

cd "$SCRIPT_DIR"

# 2. Ensure boot.hex is present for Boot ROM
if [ ! -f "boot.hex" ]; then
    if [ -f "$PROJ_ROOT/sim/boot.hex" ]; then
        cp "$PROJ_ROOT/sim/boot.hex" boot.hex
    elif [ -f "$PROJ_ROOT/test_c/boot.hex" ]; then
        cp "$PROJ_ROOT/test_c/boot.hex" boot.hex
    fi
fi

echo "=========================================================="
echo " [SoC UVM] Compiling Complete SoC UVM Testbench with VCS"
echo "=========================================================="

vcs -full64 -sverilog +define+RV_BUILD_AXI4 \
    -ntb_opts uvm-1.2 \
    -kdb -debug_access+all \
    -P "$VERDI_HOME/share/PLI/VCS/LINUX64/novas.tab" "$VERDI_HOME/share/PLI/VCS/LINUX64/pli.a" \
    +incdir+"$RV_ROOT/configs" \
    +incdir+"$RV_ROOT/design/include" \
    +incdir+"$PROJ_ROOT/rtl/uart/include" \
    +incdir+"$PROJ_ROOT/rtl/aes" \
    +incdir+"$PROJ_ROOT/rtl/interconnect" \
    +incdir+"$PROJ_ROOT/rtl/dma" \
    +incdir+"$PROJ_ROOT/rtl/dma/rtl/inc" \
    +incdir+"$PROJ_ROOT/rtl/dma/bus_arch_sv_pkg" \
    +incdir+"$PROJ_ROOT/rtl/dma/rggen-verilog-rtl" \
    +incdir+"$PROJ_ROOT/tb/vip/uart_uvm_tb" \
    +incdir+"$PROJ_ROOT/tb/vip/spi_uvm_tb" \
    +incdir+"$PROJ_ROOT/tb/vip/gpio_uvm_tb" \
    +incdir+"$PROJ_ROOT/tb/vip/systimer_uvm_tb" \
    +incdir+"$PROJ_ROOT/tb/vip/dma_uvm_tb" \
    +incdir+"$SCRIPT_DIR/../interfaces" \
    +incdir+"$SCRIPT_DIR/../env" \
    -timescale=1ns/1ps \
    -f "$SCRIPT_DIR/run_soc_uvm.f" \
    -top tb_soc_uvm_top \
    -o simv_soc_uvm \
    -l compile_soc_uvm.log

echo "=========================================================="
echo " [SoC UVM] Running Simulation (simv_soc_uvm)..."
echo "=========================================================="

./simv_soc_uvm +UVM_NO_RELNOTES -l run_soc_uvm.log
