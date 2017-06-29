package com.ibm.streamsx.speech2text.callcenter.speechprocessing.wavgen;

public interface IStreamBufferFactory {
  public IStreamBuffer getStreamBuffer(String streamBufferType) throws Exception;
}
