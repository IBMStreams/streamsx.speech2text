To test the capturing of packets from  a network tap follow the below
instructions. 

===================================

Compile the program in standalone mode
1. Make sure that version 2.8.3 of the com.ibm.streamsx.network toolkit is available in your $STREAMS_SPLPATH
	export STREAMS_SPLPATH=/path/to/network/toolkit:$STREAMS_SPLPATH
2. Run make
	$ make 

===================================== 

The executable created above will need the proper permissions to be able to
read from a network tap ... 

To set the permissions on the executable you need sudo authority  

First unbundle the .sab file created 

spl-app-info output/com.ibm.streamsx.speech2text.networktap.Main.sab --unbundle unbundled

Then set the permission using sudo or run as root  

/usr/sbin/setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' unbundled/output/bin/standalone
 
=====================================

To run the program issue 

Where networkInterace :  eth2 is replaced  with the interface to be monitored. 
 
 ./unbundled/output/bin/standalone  networkInterface=eth2  connHost=hostname connPort=23146
