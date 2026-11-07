#!/usr/bin/env bash
# =============================================================================
# view_waveform.sh — Launch Synopsys Verdi with required environment variables
# =============================================================================

export SNPSLMD_LICENSE_FILE="27021@14.139.1.126"
export LM_LICENSE_FILE="27021@14.139.1.126"
export VCS_HOME="/home/student/snps_tools_target/vcs/U-2023.03"
export VERDI_HOME="/home/student/snps_tools_target/verdi/U-2023.03-SP1"
export PATH="$VERDI_HOME/bin:$VCS_HOME/bin:$PATH"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FSDB_FILE="${1:-$SCRIPT_DIR/dump_soc_uvm.fsdb}"

if [ ! -f "$FSDB_FILE" ]; then
    echo "[ERROR] FSDB file not found: $FSDB_FILE"
    exit 1
fi

echo "Launching Verdi for: $FSDB_FILE ..."
"$VERDI_HOME/bin/verdi" -Ultra -ssf "$FSDB_FILE" &
