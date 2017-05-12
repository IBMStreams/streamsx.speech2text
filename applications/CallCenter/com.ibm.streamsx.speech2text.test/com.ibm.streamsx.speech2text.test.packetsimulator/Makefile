.PHONY: all distributed clean 

SPLC_FLAGS ?= --output-directory output/com.ibm.streamsx.speech2text.test.packetsimulator.PacketSimulator/BuildConfig --data-directory data -a
SPLC = $(STREAMS_INSTALL)/bin/sc
SPL_CMD_ARGS ?= 
SPL_MAIN_COMPOSITE = com.ibm.streamsx.speech2text.test.packetsimulator::PacketSimulator
SPL_NETWORK_TOOLKIT = $(STREAMS_INSTALL)/toolkits/com.ibm.streamsx.network 
SPL_TOOLKIT_ARGS = -t $(SPL_NETWORK_TOOLKIT)

all: distributed

distributed:
	$(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE) $(SPL_CMD_ARGS) $(SPL_TOOLKIT_ARGS)

clean: 
	$(SPLC) $(SPLC_FLAGS) -C -M $(SPL_MAIN_COMPOSITE)

