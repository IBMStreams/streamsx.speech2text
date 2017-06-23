package com.ibm.streamsx.speech2text.speechprocessing.callcenter.wavgen;

import java.util.List;
import java.io.File;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.nio.file.FileSystems;
import java.util.Map.Entry;
import java.util.Random;


public class FileStreamBuffer implements IStreamBuffer {

  int dirIdx_ = -1;
  long lastTupleTimestamp_;
  String writeToDir_ = null;
  String moveToDir_ = null;
  String fileName_ = null;
  PrintWriter writer_ = null;
  String bufferCreationTime_ = null;
  
  @Override
  public void assignOutputContainer(List<String> dirs) {
    if(dirIdx_ >= 0) return;
    Random rand = new Random();
    int dirIdx = rand.nextInt(dirs.size());
    dirIdx_= dirIdx;
    moveToDir_ = dirs.get(dirIdx);
  }  

  @Override
  public void initBufferWriter(List<String> dirs, String bufferId) throws Exception {
    if(writer_ != null) return;
    writeToDir_ = dirs.get(dirIdx_);
    String currentTime = (new Long(System.currentTimeMillis()/1000l)).toString();
    fileName_ = bufferId + "_" + currentTime;
    writer_ = new PrintWriter(new BufferedWriter(new FileWriter(writeToDir_ + "/" + fileName_)));
    setBufferCreationTime(currentTime);
  }

  @Override
  public void setBufferCreationTime(String time) {
    bufferCreationTime_ = time;
  }

  @Override
  public String getBufferCreationTime() {
    return bufferCreationTime_;
  }

  @Override
  public void updateLastTupleTimestamp() {
    lastTupleTimestamp_ = System.currentTimeMillis() / 1000l;
  }

  @Override
  public long getLastTupleTimestamp() {
    return lastTupleTimestamp_;
  }

  @Override
  public void append(String record) {
    writer_.write(record);
  }

  @Override
  public void close() {
    writer_.flush();
    writer_.close();
    Path writeToPath = FileSystems.getDefault().getPath(writeToDir_, fileName_);
    Path moveToPath = FileSystems.getDefault().getPath(moveToDir_, fileName_);
    try {
      Files.move(writeToPath, moveToPath, StandardCopyOption.REPLACE_EXISTING);
    } catch(IOException ex) {
	System.out.println(">>> in FileStreamBuffer.close ex : " + ex);
    }
  }
}
