This set of jobs is for processing live RTP packets and transcribing the audio into text. 

=====================================

Job descriptions: 

**setup** - Gets RTP traffic from the Network Tap application using a TCPSource. 
The RTP packets are then filtered for just audio and sent onwards using Exports. 
The packets are then passes through a ControlFlow composite that directs them to the WatsonS2T
engine that is designated for transcribing that audio stream or designates an open WatsonS2T engine
to begin processing the stream. If the stream isn't being processed, and no WatsonS2T engines are 
available, the packet will be dropped. 

**watsonX** - Each of the Watson jobs are designed to process incoming RAW audio streams on a single host. 
The number of engines and the number of hosts to use can be configured in the Makefile. Typically, for 
live processing you can have 2 WatsonS2T engines per core. 

**outdata** - This job takes merges the data from all of the watsonX jobs, and sends them out via a 
TCPSink. 

=====================================

Environment: 

1. Make sure that version 3.0.5 of the com.ibm.streamsx.network toolkit is available in your $STREAMS_SPLPATH, 
along with the com.ibm.streams.speech2text toolkit. 
	export STREAMS_SPLPATH=/path/to/network/toolkit:/path/to/speech2text/toolkit$STREAMS_SPLPATH

=====================================

To compile this application run 

	$ make all 

=====================================

Submit the application - See the submit_example.sh for an example of submitjob commands.
