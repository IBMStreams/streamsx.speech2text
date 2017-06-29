package com.ibm.streamsx.speech2text.callcenter.speechprocessing.wavgen;

public class StreamBufferFactory implements IStreamBufferFactory{
  @Override
  public IStreamBuffer getStreamBuffer(String streamBufferType) throws Exception {
    switch(streamBufferType) {
      case "FileStreamBuffer":
        return new FileStreamBuffer();
      default:
        throw new Exception("StreamBuffer type " + streamBufferType + " cannot be instantiated.");
    }
  }
}
