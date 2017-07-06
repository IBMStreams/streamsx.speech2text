#!/bin/bash  

STREAMS_DEFAULT_DOMAIN=$STREAMS_DOMAIN_ID
STREAMS_DEFAULT_IID=$STREAMS_INSTANCE_ID

SETUP_SAB_FILE=output/setup/com.ibm.streamsx.speech2text.speechprocessing.setup.Main.sab
WATSON1_SAB_FILE=output/watson_1/com.ibm.streamsx.speech2text.speechprocessing.Watson.sab
TEST_SAB_FILE=output/test/com.ibm.streamsx.speech2text.speechprocessing.test.Main.sab
WAV_SAB_FILE=output/wavgen/com.ibm.streamsx.speech2text.speechprocessing.wavgen.WavGenerator.sab

declare -A sabmap
sabmap[setup]=$SETUP_SAB_FILE
sabmap[watson1]=$WATSON1_SAB_FILE
sabmap[test]=$TEST_SAB_FILE
sabmap[wavgen]=$WAV_SAB_FILE


if [ "$#" -le 0 ] ; then
	echo "must specify -h or -s [setup,watson1,test,wavgen]"]
	exit
fi

while getopts ":hs:" optname
  do
    case "$optname" in
      "h")
        echo "Specify one of -s [setup,watson1,test,wavgen]"
        exit
	;;
      "s")
	JOB=$OPTARG
        ;;
      "?")
        echo "Unknown option $OPTARG"
	exit
        ;;
      ":")
        echo "No argument value for option $OPTARG"
	exit
        ;;
      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
#    echo "OPTIND is now $OPTIND"
  done
echo ${sabmap[$JOB]}

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

echo ${sabmap[$JOB]}
echo $STREAMS_DEFAULT_DOMAIN
echo $STREAMS_DEFAULT_IID
echo $JOB  

cat  etc/properties.cfg | grep -i $namespace > etc/tempallproperties.cfg
params=""
while read p; do
        if [[ ${p:0:1} == "c" ]];
        then
                params="$params -P $p"
#		echo "$params" 
#	else
#		echo "bad $p"
        fi
done < etc/tempallproperties.cfg
 
if [ "$JOB" = "wavgen2wav" ]; then
	dirs=`grep "com.ibm.streamsx.speech2text.speechprocessing.wavgen::WavGenerator.moveToDirectory" etc/tempallproperties.cfg | awk -F = '{print $2}' |tr "," "\n"`
	i=1;
	for m in $dirs; do 
		p2=" -P com.ibm.streamsx.speech2text.speechprocessing.wavgen::WavGenerator.payloadDirPath=$m $params"
		echo $p2
		streamtool submitjob -d $STREAMS_DEFAULT_DOMAIN -i $STREAMS_DEFAULT_IID --jobname $JOB$i ${sabmap[$JOB]} $p2
		let i=i+1
	done
else
	echo $params
	streamtool submitjob -d $STREAMS_DEFAULT_DOMAIN -i $STREAMS_DEFAULT_IID --jobname $JOB ${sabmap[$JOB]} $params
fi

rm etc/tempallproperties.cfg
