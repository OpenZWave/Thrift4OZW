----------
Thrift4OZW
----------

This project aims to be a fully functional interface to the OpenZWave library 
( http://code.google.com/p/open-zwave/ ) using:

1) Apache Thrift ( http://thrift.apache.org ) as the RPC abstraction service
2) STOMP ( http://stomp.codehaus.org ) as a means to store & transmit 
OpenZWave's notifications over the network (since Thrift lacks asynchronous
calls other than exceptions)

Being an experimental project, I have used some external tools & libs. These are:

BoostStomp - a C++ STOMP client:
------------------------------------
A homegrown C++ client for STOMP, built using only the Boost libraries.
Makes use of Boost's ASIO (Asynchronous I/O) model as well as some other 
useful Boost facilities. It provides the asynchronous notification mechanism 
used to pass OpenZWave notifications to Thrift4OZW. For more info about 
BoostStomp, check out its homepage:

    https://github.com/ekarak/BoostStomp


Thrift Server Creator (create_server.rb)
----------------------------------------
A hackity Ruby script I wrote to create useful Thrift server bindings 
(instead of silly "your code goes here", as produced by Thrift). 
Uses RbGCCXML ( http://rbplusplus.rubyforge.org/rbgccxml/ ) to 
parse both source + target and then tries to create compilable 
& working code.
See: README-ThriftServerCreator.txt




