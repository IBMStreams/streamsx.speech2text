# Modify the job name to the desired one 

declare -A jobnamemap
jobnamemap[transcriptbuilder]=TranscriptBuilder
jobnamemap[singlechannel]=SingleChannelAdapter

if [ "$#" -le 0 ] ; then
	echo "Must specify one of -j|--job [transcriptbuilder, singlechannel]"
	echo "Example commands: ./cancelJob.sh -j transcriptbuilder "
	exit
fi

if [[ $# -lt 2 ]]
then
	echo "Must specify one of -j|--job [transcriptbuilder, singlechannel]"
	echo "Example commands: ./cancelJob.sh -j transcriptbuilder "
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
	echo "Specify one of -j|--job [transcriptbuilder, singlechannel]"
	echo "Example commands: ./cancelJob.sh -j transcriptbuilder "
    exit
    ;;
    *)
	echo "Unknown option $key. Specify one of -j|--job [transcriptbuilder, singlechannel]"
	echo "Example commands: ./cancelJob.sh -j transcriptbuilder "
	exit
            # unknown option
    ;;
esac
shift # past argument or value
done


JOB_NAME=${jobnamemap[$JOB]}

streamtool canceljob --jobnames $JOB_NAME
