# Network Tap Application
This application taps a network interface and reads packets directly off of the wire. 


## Building

1. Make sure that com.ibm.streamsx.network 3.1.0+ with RTP operatorstoolkit is available in your $STREAMS_SPLPATH, 
available currently at https://github.com/Alex-Cook4/streamsx.network/tree/rtp-dev toolkits
	```
	$ export STREAMS_SPLPATH=/path/to/network/toolkit:$STREAMS_SPLPATH
	```
2. Run make
	```
	$ make
	```

## Running in Distributed
For complete instructions on setting up your domain/instance and setting OS capabilities, read the [PacketLiveSource requirements](https://www.ibm.com/support/knowledgecenter/en/SSCRJU_4.2.1/com.ibm.streams.toolkits.doc/spldoc/dita/tk$com.ibm.streamsx.network/op$com.ibm.streamsx.network.source$PacketLiveSource.html). 

1. You must have your domain controller registered as a system service. You can do this using the following command (you will need root authority): 
	```
	$ sudo -E $STREAMS_INSTALL/bin/streamtool registerdomainhost --zkconnect <zk-connect-string>
	```
Note: If you are running with an embeddedzk, you must specify the localhost:21810 as your zkconnect string. 

2. Set the following properties: 
	```
	streamtool setproperty instance.runAsUser=$USER
	streamtool setproperty instance.canSetPeOSCapabilities=true
	streamtool setproperty instance.applicationBundlesPath=<some location in /tmp, must be local to the machine (no nfs)> 
	```
	You will have to restart the instance after running these commands: streamtool stopinstance; streamtool startinstance;
3. Submit the job: 
	```
	streamtool submitjob -P networkInterface=eth1 -P connPort=23146 --jobname NetworkTap output/com.ibm.streamsx.speech2text.callcenter.networktap.Main.sab
	```

## Running in Standalone
For complete instructions on setting up standalone job, read the [PacketLiveSource requirements](https://www.ibm.com/support/knowledgecenter/en/SSCRJU_4.2.1/com.ibm.streams.toolkits.doc/spldoc/dita/tk$com.ibm.streamsx.network/op$com.ibm.streamsx.network.source$PacketLiveSource.html). 

The executable created above will need the proper permissions to be able to
read from a network tap ... 

**Code Change**: You will need to uncomment and use the TCP Sink in the NetworkTap application, as well as the 
TCP Source in the PacketHandler application. (Import/Export doesn't work in standalone mode)

To set the permissions on the executable you need sudo authority  

First unbundle the .sab file created

	$ spl-app-info output/com.ibm.streamsx.speech2text.callcenter.networktap.Main.sab --unbundle unbundled

Then set the permission using sudo or run as root  

	$ /usr/sbin/setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' unbundled/output/bin/standalone
 
=====================================

To run the program issue 

Where networkInterace :  eth2 is replaced  with the interface to be monitored. 
 
	$ ./unbundled/output/bin/standalone  networkInterface=eth2  connHost=hostname connPort=23146


