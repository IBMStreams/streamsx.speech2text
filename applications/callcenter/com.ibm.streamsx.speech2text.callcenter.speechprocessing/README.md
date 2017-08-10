# Speech Processing Applications

This set of jobs is for processing live RTP packets and transcribing the audio into text. 

## Job descriptions (associated parameter descriptions): 

**PacketHander** - Gets RTP traffic from the Network Tap application using a TCPSource. 
The RTP packets are then filtered for just audio and sent onwards using Exports. 
The packets are then passes through a ControlFlow composite that directs them to the WatsonS2T
engine that is designated for transcribing that audio stream or designates an open WatsonS2T engine
to begin processing the stream. If the stream isn't being processed, and no WatsonS2T engines are 
available, the packet will be dropped. 

**WatsonSpeech2TextX** - Each of the Watson jobs are designed to process incoming RAW audio streams on a single host. 
The number of engines and the number of hosts to use can be configured at submit-time using the ./submitJob.sh script.
Or by using submit-time parameters for individual job submission. 

**DataCenterSink** - This job takes merges the data from all of the watsonX jobs, and sends them out via a 
TCPSink. 

**WavGenerator** - This job is not considered part of the "core group" and as such is not submitted with the "all" or "callcenter" options 
on the submitJob.sh script. This job allows for saving the calls processed to .wav files for later playback or processing. This 
application requires an installation of FFMPEG on the system being deployed to. 


## Environment Setup: 

1. Run ant from the root of this repository to build the com.ibm.streamsx.speech2text and to download/build the correct version of the Network toolkit:
	ant
2. Refer to the Configuring your Domain and Instance README at the root of the CallCenter application directory 
for domain and instance setup. 

## Compilation

To compile this application run 

	$ make  

## Submitting Jobs

Submit the application - Use the submitJob.sh script for ease of deployment, or see the submit_example.sh for an example of submitjob commands.

Before submitting:
1. Ensure you have set the STREAMS_CALLCENTER_DATA environment variable.
	export STREAMS_CALLCENTER_DATA=\<location to write data to\>
2. Make sure the directories are created. You can use the mkDefaultDirectories.sh script. 
3. Update the self-documenting etc/properties.cfg file to point to the correct Watson model/config location

Example commands and descriptions:
 
 Submit packethandler,watson1, watson2, watson3, and datacentersink -- watson1 with 1 speech2text engines running, watson2 with 2 speech2text engines running,
 watson3 with 3 speech2text engines running
 
	$ ./submitJob.sh -j speechprocessing --numWatsonHosts 3 --watsonEngineCountList [1,2,3]
 
 Submit just packethandler, but configured for connecting to watson1 with 1 speech2text engine running, watson2 with 2 speech2text engines running,
 watson3 with 3 speech2text engines running
 
	$ ./submitJob.sh -j packethandler --numWatsonHosts 3 --watsonEngineCountList [1,2,3]
 
 Submit watson jobs: -- watson1 with 1 speech2text engines running, watson2 with 2 speech2text engines running,
 watson3 with 3 speech2text engines running
 
	$ ./submitJob.sh -j watson --numWatsonHosts 3 --watsonEngineCountList [1,2,3]
 
 Submit datacentersink -- no dependencies for this one. 
 
	$ ./submitJob.sh -j datacentersink
 
 Submit wavgen -- no dependencies for this one. 
 
	$ ./submitJob.sh -j wavgen
 
 ## Host Placement
 
 Each of the jobs can be placed on a host of your choice by tagging that host with the tag 
 corresponding to the job. The tags can by modified without recompiling by modifying the 
 "targetTagSet" attribute in the etc/<job-name>JobConfig.json file. 
 
 ## Diarization
 
 The components needed to incorporate diarization into the Call Center solution have 
 been commented out. These can be uncommented and model changed to point to a model/config
 that support diarization. 
