#!/bin/bash
set -e

make -C com.ibm.streamsx.speech2text.callcenter.types

make -C com.ibm.streamsx.speech2text.callcenter.speechprocessing

make -C com.ibm.streamsx.speech2text.callcenter.networktap

make -C transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel

make -C tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing

make -C tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/


tar czvf CallCenterSubmissionBundle.tgz com.ibm.streamsx.speech2text.callcenter.networktap/output/ \
	com.ibm.streamsx.speech2text.callcenter.networktap/README.md com.ibm.streamsx.speech2text.callcenter.networktap/submit_example.sh \
	com.ibm.streamsx.speech2text.callcenter.speechprocessing/output/ \
	com.ibm.streamsx.speech2text.callcenter.speechprocessing/README.md \
	mkDefaultDirectories.sh \
	com.ibm.streamsx.speech2text.callcenter.speechprocessing/submitJob.sh \
	com.ibm.streamsx.speech2text.callcenter.speechprocessing/etc/ \
	tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/output/ \
	tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/README.md \
	tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/etc \
	tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/submit_example.sh \
	transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel/output/ \
	transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel/README.md \
	transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel/etc \
	transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel/submitJob.sh \
	tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/output/ \
	tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/README.md \
	tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/etc \
	tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/submitJob.sh 
	
	
echo "Created tar file: CallCenterSubmissionBundle.tgz"
