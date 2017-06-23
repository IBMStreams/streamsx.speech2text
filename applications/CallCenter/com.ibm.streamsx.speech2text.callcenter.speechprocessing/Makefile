## begin_generated_IBM_copyright_prolog
.PHONY: all clean
SPLC = $(STREAMS_INSTALL)/bin/sc
SPLC_FLAGS = -a 

SPL_MAIN_COMPOSITE          = com.ibm.streamsx.speech2text.speechprocessing.callcenter.packethandler::PacketHandler
SPL_MAIN_COMPOSITE_OUTDATA  = com.ibm.streamsx.speech2text.speechprocessing.callcenter.datacentersink::DataCenterSink
SPL_MAIN_COMPOSITE_WATSON   = com.ibm.streamsx.speech2text.speechprocessing.callcenter.watsons2t::WatsonSpeech2Text
SPL_MAIN_COMPOSITE_WAV      = com.ibm.streamsx.speech2text.speechprocessing.callcenter.wavgen::WavGenerator
SPL_DATA_DIR ?= ./data
CALLCENTER_TYPES_TOOLKIT=../com.ibm.streamsx.speech2text.callcenter.types
SPL_CMD_ARGS ?= 1 3 -t $(STREAMS_STUDIO_SPL_PATH):$(STREAMS_SPLPATH):$(CALLCENTER_TYPES_TOOLKIT)
BIN_LOC=impl/java/bin
JSI = $(STREAMS_INSTALL)
SETUPHOST=setup
HOST1=watson1

all: setup outdata watson1 wavgenerator
$(BIN_LOC):
	 mkdir -p $(BIN_LOC)
setup: setup_
setup_:
	 export jobNumber=1; export jobCount=3; export jobHost=setup; ${SPLC} $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE) --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS)  --output-directory output/packethandler
outdata: outdata_
outdata_:
	 export jobNumber=1; export jobCount=3; export jobHost=setup; ${SPLC} $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_OUTDATA) --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/datacentersink
watson1: watson_1
watson_1:
	 export jobNumber=1; export jobCount=3; export jobHost=watson1; $(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WATSON)  --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/watsonspeech2text1

wavgenerator: wavgen
wavgen:
	$(STREAMS_INSTALL)/java/bin/javac -cp $(STREAMS_INSTALL)/lib/com.ibm.streams.operator.jar:impl/java/lib/* impl/java/src/com/ibm/streamsx/speech2text/speechprocessing/callcenter/wavgen/*.java -d impl/java/bin/ 
	export jobNumber=1; export jobCount=3; $(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WAV) -t ../../../com.ibm.streamsx.speech2text/ --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/wavgen

clean:
	  rm -rf $(BIN_LOC)/*
	  rm -rf output
