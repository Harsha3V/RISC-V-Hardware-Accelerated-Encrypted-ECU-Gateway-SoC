#!/usr/bin/env bash
# =============================================================================
# view_waveform.sh — Open Native FSDB Waveform in Synopsys Verdi (Ultra Mode)
# =============================================================================

export SNPSLMD_LICENSE_FILE="27021@14.139.1.126"
export VCS_HOME="/home/student/snps_tools_target/vcs/U-2023.03"
export VERDI_HOME="/home/student/snps_tools_target/verdi/U-2023.03-SP1"
export PATH="$VERDI_HOME/bin:$VCS_HOME/bin:$PATH"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

FSDB_FILE="dump.fsdb"

if [ ! -f "$FSDB_FILE" ]; then
    echo "[INFO] dump.fsdb not found. Running simulation with native FSDB dumping..."
    vcs -full64 -sverilog -ntb_opts uvm-1.2 -kdb -debug_access+all -timescale=1ns/1ps \
        -P $VERDI_HOME/share/PLI/VCS/LINUX64/novas.tab $VERDI_HOME/share/PLI/VCS/LINUX64/pli.a \
        uart_if.sv uart_pkg.sv tb_top.sv -o simv_uart_uvm
    ./simv_uart_uvm +UVM_NO_RELNOTES
fi

echo "[INFO] Launching Synopsys Verdi with $FSDB_FILE in Ultra mode..."
verdi -Ultra -ssf "$FSDB_FILE" &
