----------
Thrift4OZW
----------

This project aims to be a fully functional interface to the OpenZWave library ( http://code.google.com/p/open-zwave/ ) using:

1) Apache Thrift ( http://thrift.apache.org ) as the RPC abstraction service
2) STOMP ( http://stomp.codehaus.org ) as a means to store & transmit OpenZWave's notifications over the network

Being an experimental project, I have used quite a lot of external tools & libs but they're easy to get rid of if we need to get it going anywhere. These libs are:


STOMP client: (PocoStomp.*, Stomp.*)
------------------------------------
SMC - The State Machine Compiler: in order to model the STOMP client state machine
PoCo libraries - a very easy and intuitive C++ toolkit ( http://pocoproject.org)


Thrift Server Creator (create_server.rb)
----------------------------------------
A hackity Ruby script I wrote to create useful Thrift server bindings (instead of silly "your code goes here", as produced by Thrift). Uses RbGCCXML ( http://rbplusplus.rubyforge.org/rbgccxml/ ) to parse both source + target and then tries to create compilable & working code.
See: README-ThriftServerCreator.txt




