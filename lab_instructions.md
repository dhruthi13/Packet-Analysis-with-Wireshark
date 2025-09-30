# Lab Instructions — Packet Capture & Analysis (Wireshark / tshark)

> Read ethics & safety in root README: only capture on lab networks or authorized systems.

## 1) Capture traffic (use dumpcap or tshark)
- Use `dumpcap` (part of Wireshark) for reliable capture as non-root where possible.
- Example short capture (interface `eth0`, 60 seconds):
```bash
sudo dumpcap -i eth0 -a duration:60 -w captures/lab_capture.pcapng
