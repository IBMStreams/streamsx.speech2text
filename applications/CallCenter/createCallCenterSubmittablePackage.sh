#!/bin/bash
set -e

make -C com.ibm.streamsx.speech2text.callcenter.types

make -C com.ibm.streamsx.speech2text.callcenter.speechprocessing

make -C com.ibm.streamsx.speech2text.callcenter.networktap

make -C com.ibm.streamsx.speech2text.callcenter.transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel

make -C com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing

make -C com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/


tar czvf CallCenterSubmissionBundle.tgz com.ibm.streamsx.speech2text.callcenter.networktap/output/ \
	com.ibm.streamsx.speech2text.callcenter.networktap/README.md com.ibm.streamsx.speech2text.callcenter.networktap/submit_example.sh \
	com.ibm.streamsx.speech2text.callcenter.speechprocessing/output/ \
	com.ibm.streamsx.speech2text.callcenter.speechprocessing/README.md \
	mkDefaultDirectories.sh \
	com.ibm.streamsx.speech2text.callcenter.speechprocessing/submitJob.sh \
	com.ibm.streamsx.speech2text.callcenter.speechprocessing/etc/ \
	com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/output/ \
	com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/README.md \
	com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/etc \
	com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/submit_example.sh \
	com.ibm.streamsx.speech2text.callcenter.transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel/output/ \
	com.ibm.streamsx.speech2text.callcenter.transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel/README.md \
	com.ibm.streamsx.speech2text.callcenter.transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel/etc \
	com.ibm.streamsx.speech2text.callcenter.transcripts/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel/submitJob.sh \
	com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/output/ \
	com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/README.md \
	com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/etc \
	com.ibm.streamsx.speech2text.callcenter.test/com.ibm.streamsx.speech2text.callcenter.test.transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/submitJob.sh 
	
	
echo "Created tar file: CallCenterSubmissionBundle.tgz"
