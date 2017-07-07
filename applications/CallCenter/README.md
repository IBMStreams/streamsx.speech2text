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

## Configuring your Domain and Instance

If you are not running your Network Tap application in distributed mode, you can skip the first two steps and begin at step 3. 
1. You must have your domain controller registered as a system service. You can do this using the following command (you will need root authority): 
	```
	sudo -E $STREAMS_INSTALL/bin/streamtool registerdomainhost --zkconnect <zk-connect-string>
	```
2. Set the following properties: 
	```
	streamtool setproperty instance.runAsUser=$USER
	streamtool setproperty instance.canSetPeOSCapabilities=true
	streamtool setproperty instance.applicationBundlesPath=<some location in /tmp, must be local to the machine (no nfs)> 
	```
	You will have to restart the instance after running these commands: streamtool stopinstance; streamtool startinstance;
3. Set the host tags for the domain. You will want one host tagged "setup" which will do the packet handling and the text transmission. 
Then you will tag the rest of your hosts with watson#, where # is 1-X, where X is the number of hosts for dedicated WatsonSpeech2Text. 
Here is an example of setting up host tags for a domain with 5 application hosts: 
	```
	 streamtool chhost --tags setup host1
	 streamtool chhost --tags watson1 host2
	 streamtool chhost --tags watson2 host3
	 streamtool chhost --tags watson3 host4
	 streamtool chhost --tags watson4 host5
	```
You should now be ready to proceed. 

## Creating a Submittable Package

**NOTE:** You only need to do this step if you are creating a package to be submitted from a host other than the build host. 

Run: `./createCallCenterSubmittablePackage.sh`

This will: 
1. Build all Call Center applications. (You will need the 
2. Create a tar file of all the packages needed to submit the Call Center jobs, including documentation on how to submit them: CallCenterSubmissionBundle.tgz

## Deploying from the CallCenterSubmissionBundle.tgz

For each of the following applications, you can find more detailed submission instructions by looking at the READMEs in the 
corresponding application directory. 

Here is a basic set of deployment steps: 

1. tar xf CallCenterSubmissionBundle.tgz
1. export STREAMS_CALLCENTER_DATA=\<location to write data to\> 
1. Create the following directories: 
	```
	mkdir $STREAMS_CALLCENTER_DATA/packethandler
	mkdir $STREAMS_CALLCENTER_DATA/watson
	mkdir $STREAMS_CALLCENTER_DATA/datacentersink
	mkdir -p $STREAMS_CALLCENTER_DATA/wavgen/moveToDir
	mkdir -p $STREAMS_CALLCENTER_DATA/wavgen/writeBin
	mkdir -p $STREAMS_CALLCENTER_DATA/wavgen/writeWAV
	mkdir -p $STREAMS_CALLCENTER_DATA/wavgen/writeToDir
	```
	(you can also run com.ibm.streamsx.speech2text.callcenter.speechprocessing/mkDefaultDirectories.sh)
2. Submit the Network Tap application (for submission in standalone mode, see README in the application):
	- `cd com.ibm.streamsx.speech2text.callcenter.networktap/`
	- `streamtool submitjob -P networkInterface=eth1 -P connPort=23146` output/com.ibm.streamsx.speech2text.callcenter.networktap.Main.sab
	- If you have issues, make sure you're listening to the right network interface. 	 
3. Submit the SpeechProcessing Applications
	- Modify the necessary properties here:  com.ibm.streamsx.speech2text.callcenter.speechprocessing/etc/properties.cfg 
	For more details on property modification, see the README in com.ibm.streamsx.speech2text.callcenter.speechprocessing
	- `cd com.ibm.streamsx.speech2text.callcenter.speechprocessing/`
	- `./submitJob.sh --job speechprocessing --numWatsonHosts 4 --watsonEngineCountList [10,10,10,10] # places 10 S2T engines on each Watson host`
4. Submit test application
	- `cd com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/`
	- Modify the submit_example.sh script to have the parameters you want. You will need a directory with pcap files to replay. 
	- `Run ./submit_example.sh`
5. Validate that data is flowing by checking the output utterance files and the console. Ensure that the line up with the expected audio in the PCAP files. 
