# Transcripts 

These assets are helpful for building transcripts of the calls. See the properties.cfg file for documentation of app parameters. 

Generate spl-doc using: 
make docs

## Transcript Builder

This application is generalized to produce text transcripts from both single-channel and multi-channel calls. 

Input expectation: The commonCallUtterance type assumes that to "release" a call, we will receive a tuple of type 
commonCallUtterance where callComplete == true. Different implementations of Multi-Channel interfaces may require 
different multi-channel "transcript adapters". It is recommended to leverage results from the CallState application. 
An adapter for the single-channel case is included in the com.ibm.streamsx.speech2text.callcenter.transcripts.singlechannel
namespace. 

## Single Channel Transcript Adapter

This adapter consumes directly from the callcenter/speechprocessing/utterances topic and builds tuples of type commonCallUtterance
for consumption by the Transcript builder (by publishing to callcenter/commonCallUtterances). 