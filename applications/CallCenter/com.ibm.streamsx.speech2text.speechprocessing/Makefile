## begin_generated_IBM_copyright_prolog
.PHONY: all clean
SPLC = $(STREAMS_INSTALL)/bin/sc
SPLC_FLAGS = -a 

SPL_MAIN_COMPOSITE          = com.ibm.streamsx.speech2text.speechprocessing.setup::Main
SPL_MAIN_COMPOSITE_OUTDATA  = com.ibm.streamsx.speech2text.speechprocessing.outdata::Main
SPL_MAIN_COMPOSITE_WATSON   = com.ibm.streamsx.speech2text.speechprocessing::Watson
SPL_MAIN_COMPOSITE_WAV      = com.ibm.streamsx.speech2text.speechprocessing.wavgen::WavGenerator
SPL_DATA_DIR ?= ./data
SPL_CMD_ARGS ?= 1 3
BIN_LOC=impl/java/bin
JSI = $(STREAMS_INSTALL)
SETUPHOST=setup
HOST1=watson1

all: setup outdata watson1 wavgenerator
$(BIN_LOC):
	 mkdir -p $(BIN_LOC)
setup: setup_
setup_:
	 export jobNumber=1; export jobCount=3; export jobHost=setup; ${SPLC} $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE) --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/setup
outdata: outdata_
outdata_:
	 export jobNumber=1; export jobCount=3; export jobHost=setup; ${SPLC} $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_OUTDATA) --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/outdata
watson1: watson_1
watson_1:
	 export jobNumber=1; export jobCount=3; export jobHost=watson1; $(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WATSON)  --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/watson_1

wavgen:
	$(STREAMS_INSTALL)/java/bin/javac -cp $(STREAMS_INSTALL)/lib/com.ibm.streams.operator.jar:impl/java/lib/* impl/java/src/com/ibm/streamsx/speech2text/speechprocessing/wavgen/*.java -d impl/java/bin/ 
	export jobNumber=1; export jobCount=3; $(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WAV) -t ../../../com.ibm.streamsx.speech2text/ --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/wavgen

clean:
	  rm -rf $(BIN_LOC)/*
	  rm -rf output
