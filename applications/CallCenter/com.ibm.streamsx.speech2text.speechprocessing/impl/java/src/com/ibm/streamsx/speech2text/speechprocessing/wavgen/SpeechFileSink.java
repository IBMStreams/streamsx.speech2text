package com.ibm.streamsx.speech2text.speechprocessing.wavgen;

import java.util.List;
import java.util.ListIterator;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;
import java.util.HashMap;
import java.util.Map.Entry;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

import org.apache.log4j.Logger;

import com.ibm.streams.operator.AbstractOperator;
import com.ibm.streams.operator.OperatorContext;
import com.ibm.streams.operator.OutputTuple;
import com.ibm.streams.operator.StreamingOutput;
import com.ibm.streams.operator.StreamingData.Punctuation;
import com.ibm.streams.operator.StreamingInput;
import com.ibm.streams.operator.Tuple;
import com.ibm.streams.operator.StreamSchema;
import com.ibm.streams.operator.Attribute;
import com.ibm.streams.operator.model.InputPortSet;
import com.ibm.streams.operator.model.InputPortSet.WindowMode;
import com.ibm.streams.operator.model.InputPortSet.WindowPunctuationInputMode;
import com.ibm.streams.operator.model.InputPorts;
import com.ibm.streams.operator.model.OutputPortSet;
import com.ibm.streams.operator.model.OutputPortSet.WindowPunctuationOutputMode;
import com.ibm.streams.operator.model.OutputPorts;
import com.ibm.streams.operator.model.Parameter;
import com.ibm.streams.operator.model.PrimitiveOperator;
import com.ibm.streams.operator.model.Libraries;
import com.ibm.streams.operator.log4j.LogLevel;
import com.ibm.streams.operator.log4j.LoggerNames;
import com.ibm.streams.operator.log4j.TraceLevel;
import com.ibm.streams.operator.types.Blob;

@PrimitiveOperator
@Libraries({
	"impl/java/lib/*"
})
@InputPorts(
	{
		@InputPortSet(
			description = "Speech data port",
			cardinality = 1,
			optional = false,
			windowingMode = WindowMode.NonWindowed,
			windowPunctuationInputMode = WindowPunctuationInputMode.Oblivious
	 	)
	}
)

public class SpeechFileSink extends AbstractOperator {
	private static final Logger log = Logger.getLogger(LoggerNames.LOG_FACILITY + "." + SpeechFileSink.class.getName());
	private static final Logger trace = Logger.getLogger(SpeechFileSink.class);
	
	private static final String QUOTE = "\"";
	private static final String DEL = ",";
	private static final String NEWLINE = "\n";
	
	private String writeToDirectory_	= null;
	private String moveToDirectory_	= null;
	
	private List<String> writeToDirList_ = null;
	private List<String> moveToDirList_ = null;
  private int callTimeout_ = 3;
  	
	private Map<String,IStreamBuffer> streamBufferMap_ = null;
	
	private Double scheduledActionPeriod_	= null;
	private ScheduledFuture<?> future_;
  private long pollFrequency_ = 1;
  private TimeUnit pollFrequencyUnit_ = TimeUnit.SECONDS;

  public final synchronized long getPollFrequency() {
      return pollFrequency_;
  }

  public final synchronized TimeUnit getPollFrequencyUnit() {
      return pollFrequencyUnit_;
  }

  public final synchronized void setPollFrequency(long pollFrequency,
          TimeUnit unit) {
      pollFrequency_ = pollFrequency;
      pollFrequencyUnit_ = unit;
  }
	

	@Parameter(optional = false, description = "Directory where call files will be written to")
	public void setWriteToDirectory(String writeToDirectory) {
		writeToDirectory_ = writeToDirectory;
	}

	@Parameter(optional = false, description = "Directory where call files will be moved to once call is completed (and call file is closed)")
	public void setMoveToDirectory(String moveToDirectory) {
		moveToDirectory_ = moveToDirectory;
	}

	@Parameter(optional = true, description = "Seconds to wait before closing a call file")
	public void setCallTimeout(int callTimeout) {
	  callTimeout_ = callTimeout;
	}

	@Parameter(optional = true, description = "Scheduled action period")
	public void setScheduledActionPeriod(Double period) {
		scheduledActionPeriod_ = period;
		setPollFrequency((long) (period * 1000.0), TimeUnit.MILLISECONDS);
	}

  private class ScheduledActionRunner implements Runnable {
    @Override
    public void run() {
      try {
      	runScheduledAction();
      } catch (Exception e) {
          throw new RuntimeException(e);
      }
    }
  
