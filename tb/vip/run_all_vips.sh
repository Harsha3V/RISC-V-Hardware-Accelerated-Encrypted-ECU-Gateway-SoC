#!/usr/bin/env bash
# =============================================================================
# run_all_vips.sh — Compile and Verify All 5 UVM VIP Testbenches
# =============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SNPSLMD_LICENSE_FILE="27021@14.139.1.126"
export VCS_HOME="/home/student/snps_tools_target/vcs/U-2023.03"
export VERDI_HOME="/home/student/snps_tools_target/verdi/U-2023.03-SP1"
export PATH="$VCS_HOME/bin:$VERDI_HOME/bin:$PATH"

VIPS=("uart" "spi" "gpio" "systimer" "dma")

echo "=========================================================="
echo " Starting Compilation & Simulation of 5 UVM VIP Testbenches"
echo "=========================================================="

PASSED=0
FAILED=0

for vip in "${VIPS[@]}"; do
    VIP_DIR="$SCRIPT_DIR/${vip}_uvm_tb"
    echo ""
    echo "----------------------------------------------------------"
    echo " [VIP Verification] Testing VIP: ${vip}_uvm_tb"
    echo "----------------------------------------------------------"
    cd "$VIP_DIR"

    # Compile with Synopsys VCS UVM-1.2
    vcs -full64 -sverilog -ntb_opts uvm-1.2 -timescale=1ns/1ps \
        "${vip}_if.sv" "${vip}_pkg.sv" tb_top.sv \
        -o "simv_${vip}_uvm" -l "compile_${vip}.log"

    # Execute simulation
    ./simv_${vip}_uvm +UVM_NO_RELNOTES -l "run_${vip}.log"

    if grep -q "UVM_ERROR :    0" "run_${vip}.log" && grep -q "UVM_FATAL :    0" "run_${vip}.log"; then
        echo ">>> [RESULT] VIP ${vip}_uvm_tb: PASSED (0 Errors, 0 Warnings/Fatals)"
        PASSED=$((PASSED + 1))
    else
        echo ">>> [RESULT] VIP ${vip}_uvm_tb: FAILED"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "=========================================================="
echo " UVM VIP Verification Summary: $PASSED / ${#VIPS[@]} PASSED"
echo "=========================================================="

if [ "$FAILED" -eq 0 ]; then
    exit 0
else
    exit 1
fi
