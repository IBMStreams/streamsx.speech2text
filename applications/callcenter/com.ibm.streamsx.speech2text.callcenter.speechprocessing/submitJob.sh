#!/bin/bash  

STREAMS_DEFAULT_DOMAIN=$STREAMS_DOMAIN_ID
STREAMS_DEFAULT_IID=$STREAMS_INSTANCE_ID

PACKETHANDLER_SAB_FILE=output/packethandler/com.ibm.streamsx.speech2text.callcenter.speechprocessing.packethandler.PacketHandler.sab
WATSON_SAB_FILE=output/watsonspeech2text/com.ibm.streamsx.speech2text.callcenter.speechprocessing.watsons2t.WatsonSpeech2Text.sab
DATACENTERSINK_SAB_FILE=output/datacentersink/com.ibm.streamsx.speech2text.callcenter.speechprocessing.datacentersink.DataCenterSink.sab
WAV_SAB_FILE=output/wavgen/com.ibm.streamsx.speech2text.callcenter.speechprocessing.wavgen.WavGenerator.sab

declare -A sabmap
sabmap[packethandler]=$PACKETHANDLER_SAB_FILE
sabmap[watson]=$WATSON_SAB_FILE
sabmap[datacentersink]=$DATACENTERSINK_SAB_FILE
sabmap[wavgen]=$WAV_SAB_FILE

declare -A jobnamemap
jobnamemap[packethandler]=PacketHandler
jobnamemap[watson]=WatsonXXX
jobnamemap[datacentersink]=DataCenterSink
jobnamemap[wavgen]=WavGenerator

if [ "$#" -le 0 ] ; then
	echo "Must specify one of -j|--job [packethandler,watson,datacentersink,wavgen]"
	echo "Example commands: ./submitJob.sh -j packethandler --numWatsonHosts 3 --watsonEngineCountList [1,2,3]"
	echo " ./submitJob.sh -j watson --numWatsonHosts 3 --watsonEngineCountList [1,2,3]"
	echo "./submitJob.sh -j datacentersink "
	echo "./submitJob.sh -j wavgen "
	exit
fi

if [[ $# -lt 2 ]]
then
	echo "Specify one of -j|--job [packethandler,watson,datacentersink,wavgen,speechprocessing,all]"
    echo "Example commands:"
    echo " ./submitJob.sh -j speechprocessing --numWatsonHosts 3 --watsonEngineCountList [1,2,3] # submit packethandler,watson,and datacentersink"
    echo " ./submitJob.sh -j packethandler --numWatsonHosts 3 --watsonEngineCountList [1,2,3]"
	echo " ./submitJob.sh -j watson --numWatsonHosts 3 --watsonEngineCountList [1,2,3]"
	echo " ./submitJob.sh -j datacentersink "
	echo " ./submitJob.sh -j wavgen "
    exit
fi

while [[ $# -gt 1 ]]
do
key="$1"
case $key in
    -j|--job)
    JOB="$2"
    shift # past argument
    ;;
    -h|--help)
	echo "Specify one of -j|--job [packethandler,watson,datacentersink,wavgen,speechprocessing,all]"
    echo "Example commands:"
    echo " ./submitJob.sh -j speechprocessing --numWatsonHosts 3 --watsonEngineCountList [1,2,3] # submit packethandler,watson,and datacentersink"
    echo " ./submitJob.sh -j packethandler --numWatsonHosts 3 --watsonEngineCountList [1,2,3]"
	echo " ./submitJob.sh -j watson --numWatsonHosts 3 --watsonEngineCountList [1,2,3]"
	echo " ./submitJob.sh -j datacentersink "
	echo " ./submitJob.sh -j wavgen "
    exit
    ;;
    -n|--numWatsonHosts)
    numWatsonHosts="$2"
    shift # past argument
    ;;
    -w|--watsonEngineCountList)
    watsonEngineCountList="$2"
    echo "watsonEngineCountList: "$watsonEngineCountList
    shift # past argument
    ;;
    *)
	    echo "Unknown option $key. Must specify one of -j|--job [packethandler,watson,datacentersink,wavgen]"
	    echo "Example commands: ./submitJob.sh -j packethandler --numWatsonHosts 3 --watsonEngineCountList [1,2,3]"
		echo " ./submitJob.sh -j watson --numWatsonHosts 3 --watsonEngineCountList [1,2,3]"
		echo "./submitJob.sh -j datacentersink "
		echo "./submitJob.sh -j wavgen "
	    exit
            # unknown option
    ;;
esac
shift # past argument or value
done

