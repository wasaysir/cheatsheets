= Device Interfaces
== Device Input Modes
/ Request Mode: Alternate application and device execution.
  - App requests input and then suspends execution
  - Device wakes up, processes input, then suspends execution
  - App resumes execution with input data
/ Sample Mode: Concurrent app and device execution.
  - Device continually updates registers/mem locations
  - App may read at any time
/ Event Mode: Concurrent app and device execution with concurrent queue management service
  - Device continually offers input to the queue
  - App may request selections and services from the queue (or queue may interrupt application)

== App Structure
Apps can engage in requesting, polling, event processing. Events may or may not be interruptive. If not interruptive they can be read as blocking/non-blocking. 

/ Polling: Value of input device constantly checked in tight loop, waiting for a change. This is generaly inefficient and should be avoided, especially in time-sharing systems.
/ Sampling: Value of input device is read and then program proceeds. There is no loop. 

== Event Queues
*Event Queue*:
- Device is monitored by asynchronous process.
- Upon a change, the process places the record into an event queue
- App can request a read-out (summary) of important features of queue and also modify the queue to their desire.

*Event Loop*:
- Events are processed in event loop
- App merely registers event-process pairs
- Queue manager does all the rest (if event E then process P)
- Events can be general or specific (ex. mouse button pressed vs timer event after a certain interval)

== Toolkits and Callbacks
Event-loop processing can be generalized:
- Instead of switch, use table lookup. Each table entry associates an event with a callback function. 
- When event occurs, corresponding callback is invoked.
- Provide an API to make and delete table entries.
- Divide screen into parcels, and assign different callbacks to different parcels.
- Event manager does most or all of the administration.

/ Widgets: Tool for modular UI functionality. These are parcels of the screen taht respond to events. Their looks imply their function.
- Widgets can respond to events with a change in apperance, as well as issue callbacks. 