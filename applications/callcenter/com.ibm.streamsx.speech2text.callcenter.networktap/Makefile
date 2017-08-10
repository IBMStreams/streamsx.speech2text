# begin_generated_IBM_copyright_prolog                             
#                                                                  
# This is an automatically generated copyright prolog.             
# After initializing,  DO NOT MODIFY OR MOVE                       
# **************************************************************** 
# THIS SAMPLE CODE IS PROVIDED ON AN "AS IS" BASIS. IBM MAKES NO   
# REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED, CONCERNING    
# USE OF THE SAMPLE CODE, OR THE COMPLETENESS OR ACCURACY OF THE   
# SAMPLE CODE. IBM DOES NOT WARRANT UNINTERRUPTED OR ERROR-FREE    
# OPERATION OF THIS SAMPLE CODE. IBM IS NOT RESPONSIBLE FOR THE    
# RESULTS OBTAINED FROM THE USE OF THE SAMPLE CODE OR ANY PORTION  
# OF THIS SAMPLE CODE.                                             
#                                                                  
# LIMITATION OF LIABILITY. IN NO EVENT WILL IBM BE LIABLE TO ANY   
# PARTY FOR ANY DIRECT, INDIRECT, SPECIAL OR OTHER CONSEQUENTIAL   
# DAMAGES FOR ANY USE OF THIS SAMPLE CODE, THE USE OF CODE FROM    
# THIS [ SAMPLE PACKAGE,] INCLUDING, WITHOUT LIMITATION, ANY LOST  
# PROFITS, BUSINESS INTERRUPTION, LOSS OF PROGRAMS OR OTHER DATA   
# ON YOUR INFORMATION HANDLING SYSTEM OR OTHERWISE.                
#                                                                  
# (C) Copyright IBM Corp. 2010, 2014  All Rights reserved.         
#                                                                  
# end_generated_IBM_copyright_prolog                               
.PHONY: all clean 

SPLC = $(STREAMS_INSTALL)/bin/sc
#SPLC_FLAGS = -a  -t /home/streamsadmin/IBMStreams-streamsx.network-5fefa2f/com.ibm.streamsx.network:

SPLC_FLAGS = -a
NETWORK_TOOLKIT=../../../.network-toolkit/streamsx.network-rtp-dev/com.ibm.streamsx.network/


ifeq ($(STREAMS_STUDIO_BUILDING), 1)
  # Building from Streams Studio
#  SPLC_FLAGS += i--no-toolkit-indexing 
endif
SPL_MAIN_COMPOSITE = com.ibm.streamsx.speech2text.callcenter.networktap::Main
SPL_DATA_DIR ?= ./data
SPL_CMD_ARGS ?= 1  1

JSI = $(STREAMS_INSTALL)

all: BuildConfig

BuildConfig:
	chmod +x $(NETWORK_TOOLKIT)/impl/bin/libpcapPath.pl
	$(SPLC) $(SPLC_FLAGS) -t $(NETWORK_TOOLKIT):../com.ibm.streamsx.speech2text.callcenter.types -M $(SPL_MAIN_COMPOSITE) --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS)

clean: 
	$(SPLC) $(SPLC_FLAGS) -C -M $(SPL_MAIN_COMPOSITE)

