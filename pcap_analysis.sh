#!/usr/bin/env bash
# pcap_analysis.sh - quick automated tshark summary for a pcap file
# Usage: ./pcap_analysis.sh captures/yourfile.pcapng
set -e

PCAP="$1"
OUTDIR="analysis"
mkdir -p "$OUTDIR"

if [[ -z "$PCAP" ]]; then
  echo "Usage: $0 <pcap-file>"
  exit 1
fi

BASENAME=$(basename "$PCAP" | sed 's/\\.[^.]*$//')
SUMMARY="${OUTDIR}/${BASENAME}_summary.txt"

echo "[+] Generating summary -> $SUMMARY"
{
  echo "PCAP Analysis Summary for $PCAP"
  echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "----------------------------------------"
  echo ""
  echo "Protocol hierarchy:"
  tshark -r "$PCAP" -q -z io,phs 2>/dev/null || echo "protocol hierarchy not available"
  echo ""
  echo "Top IP conversations (IP):"
  tshark -r "$PCAP" -q -z conv,ip 2>/dev/null
  echo ""
  echo "Top TCP conversations:"
  tshark -r "$PCAP" -q -z conv,tcp 2>/dev/null
  echo ""
  echo "Top UDP conversations:"
  tshark -r "$PCAP" -q -z conv,udp 2>/dev/null
  echo ""
  echo "Top ports by packet count:"
  tshark -r "$PCAP" -T fields -e tcp.dstport -e udp.dstport 2>/dev/null | awk '{if ($1!="") print $1; if ($2!="") print $2}' | sort | uniq -c | sort -nr | head -n 20
  echo ""
  echo "HTTP requests (host + uri):"
  tshark -r "$PCAP" -Y "http.request" -T fields -e frame.number -e ip.src -e ip.dst -e http.host -e http.request.uri 2>/dev/null | head -n 50
  echo ""
  echo "Potential credentials in cleartext (http fields / basic auth / form data):"
  tshark -r "$PCAP" -Y "http.authbasic or http.request.method == \"POST\"" -T fields -e frame.number -e ip.src -e ip.dst -e http.authorization -e http.file_data 2>/dev/null | head -n 50
} > "$SUMMARY"

echo "[+] Summary saved to $SUMMARY"
