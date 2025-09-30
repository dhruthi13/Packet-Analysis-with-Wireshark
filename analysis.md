2) Quick analysis with tshark

Protocol hierarchy:

tshark -r captures/lab_capture.pcapng -q -z io,phs


IP conversations:

tshark -r captures/lab_capture.pcapng -q -z conv,ip


TCP conversations:

tshark -r captures/lab_capture.pcapng -q -z conv,tcp


Top HTTP requests (host + uri):

tshark -r captures/lab_capture.pcapng -Y "http.request" -T fields -e frame.number -e ip.src -e ip.dst -e http.host -
