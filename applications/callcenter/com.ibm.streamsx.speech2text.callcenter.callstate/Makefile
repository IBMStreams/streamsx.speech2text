.PHONY: all distributed clean 

SPLC_FLAGS ?= --output-directory output/com.ibm.streamsx.speech2text.callcenter.callstate.CallStateService/BuildConfig --data-directory data -a
SPLC = $(STREAMS_INSTALL)/bin/sc
SPL_CMD_ARGS ?= 
SPL_MAIN_COMPOSITE = com.ibm.streamsx.speech2text.callcenter.callstate::CallStateService
SPL_CALLCENTER_TYPES = ../com.ibm.streamsx.speech2text.callcenter.types
PRODUCT_TOOLKITS = ${STREAMS_INSTALL}/toolkits/
DPS_TOOLKIT = ../../../.dps-toolkit/streamsx.dps-3.2.1/com.ibm.streamsx.dps/

SPL_TOOLKIT_ARGS = -t $(SPL_CALLCENTER_TYPES):$(PRODUCT_TOOLKITS):$(DPS_TOOLKIT)

all: buildConfig

buildConfig:
	spl-make-toolkit -i $(SPL_CALLCENTER_TYPES)
	$(SPLC) $(SPLC_FLAGS) -M $(SPL_MAIN_COMPOSITE) $(SPL_CMD_ARGS) $(SPL_TOOLKIT_ARGS)

docs:
	spl-make-doc

clean: 
	$(SPLC) $(SPLC_FLAGS) -C -M $(SPL_MAIN_COMPOSITE)