	  public void runScheduledAction() {
	    synchronized(streamBufferMap_) {
		    java.util.Iterator<Entry<String,IStreamBuffer>> it = streamBufferMap_.entrySet().iterator();
		    while(it.hasNext()) {
			    Map.Entry<String, IStreamBuffer> streamBufferEntry = (Map.Entry<String, IStreamBuffer>)it.next();
			    String key = streamBufferEntry.getKey();
			    IStreamBuffer streamBuffer = streamBufferEntry.getValue();
			    long currentTime = System.currentTimeMillis() / 1000l;
			    if(currentTime - streamBuffer.getLastTupleTimestamp() > callTimeout_) {
			      // Close file and move it to moveToDirectory
			      streamBuffer.close();
        		      it.remove();
			    }
//		System.out.println(">>> in SpeechFileSink.runScheduledAction streamBufferMap_.size(): " + streamBufferMap_.size());
        }
      }
    }
  }
  
	@Override
	public synchronized void initialize(OperatorContext context) throws Exception {
		super.initialize(context);
		trace.log(TraceLevel.INFO, "Operator " + context.getName() + " initializing in PE: " + 
		  context.getPE().getPEId() + " in Job: " + context.getPE().getJobId());
		  
	  // Get the lists of write to directories and move to directories
	  writeToDirList_ = new ArrayList<String>(Arrays.asList(writeToDirectory_.split(",")));
	  moveToDirList_ = new ArrayList<String>(Arrays.asList(moveToDirectory_.split(",")));
	  
	  if(writeToDirList_.size() != moveToDirList_.size()) {
	    throw new Exception("Number of 'write to' directories must be equal to the number of 'move to' directories.");
	  }
	  
	  // Remove white spaces
	  for(final ListIterator<String> it = writeToDirList_.listIterator(); it.hasNext();) {
	    final String dir = it.next();
	    it.set(dir.replaceAll("\\s",""));
	  }
	  for(final ListIterator<String> it = moveToDirList_.listIterator(); it.hasNext();) {
	    final String dir = it.next();
	    it.set(dir.replaceAll("\\s",""));
	  }
	  
		streamBufferMap_ = new HashMap<String,IStreamBuffer>();
	}

	@Override
	public synchronized void allPortsReady() throws Exception {
	  OperatorContext context = getOperatorContext();
	  trace.log(TraceLevel.INFO, "Operator " + context.getName() + "calling allPortsReady()  in PE: " + 
		  context.getPE().getPEId() + " in Job: " + context.getPE().getJobId());

    final Runnable scheduledActionRunner = new ScheduledActionRunner();
    future_ = getOperatorContext().getScheduledExecutorService()
            	.scheduleAtFixedRate(scheduledActionRunner,
                0l, getPollFrequency(), getPollFrequencyUnit());
	}
	
	@Override
	public synchronized void shutdown() throws Exception {
		super.shutdown();
		OperatorContext context = getOperatorContext();
		trace.log(TraceLevel.INFO, "Operator " + context.getName() + "calling shutdown()  in PE: " + 
		  context.getPE().getPEId() + " in Job: " + context.getPE().getJobId());
	}	

	@Override
	public void process(StreamingInput<Tuple> port, Tuple tuple) throws Exception {
		OperatorContext context = getOperatorContext();
		trace.log(TraceLevel.INFO, "Operator " + context.getName() + "calling process()  in PE: " + 
		  context.getPE().getPEId() + " in Job: " + context.getPE().getJobId());
//		trace.log(TraceLevel.ERROR, "tuple " + tuple);
		
		String id = tuple.getString("id");
		String channel_id = tuple.getString("channel_id");
		int ssrc = tuple.getInt("ssrc");
		int ts = tuple.getInt("ts");
		int captureSeconds = tuple.getInt("captureSeconds");
		short seq = tuple.getShort("seq");
		int samples = tuple.getInt("samples");
		Blob speech = tuple.getBlob("speech");
		
		String key = id + "_" + channel_id;
		
		IStreamBuffer streamBuffer = null;
		String fileCreationTime = null;
		synchronized(streamBufferMap_) {
		  if(!streamBufferMap_.containsKey(key)) {
		    IStreamBufferFactory streamBufferFactory = new StreamBufferFactory();
		    streamBuffer = streamBufferFactory.getStreamBuffer("FileStreamBuffer");
		    streamBufferMap_.put(key, streamBuffer);
     		streamBuffer.assignOutputContainer(moveToDirList_);
     		streamBuffer.initBufferWriter(writeToDirList_, key);
		  }
  		streamBuffer = streamBufferMap_.get(key);
  		streamBuffer.updateLastTupleTimestamp();
		fileCreationTime = streamBuffer.getBufferCreationTime();
		}
    StringBuilder sb = new StringBuilder();
    sb = sb.append(key)
	   .append(DEL).append(fileCreationTime)
           .append(DEL).append(speech.toString())
           .append(NEWLINE);
    String line = sb.toString();
    streamBuffer.append(line);
  }
}
