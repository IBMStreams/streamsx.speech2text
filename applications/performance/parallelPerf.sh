#!/bin/bash

echo "./script.sh <test-name> <watsonModel> <watsonConfig> <writeUtterancesToFile (bool)> <blockSize> <executionsPerAudioFile> <numAudioFiles> <audioDirectory> <parallelWidth (list)>"

name=$1;
watsonModelFile=$2;
watsonConfigFile=$3;
writeUtterancesToFile=$4;
blockSize=$5;
executionsPerAudioFile=$6
numAudioFiles=$7
audioDirectory=$8
parallelWidth=$9; # should be list argument '1 3 7 10'

echo "Width $parallelWidth";

for width in $parallelWidth;
do
	testName="${name}_parallel${width}_block${blockSize}_${numAudioFiles}files_${executionsPerAudioFile}executionsPerAudioFile_WriteUtterances${writeUtterancesToFile}";
	cmd="streamtool submitjob output/com.ibm.streamsx.speech2text.perf.PerfTest.sab -P watsonModelFile=$watsonModelFile -P watsonConfigFile=$watsonConfigFile -P audioDirectory=$audioDirectory -P numAudioFiles=$numAudioFiles -P executionsPerAudioFile=$executionsPerAudioFile -P blockSize=$blockSize -P writeUtterancesToFile=$writeUtterancesToFile -P testName=$testName -P parallelWidth=$width --jobname $testName";
	echo $cmd;
	`$cmd`;
	while ! grep -i "completed" data/${testName}_Performance.txt; do  echo "Waiting for $testName to complete...";  sleep 30; done
	cancelCmd="streamtool canceljob --jobnames $testName"
	echo $cancelCmd;
	`$cancelCmd`;
	grep -i "completed" data/${testName}_Performance.txt #| mail -s "$testName Completed" cooka@us.ibm.com;
done
