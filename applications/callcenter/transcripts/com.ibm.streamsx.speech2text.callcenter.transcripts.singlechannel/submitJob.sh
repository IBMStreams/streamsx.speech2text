#!/bin/bash  
# This is a simple submitjob template
STREAMS_DEFAULT_DOMAIN=$STREAMS_DOMAIN_ID
STREAMS_DEFAULT_IID=$STREAMS_INSTANCE_ID

# Modify the SAB file to the one of interest
SAB_FILE=output/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel.SingleChannelTranscriptBuilder/BuildConfig/com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel.SingleChannelTranscriptBuilder.sab
# Modify the job name to the desired one 
JOB_NAME=SingleChannelTranscripts
# Job config file is used for dynamic tagging
JOB_CONFIG_FILE="etc/jobConfig.json" 


if [[ $STREAMS_CALLCENTER_DATA == "" ]]
then
	echo "Warning: \$STREAMS_CALLCENTER_DATA environment variable not set. Continue? (y/n)";
	read response;
	if [[ $response == "n" || $response == "no" ]]
	then
		exit
	fi
fi


xbase=${SAB_FILE##*/}
basename=${xbase%.*}
namespace=${basename%.*}

echo $namespace

echo "Submitting .sab file: "${SAB_FILE}
echo "To Domain: "$STREAMS_DEFAULT_DOMAIN
echo "To Instance: "$STREAMS_DEFAULT_IID
echo "With job name: "$JOB_NAME

cat  etc/properties.cfg | grep -i $namespace > etc/tempallproperties.cfg
params=""
while read p; do
        if [[ ${p:0:1} == "c" ]];
        then
		if [[ $p == *"JobConfig"* ]]; then
			# allows for setting Job Config file in properties.cfg
			JOB_CONFIG_FILE=${p#*=}
		else
            params="$params -P $p"
		fi
	fi
done < etc/tempallproperties.cfg


echo ""
echo "Submitting "$JOB":"
echo ""

jobConfig=""
if [ ${JOB_CONFIG_FILE} ]; then 
	# copy it locally so we can modify
	jobConfigFile=${JOB_CONFIG_FILE}
	hostTag=`cat ${jobConfigFile} | grep targetTagSet`
	hostTag=${hostTag#*:}
	echo "Expected host tag where this job will be placed is (to modify, change ${jobConfigFile}): $hostTag"
	jobConfig=" --jobConfig ${jobConfigFile} "
fi

paramsArg=${params}

cmd="streamtool submitjob --jobname $JOB_NAME -d $STREAMS_DEFAULT_DOMAIN -i $STREAMS_DEFAULT_IID $paramsArg $jobConfig $SAB_FILE"

echo $cmd;

eval "$cmd"

rm etc/tempallproperties.cfg
