# Copyright (C)2016, International Business Machines Corporation and  
# others. All Rights Reserved.                        
.PHONY: all clean

STREAMS_SPEECH2TEXT_TOOLKIT ?= $(STREAMS_SPLPATH)

SPLC_FLAGS ?= -a -t ${STREAMS_SPEECH2TEXT_TOOLKIT}

SPLC = $(STREAMS_INSTALL)/bin/sc

SPL_CMD_ARGS ?=
SPL_MAIN_COMPOSITE = com.ibm.streamsx.speech2text.perf::PerfTest
OUTPUT_DIR = output
DATA_DIR = data

all: buildConfig

buildConfig:
	$(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE) --data-dir ./$(DATA_DIR) --output-dir ./$(OUTPUT_DIR) $(SPL_CMD_ARGS)

clean:
	$(SPLC) $(SPLC_FLAGS) -C -M $(SPL_MAIN_COMPOSITE)
