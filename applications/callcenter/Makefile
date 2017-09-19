.PHONY: all clean

all: types speechprocessing networktap transcripts callstate test_speechprocessing test_transcripts submittable_package

types:
	make -C com.ibm.streamsx.speech2text.callcenter.types

networktap:
	make -C com.ibm.streamsx.speech2text.callcenter.networktap

speechprocessing:
	make -C com.ibm.streamsx.speech2text.callcenter.speechprocessing

transcripts:
	make -C com.ibm.streamsx.speech2text.callcenter.transcripts

callstate: 
	make -C com.ibm.streamsx.speech2text.callcenter.callstate

tests: test_speechprocessing test_transcripts

test_speechprocessing:
	make -C tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing

test_transcripts:
	make -C tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/

submittable_package:
	tar czvf CallCenterSubmissionPackage.tgz mkDefaultDirectories.sh \
		com.ibm.streamsx.speech2text.callcenter.networktap/output/ \
		com.ibm.streamsx.speech2text.callcenter.networktap/README.md com.ibm.streamsx.speech2text.callcenter.networktap/submit_example.sh \
		com.ibm.streamsx.speech2text.callcenter.speechprocessing/output/ \
		com.ibm.streamsx.speech2text.callcenter.speechprocessing/README.md \
		com.ibm.streamsx.speech2text.callcenter.speechprocessing/submitJob.sh \
		com.ibm.streamsx.speech2text.callcenter.speechprocessing/etc/ \
		tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/output/ \
		tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/README.md \
		tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/etc \
		tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/submitJob.sh \
		tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing/cancelJob.sh \
		com.ibm.streamsx.speech2text.callcenter.transcripts/output/ \
		com.ibm.streamsx.speech2text.callcenter.transcripts/README.md \
		com.ibm.streamsx.speech2text.callcenter.transcripts/etc \
		com.ibm.streamsx.speech2text.callcenter.transcripts/submitJob.sh \
		com.ibm.streamsx.speech2text.callcenter.transcripts/cancelJob.sh \
		com.ibm.streamsx.speech2text.callcenter.callstate/output/ \
		com.ibm.streamsx.speech2text.callcenter.callstate/README.md \
		com.ibm.streamsx.speech2text.callcenter.callstate/etc \
		com.ibm.streamsx.speech2text.callcenter.callstate/submitJob.sh \
		com.ibm.streamsx.speech2text.callcenter.callstate/cancelJob.sh \
		tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/output/ \
		tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/README.md \
		tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/etc \
		tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/submitJob.sh \
		tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/cancelJob.sh 

clean:
	make clean -C com.ibm.streamsx.speech2text.callcenter.types
	make clean -C com.ibm.streamsx.speech2text.callcenter.speechprocessing
	make clean -C com.ibm.streamsx.speech2text.callcenter.networktap
	make clean -C com.ibm.streamsx.speech2text.callcenter.transcripts
	make clean -C tests/com.ibm.streamsx.speech2text.callcenter.test.speechprocessing
	make clean -C tests/transcripts/com.ibm.streamsx.speech2text.callcenter.test.transcripts.singlechannel/
	rm -f CallCenterSubmissionPackage.tgz