2) Quick analysis with tshark

Protocol hierarchy:

tshark -r captures/lab_capture.pcapng -q -z io,phs


IP conversations:

tshark -r captures/lab_capture.pcapng -q -z conv,ip


TCP conversations:

tshark -r captures/lab_capture.pcapng -q -z conv,tcp


Top HTTP requests (host + uri):

tshark -r captures/lab_capture.pcapng -Y "http.request" -T fields -e frame.number -e ip.src -e ip.dst -e http.host -e http.request.uri

3) Extract files and credentials (lab-only)

Export HTTP objects via GUI: File -> Export Objects -> HTTP.

CLI options: use tcpflow to reconstruct streams:

tcpflow -r captures/lab_capture.pcapng -o tcpflow_out/


To look for plaintext credentials (http basic auth / form posts):

tshark -r captures/lab_capture.pcapng -Y "http.request or http.request.method == \"POST\"" -T fields -e ip.src -e ip.dst -e http.file_data -e http.authorization

4) Automated summary (pcap_analysis.sh)

Script runs a set of tshark commands producing:

protocol summary

top talkers (by bytes)

top ports

TCP/UDP conversation lists

5) Evidence handling

Keep original PCAP in captures/ (do not commit if it contains sensitive data).

Commit sanitized summaries: text summaries, extracted IOCs, screenshots of Wireshark with annotations only.
