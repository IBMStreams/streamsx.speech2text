# Speech2Text Performance Tests

The application provided in this directory can be used to measure the approximate capacity of your enviornment 
for running Speech2Text. This application is made for processing RAW PCM .raw audio files, but can 
be modified quite easily to process .wav files. 

To measure the maximum throughput for a single file, we recommend that you start by running 
with a parallelWidth of 1. We also recommend that the audio you use is representative of the 
audio that you will need to be processing. For example, audio with a significant amount of silence
is processed much faster than audio without silence. Complexity of audio can also make a difference. 

If you have a real-time requirement for your application (for example, in a call-center), then we 
recommend looking at the real-time factor measurement for each file. You can find this in the 
<test-name>_Performance.txt file. We recommend that for parallel tests, the audio being processed 
is split into files that are small in relation to the length of time needed to complete the test. 
The reason being that at the end of a test, you could end up with a single engine finishing a large 
file for several minutes while the other engines in parallel run idle because the rest of files have been
processed already. 

Once the test is complete, the  <test-name>_Performance.txt will also have the total time it took to process
the audio provided. This can be used to approximate the time it will take for batch processing of audio. 

The easiest way to sequentially run many tests is to use the parallelPerf.sh script. 

## Minimum to run with defaults (must supply Watson model and config): 
	st submitjob output/com.ibm.streamsx.speech2text.perf.PerfTest.sab -P watsonModelFile=/homes/hny5/cooka/git/toolkit.speech2text/model/EnUS_Telephony_r2.2.3.pkg -P watsonConfigFile=/homes/hny5/cooka/git/toolkit.speech2text/model/EnUS_Telephony_r2.2.3-8kHz-diarization-error.pset

## Full Submission
	st submitjob output/com.ibm.streamsx.speech2text.perf.PerfTest.sab -P watsonModelFile=/homes/hny5/cooka/git/toolkit.speech2text/model/EnUS_Telephony_r2.2.3.pkg -P watsonConfigFile=/homes/hny5/cooka/git/toolkit.speech2text/model/EnUS_Telephony_r2.2.3-8kHz-diarization-error.pset -P audioDirectory=../../audio_even -P numFiles=31 -P numRepetitions=1 -P blockSize=200 -P writeUtterancesToFile=false -P testName=testParams

## Parameter Description

	<name> : <default-value> - <Description>
	watsonModelFile : <none> - Required: The location of the Watson .pkg file to run with this test. 
	watsonConfigFile : <none> - Required: The location of the Watson .pset config file to run this test. 
	testName : <default> - The name of the test. This will be used to write out performance results to <test-name>_Performance.txt and utterances to <test-name>_Utterances.txt. 
	writeUtterancesToFile : <true> - Boolean value of whether or not to write utterances to file. For extremely large parallel tests, we recommend you use false.  
	parallelWidth : <1> - Number of Speech2Text engines to have running in parallel. 
	blockSize : <200> - Number of bytes per tuple being sent to the WatsonS2T engine. For RTP packets, ~200 bytes. 
	executionsPerAudioFile : <1> - Number of times to submit the files from a directory for processing. This allows you to create large tests from a small number of audio files. 
	numAudioFiles : <5> - Number of .raw files to be processed from the provided directory. 
	audioDirectory : <audio> - Location of the audio to be processed. 

## Recommended Audio
For sample audio, you can use the RAW audio files included in the RAWWatsonS2T sample application in the Speech2Text toolkit as a starting point. However, to get accurate results you should use audio that is representative of the audio you need to process. For good benchmark timings, you should also try to have audio files of short length (~2% of total expected test time). This will make sure that the test doesn't finish with 1 / X engines completing the processing of one long audio file. 

You can convert audio to the correct RAW format using FFMPEG: 
```
$ ffmpeg -i <wav-file>.wav -ac 1 -f s16le -ar 8000 -acodec pcm_s16le <converted-file>.raw
```
You can also trim files to the size of your choice using FFMPEG: 
```
ffmpeg -t 120 -i <file-name>.wav <file-name>_short.wav
```

## Running with parallelPerf.sh Script
The parallelPerf.sh script is helpful for easily running multiple benchmark tests on a system. 

Script parameters: 
```
./parallelPerf.sh <test-name> <watsonModel> <watsonConfig> <writeUtterancesToFile (bool)> <blockSize> <numRepetitions> <numFiles> <audioDirectory> <parallelWidth (list)>
```

Sample command: 

Run tests of 1, 5, 10, and 15 Speech engines. Don't write utterances to file. Send 200 byte packets of audio. There are 31 files in the audio directory located at ../../audio_even and we are going to run through them 3 times each (per test). Each of the 4 tests will write to separate output files with the test name + the parallel width for identification. 
```
./parallelPerf.sh BasicRapid /opt/ibm/model/EnUS_Telephony_r2.3.1.pkg /opt/ibm/model/EnUS_Telephony_r2.3.1-8kHz-diarization.pset false 200 3 31  ../../audio_even '1 5 10 15'
```

## Results Analysis
There will be two output files for each test: 
	* <test-name>_Performance.txt - This will contain the processing time for each file, as well as the real-time factor for processing that file. 
	At the bottom, there will also be a "Test Completed" message that gives the total time to complete the test. 
	* <test-name>_utterances.txt - If the test is set to actually write utterances, you will find them here. 
	
**Real-time Factor** - Calculated as (Time of Audio) / (Processing Time) on a per-audio-stream basis. As you increase the 
number of Speech2Text engines (by increasing the parallelWidth parameter), your real-time factor will gradually go down 
(since it is on a per-stream basis, and you are putting more load on the server). The parallel width at which you can 
maintain a real-time factor slightly above 1.0 is the number of audio streams that you can comfortably process in 
parallel in production. 

### Results Cleaning

To clean the "\*Performance.txt" files for easy analysis in Excel, you can use the following awk commands: 

Getting throughput results for each file that was processed (good for real-time factor analysis): 
```
awk ' { print FILENAME " " $0 } ' * | tr -d "\"" | sed $'s/\/path\/to\/audio\/directory\///' | sed 's/s //g' | tr -d "%," | sed s'/\:/ /g' | grep -v "Test completed" > throughputResults.txt
```

Getting summary results for all the tests (see how long the entire tests took to complete): 
```
 awk ' { print FILENAME " " $0 } ' * | tr -d "\"" | grep "Test completed" > testSummary.txt
```