if [[ ($JOB == "watson" || $JOB == "packethandler" || $JOB == "speechprocessing" || $JOB == "all") && $watsonEngineCountList == "" ]] \
	|| [[ $watsonEngineCountList != "" && ($JOB != "watson" && $JOB != "packethandler" && $JOB != "speechprocessing" && $JOB != "all") ]]
then
    echo "You must specify the -w|--watsonEngineCountList option with (and only with) the watson/packethandler jobs." 
    echo "Example command: ./submitJob.sh -j packethandler --numWatsonHosts 3 --watsonEngineCountList [1,2,3]"
    exit 
fi

if [[ ($JOB == "watson" || $JOB == "packethandler") && $numWatsonHosts == "" ]] || [[ $numWatsonJobs != "" && ($JOB != "watson" && $JOB != "packethandler") ]]
then
    echo "You must specify the -n|--numWatsonHosts option with (and only with) the watson/packethandler jobs." 
    exit 
fi

if [[ $JOB == "speechprocessing" || $JOB == "all" ]]
then
	array=( "datacentersink" "watson" "packethandler" ) 
else
	array=( $JOB )
fi

if [[ $STREAMS_CALLCENTER_DATA == "" ]]
then
	echo "Warning: \$STREAMS_CALLCENTER_DATA environment variable not set. Continue? (y/n)";
	read response;
	if [[ $response == "n" || $response == "no" ]]
	then
		exit
	fi
fi

for JOB in "${array[@]}"
do
	xbase=${sabmap[$JOB]##*/}
	basename=${xbase%.*}
	namespace=${basename%.*}
	
	echo $namespace
	if [ -n "${sabmap[$JOB] + 1}" ]; then
		echo "Deploying this job "$JOB" with this bundle "${sabmap[$JOB]};
	else
		echo "Didn't recognize name "$JOB;
		exit
	fi
	
	echo "Submitting .sab file: "${sabmap[$JOB]}
	echo "To Domain: "$STREAMS_DEFAULT_DOMAIN
	echo "To Instance: "$STREAMS_DEFAULT_IID
	echo "With job name: "${jobnamemap[$JOB]}  
	
	cat  etc/properties.cfg | grep -i $namespace > etc/tempallproperties.cfg
	params=""
	JOB_CONFIG_FILE="" # reset in case we don't find one for this job
	while read p; do
	        if [[ ${p:0:1} == "c" ]];
	        then
			if [[ $p == *"JobConfig"* ]]; then
				JOB_CONFIG_FILE=${p#*=}
			elif [[ $p == *"numWatsonHosts"* ]]; then
				p="${p/XXX/$numWatsonHosts}"
				params="$params -P $p"
			elif [[ $p == *"watsonEngineCountList"* ]]; then
				p="${p/YYY/$watsonEngineCountList}"
				params="$params -P $p"
			else
	            params="$params -P $p"
			fi
	#		echo "$params" 
	#	else
	#		echo "bad $p"
	        fi
	done < etc/tempallproperties.cfg
	
	# get an array out of the watsonEngineCountList
	engineList="${watsonEngineCountList//[}"
	engineList="${engineList//]}"
	IFS=', ' read -r -a jobCountArray <<< "$engineList"
	
	jobId=0
	while [[ ($jobId < 1)  || ("$JOB" == "watson" && $jobId < $numWatsonHosts ) ]]
	do
		echo ""
		echo "Submitting "$JOB":"
		echo ""
		
		jobConfig=""
		if [ ${JOB_CONFIG_FILE} ]; then 
			# copy it locally so we can modify
			jobConfigFile=${JOB_CONFIG_FILE}
			jobConfigFile="${jobConfigFile/XXX/$((jobId+1))}"
			hostTag=`cat ${jobConfigFile} | grep targetTagSet`
			hostTag=${hostTag#*:}
			echo "Expect host tag where this job will be placed is (to modify, change ${jobConfigFile}): "$hostTag
			jobConfig=" --jobConfig ${jobConfigFile} "
		fi
		
		jobNameArg="--jobname ${jobnamemap[$JOB]}"
		jobNameArg="${jobNameArg/XXX/$((jobId+1))}"
		
		paramsArg=${params}
		paramsArg="${paramsArg/XXX/$jobId}"
		paramsArg="${paramsArg/YYY/${jobCountArray[$jobId]}}"
		
		cmd="streamtool submitjob $jobNameArg -d $STREAMS_DEFAULT_DOMAIN -i $STREAMS_DEFAULT_IID $paramsArg $jobConfig ${sabmap[$JOB]}"
		
		echo $cmd;
		
		eval "$cmd"
		jobId=$((jobId+1))
	done
done

rm etc/tempallproperties.cfg
