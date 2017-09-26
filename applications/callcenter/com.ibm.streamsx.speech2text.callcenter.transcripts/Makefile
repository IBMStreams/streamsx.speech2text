.PHONY: all distributed clean 

SPLC_FLAGS ?= --output-directory output/com.ibm.streamsx.speech2text.callcenter.transcripts --data-directory data -a
SPLC = $(STREAMS_INSTALL)/bin/sc
SPL_CMD_ARGS ?= 
SPL_BUILDER_COMPOSITE = com.ibm.streamsx.speech2text.callcenter.transcripts::TranscriptBuilder
SPL_SINGLECHANNEL_COMPOSITE = com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel::SingleChannelTranscriptAdapter
SPL_CALLCENTER_TYPES = ../com.ibm.streamsx.speech2text.callcenter.types
#SPL_NETWORK_TOOLKIT ?= $(STREAMS_SPLPATH):$(STREAMS_INSTALL)/toolkits/com.ibm.streamsx.network
SPL_NETWORK_TOOLKIT=../../../.network-toolkit/streamsx.network-rtp-dev/com.ibm.streamsx.network/

SPL_TOOLKIT_ARGS = -t $(STREAMS_SPLPATH):$(SPL_NETWORK_TOOLKIT):$(SPL_CALLCENTER_TYPES)

all: transcriptbuilder singlechannel

transcriptbuilder:
	spl-make-toolkit -i $(SPL_CALLCENTER_TYPES)
	$(SPLC) $(SPLC_FLAGS) -M $(SPL_BUILDER_COMPOSITE) $(SPL_CMD_ARGS) $(SPL_TOOLKIT_ARGS)

singlechannel:
	spl-make-toolkit -i $(SPL_CALLCENTER_TYPES)
	$(SPLC) $(SPLC_FLAGS) -M $(SPL_SINGLECHANNEL_COMPOSITE) $(SPL_CMD_ARGS) $(SPL_TOOLKIT_ARGS)

docs:
	spl-make-doc

clean: 
	rm -rf output/*

