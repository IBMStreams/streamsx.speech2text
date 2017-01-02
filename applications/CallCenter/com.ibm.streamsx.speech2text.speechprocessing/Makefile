## begin_generated_IBM_copyright_prolog
.PHONY: all clean
SPLC = $(STREAMS_INSTALL)/bin/sc
SPLC_FLAGS = -a 

SPL_MAIN_COMPOSITE          = com.ibm.streamsx.speech2text.speechprocessing.setup::Main
SPL_MAIN_COMPOSITE_OUTDATA  = com.ibm.streamsx.speech2text.speechprocessing.outdata::Main
SPL_MAIN_COMPOSITE_WATSON   = com.ibm.streamsx.speech2text.speechprocessing::Watson
SPL_DATA_DIR ?= ./data
SPL_CMD_ARGS ?= 5 3 3 3 3 3
BIN_LOC=impl/java/bin
JSI = $(STREAMS_INSTALL)
SETUPHOST=setup
HOST1=watson1
HOST2=watson2
HOST3=watson3
HOST4=watson4
HOST5=watson5
all: setup outdata watson1 watson2 watson3 watson4 watson5
$(BIN_LOC):
	 mkdir -p $(BIN_LOC)
setup: setup_
setup_:
	 export jobNumber=1; export jobCount=50; export jobHost=setup; ${SPLC} $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE) --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/setup
outdata: outdata_
outdata_:
	 export jobNumber=1; export jobCount=50; export jobHost=setup; ${SPLC} $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_OUTDATA) --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/outdata
watson1: watson_1
watson_1:
	 export jobNumber=1; export jobCount=3; export jobHost=watson1; $(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WATSON)  --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/watson_1
watson2: watson_2
watson_2:
	 export jobNumber=2; export jobCount=3; export jobHost=watson2; $(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WATSON)  --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/watson_2
watson3: watson_3
watson_3:
	 export jobNumber=3; export jobCount=3; export jobHost=watson3; $(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WATSON)  --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/watson_3
watson4: watson_4
watson_4:
	 export jobNumber=4; export jobCount=3; export jobHost=watson4; $(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WATSON)  --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/watson_4
watson5: watson_5
watson_5:
	 export jobNumber=5; export jobCount=3; export jobHost=watson5; $(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE_WATSON)  --data-directory $(SPL_DATA_DIR) $(SPL_CMD_ARGS) --output-directory output/watson_5
clean:
	  rm -rf $(BIN_LOC)
	  rm -rf output
