
---

### `TASK4-Packet-Analysis/pcap_capture.sh`
```bash
#!/usr/bin/env bash
# pcap_capture.sh - simple wrapper around dumpcap for timed capture
# Usage: sudo ./pcap_capture.sh <iface> <duration_seconds> <label>
set -e

IFACE="$1"
DURATION="${2:-60}"
LABEL="${3:-capture}"

if [[ -z "$IFACE" ]]; then
  echo "Usage: sudo $0 <iface> <duration_seconds> <label>"
  exit 1
fi

OUTDIR="captures"
mkdir -p "$OUTDIR"

OUTFILE="${OUTDIR}/${LABEL}_$(date +%Y%m%dT%H%M%S).pcapng"

echo "[+] Capturing on $IFACE for ${DURATION}s -> $OUTFILE"
sudo dumpcap -i "$IFACE" -a duration:"$DURATION" -w "$OUTFILE"

echo "[+] Capture complete: $OUTFILE"
