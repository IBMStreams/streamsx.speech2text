package com.ibm.streamsx.speech2text.speechprocessing.wavgen;

public interface IStreamBufferFactory {
  public IStreamBuffer getStreamBuffer(String streamBufferType) throws Exception;
}
