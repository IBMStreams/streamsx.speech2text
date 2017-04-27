# This is a sample script to submit the jobs built using the sample Makefile
# The main purpose is to highlight the submitjob commands that you will then 
# modify to fit the environment that you are in. 

streamtool submitjob --jobname watson1  --embeddedzk -P com.ibm.streamsx.speech2text.speechprocessing::Watson.diagnostics=/home/streamsadmin/data/ -P com.ibm.streamsx.speech2text.speechprocessing::Watson.paramsetFile=/home/streamsadmin/toolkits/model/EnUS_Telephony_r2.2.3-8kHz-diarization.pset -P com.ibm.streamsx.speech2text.speechprocessing::Watson.packageFile=/home/streamsadmin/toolkits/model/EnUS_Telephony_r2.2.3.pkg -P com.ibm.streamsx.speech2text.speechprocessing::Watson.utterances=/home/streamsadmin/data/ -P com.ibm.streamsx.speech2text.speechprocessing::Watson.callCenter=67 output/watson_1/com.ibm.streamsx.speech2text.speechprocessing.Watson.sab

streamtool submitjob --jobname watson2  --embeddedzk -P com.ibm.streamsx.speech2text.speechprocessing::Watson.diagnostics=/home/streamsadmin/data/ -P com.ibm.streamsx.speech2text.speechprocessing::Watson.paramsetFile=/home/streamsadmin/toolkits/model/EnUS_Telephony_r2.2.3-8kHz-diarization.pset -P com.ibm.streamsx.speech2text.speechprocessing::Watson.packageFile=/home/streamsadmin/toolkits/model/EnUS_Telephony_r2.2.3.pkg -P com.ibm.streamsx.speech2text.speechprocessing::Watson.utterances=/home/streamsadmin/data/ -P com.ibm.streamsx.speech2text.speechprocessing::Watson.callCenter=67 output/watson_2/com.ibm.streamsx.speech2text.speechprocessing.Watson.sab

streamtool submitjob --jobname watson3  --embeddedzk -P com.ibm.streamsx.speech2text.speechprocessing::Watson.diagnostics=/home/streamsadmin/data/ -P com.ibm.streamsx.speech2text.speechprocessing::Watson.paramsetFile=/home/streamsadmin/toolkits/model/EnUS_Telephony_r2.2.3-8kHz-diarization.pset -P com.ibm.streamsx.speech2text.speechprocessing::Watson.packageFile=/home/streamsadmin/toolkits/model/EnUS_Telephony_r2.2.3.pkg -P com.ibm.streamsx.speech2text.speechprocessing::Watson.utterances=/home/streamsadmin/data/ -P com.ibm.streamsx.speech2text.speechprocessing::Watson.callCenter=67 output/watson_3/com.ibm.streamsx.speech2text.speechprocessing.Watson.sab

streamtool submitjob --jobname watson4  --embeddedzk -P com.ibm.streamsx.speech2text.speechprocessing::Watson.diagnostics=/home/streamsadmin/data/ -P com.ibm.streamsx.speech2text.speechprocessing::Watson.paramsetFile=/home/streamsadmin/toolkits/model/EnUS_Telephony_r2.2.3-8kHz-diarization.pset -P com.ibm.streamsx.speech2text.speechprocessing::Watson.packageFile=/home/streamsadmin/toolkits/model/EnUS_Telephony_r2.2.3.pkg -P com.ibm.streamsx.speech2text.speechprocessing::Watson.utterances=/home/streamsadmin/data/ -P com.ibm.streamsx.speech2text.speechprocessing::Watson.callCenter=67 output/watson_4/com.ibm.streamsx.speech2text.speechprocessing.Watson.sab

streamtool submitjob --jobname watson5  --embeddedzk -P com.ibm.streamsx.speech2text.speechprocessing::Watson.diagnostics=/home/streamsadmin/data/ -P com.ibm.streamsx.speech2text.speechprocessing::Watson.paramsetFile=/home/streamsadmin/toolkits/model/EnUS_Telephony_r2.2.3-8kHz-diarization.pset -P com.ibm.streamsx.speech2text.speechprocessing::Watson.packageFile=/home/streamsadmin/toolkits/model/EnUS_Telephony_r2.2.3.pkg -P com.ibm.streamsx.speech2text.speechprocessing::Watson.utterances=/home/streamsadmin/data/ -P com.ibm.streamsx.speech2text.speechprocessing::Watson.callCenter=67 output/watson_5/com.ibm.streamsx.speech2text.speechprocessing.Watson.sab

streamtool submitjob --jobname outdata  --embeddedzk -P com.ibm.streamsx.speech2text.speechprocessing.outdata::Main.connPort=21436 output/outdata/com.ibm.streamsx.speech2text.speechprocessing.outdata.Main.sab

# Submitting setup last to give the other apps an opportunity to start before data is transmitted. 
streamtool submitjob --jobname setup  --embeddedzk  -P com.ibm.streamsx.speech2text.speechprocessing.setup::Main.connHost=10.177.128.75 -P com.ibm.streamsx.speech2text.speechprocessing.setup::Main.connPort=33333 -P com.ibm.streamsx.speech2text.speechprocessing.setup::Main.controlDiagnostics=/home/streamsadmin/data/  output/setup/com.ibm.streamsx.speech2text.speechprocessing.setup.Main.sab 
