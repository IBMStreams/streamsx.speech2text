## begin_generated_IBM_copyright_prolog
.PHONY: all clean
SPLC = $(STREAMS_INSTALL)/bin/sc
SPLC_FLAGS = -a 

SPL_MAIN_COMPOSITE          = com.ibm.streamsx.speech2text.callcenter.speechprocessing.packethandler::PacketHandler
SPL_MAIN_COMPOSITE_OUTDATA  = com.ibm.streamsx.speech2text.callcenter.speechprocessing.datacentersink::DataCenterSink
SPL_MAIN_COMPOSITE_WATSON   = com.ibm.streamsx.speech2text.callcenter.speechprocessing.watsons2t::WatsonSpeech2Text
SPL_MAIN_COMPOSITE_WAV      = com.ibm.streamsx.speech2text.callcenter.speechprocessing.wavgen::WavGenerator
SPL_DATA_DIR ?= ./data
CALLCENTER_TYPES_TOOLKIT=../com.ibm.streamsx.speech2text.callcenter.types
SPEECH2TEXT_HELPER_TOOLKIT=../../../com.ibm.streamsx.speech2text/
NETWORK_TOOLKIT=../../../.network-toolkit/streamsx.network-rtp-dev/com.ibm.streamsx.network/
SPL_CMD_ARGS ?= -t $(STREAMS_STUDIO_SPL_PATH):$(STREAMS_SPLPATH):$(CALLCENTER_TYPES_TOOLKIT):$(SPEECH2TEXT_HELPER_TOOLKIT):$(NETWORK_TOOLKIT)
BIN_LOC=impl/java/bin
JSI = $(STREAMS_INSTALL)

all: packethandler datacentersink watson wavgenerator
$(BIN_LOC):
	 mkdir -p $(BIN_LOC)

packethandler: packethandler_
packethandler_:
	 ${SPLC} $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE) --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS)  --output-directory output/packethandler

datacentersink: datacentersink_
datacentersink_:
	 ${SPLC} $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_OUTDATA) --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/datacentersink

watson: watson_
watson_:
	 $(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WATSON)  --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/watsonspeech2text

wavgenerator: wavgen
wavgen:
	mkdir -p impl/java/bin/
	$(STREAMS_INSTALL)/java/bin/javac -cp $(STREAMS_INSTALL)/lib/com.ibm.streams.operator.jar:impl/java/lib/* impl/java/src/com/ibm/streamsx/speech2text/callcenter/speechprocessing/wavgen/*.java -d impl/java/bin/ 
	$(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WAV) --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/wavgen

clean:
	  rm -rf $(BIN_LOC)/*
	  rm -rf output
