# Call Center Application

This Call Center Application provides the ability to tap a network card for RTP packet 
streams, filter those streams for G711 audio, distribute those audio streams in order to process large
numbers of streams simultaneously, and converting those audio streams to text before sending
the results via TCP. 

This application can be modified to fit the size of your environment by providing compile-time 
arguments for the number of hosts and the number of engines to run on each host. 

Check out this video about how Verizon is using this solution: https://youtu.be/Zg-_BJt6jdc

Requirements:
1. atlas, atlas-devel, libcap-devel, libpcap-devel packages (use yum install)
2. com.ibm.streams.speech2text (included as a separate download with the product) and com.ibm.streamsx.network 3.1.0+ with RTP operators, 
available currently https://github.com/Alex-Cook4/streamsx.network/tree/rtp-dev toolkits. 

This code was originally designed and contributed by John Santosuosso (@jjbosox). 
