.PHONY: all distributed clean 

SPLC_FLAGS ?= --output-directory output/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel.TestSingleChannelTranscriptBuilder/BuildConfig --data-directory data -a
SPLC = $(STREAMS_INSTALL)/bin/sc
SPL_MAKE_TOOLKIT = $(STREAMS_INSTALL)/bin/spl-make-toolkit
SPL_CMD_ARGS ?= 
SPL_MAIN_COMPOSITE = com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel::TestSingleChannelTranscriptBuilder
SPL_CALLCENTER_TYPES = ../../../com.ibm.streamsx.speech2text.callcenter.types
SPL_NETWORK_TOOLKIT ?= $(STREAMS_INSTALL)/toolkits/com.ibm.streamsx.network
CALLCENTER_SINGLECHANNELTRANSCRIPTS = ../../../transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel/


SPL_TOOLKIT_ARGS = -t $(STREAMS_SPLPATH):$(CALLCENTER_SINGLECHANNELTRANSCRIPTS):$(SPL_NETWORK_TOOLKIT):$(SPL_CALLCENTER_TYPES)

all: buildConfig

buildConfig: singleChannelTranscripts
	$(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE) $(SPL_CMD_ARGS) $(SPL_TOOLKIT_ARGS)

singleChannelTranscripts:
	$(SPL_MAKE_TOOLKIT) -i $(CALLCENTER_SINGLECHANNELTRANSCRIPTS)

clean: 
	$(SPLC) $(SPLC_FLAGS) -C -M $(SPL_MAIN_COMPOSITE)

