package com.ibm.streamsx.speech2text.speechprocessing.callcenter.wavgen;

public interface IStreamBufferFactory {
  public IStreamBuffer getStreamBuffer(String streamBufferType) throws Exception;
}
