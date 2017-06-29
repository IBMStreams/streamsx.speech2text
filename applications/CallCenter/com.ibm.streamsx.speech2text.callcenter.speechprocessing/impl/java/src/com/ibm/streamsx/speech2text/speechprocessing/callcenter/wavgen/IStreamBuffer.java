package com.ibm.streamsx.speech2text.callcenter.speechprocessing.wavgen;

import java.util.List;

public interface IStreamBuffer {
  public void assignOutputContainer(List<String> containerList);
  public void setBufferCreationTime(String time);
  public String getBufferCreationTime();
  public void initBufferWriter(List<String> containerList, String bufferId) throws Exception;
  public void updateLastTupleTimestamp();
  public long getLastTupleTimestamp();
  public void append(String record);
  public void close();
}
