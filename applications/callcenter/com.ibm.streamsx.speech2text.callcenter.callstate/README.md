# Call State Service

The purpose of this service is to provide the current state and "journey" of a call. We take as input a generalized form of a 
CTI event, requiring that a commonCallId be provided, as well as pulling out the Action and event time from the event. This allows 
for the integration of events of multiple formats. We can still maintain a record of the complete event details as part of the journey by 
storing the JSON representation of each event. 

The key benefit of this application is that it provides a way to easily implement an ACTION -> STATE correlation. This 
can be done by modifying the actionToStateMap variable to handle actions that correlate to a single state result (multiple 
actions may result in the same state). In the case that a single action may result in multiple states, update the 
getStateTransition function in ReadModifyUpdateStateAndJourney.spl

## Docs
The bulk of the information about this toolkit can be found by generating the SPL-DOC: 

make docs

