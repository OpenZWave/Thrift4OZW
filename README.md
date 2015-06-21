###Thrift4OZW

This project aims to be a multi-lingual interface to the [OpenZWave library]
(http://www.openzwave.com), a C++ library for the ZWave wireless
home automation protocol, using two enabling technologies, which are:

- Apache Thrift ( http://thrift.apache.org )
as the RPC abstraction service
- STOMP ( http://stomp.codehaus.org )
as a means to store & transmit OpenZWave's notifications over the network (since Thrift lacks asynchronous calls other than exceptions)

The project, after successful compilation, creates an "OpenZWave daemon" (ozwd)
which opens up 1) a server port for Thrift in order to receive commands and pass
them through OpenZWave to your ZWave controller (usually a USB stick) and 2) a
client port to a STOMP server so as to publish notifications on asynchronous
events that the OpenZWave library generates.

Thus you can have access to the wonderful world of ZWave with the help of
OpenZWave from all languages currently supported by Apache Thrift which are,
at the time of this writing: C++, Java, Python, PHP, Ruby, Erlang, Perl,
Haskell, C#, Cocoa, JavaScript, Node.js, Smalltalk, OCaml and Delphi.

(as a sidenote: I've recently forked and extended a node.js 0.10.x/0.12.x addon for OpenZWave, check out [node-openzwave-shared](https://github.com/OpenZWave/node-openzwave-shared) if you specifically aim for server-side Javascript)

This is a simple diagram to illustrate the idea behind Thrift4OZW:
```
+--------------+ Thrift API    +---------------+ Open   +-------------+
| Zwave        | ------------> | Zwave daemon  | ZWave  | Zwave       |
| application  | (commands)    | (ozwd) - C++  | ====== | Controller  |
|              |               +---------------+ (C++)  | (USB or     |
|              |                       v                |  HIDAPI)    |
|              |               +---------------+        |             |
|              | notifications | STOMP Server  |        |             |
+--------------+ <------------ +---------------+        +-------------+
		 via STOMP subscription
```

These are the side-projects I'm using for this project:

[Thrift Server Creator (create_server.rb)](../blob/master/create_server.rb)
----------------------------------------
A hackity Ruby script I wrote to automatically create useful Thrift server
bindings (instead of silly "your code goes here", as produced by Thrift).
Uses RbGCCXML ( http://rbplusplus.rubyforge.org/rbgccxml/ ) to parse both
source + target and then tries to create compilable & working code.

[BoostStomp - a C++ STOMP client](https://github.com/ekarak/BoostStomp)
------------------------------------
A homegrown C++ client for STOMP, built using only the Boost libraries.
Makes use of Boost's ASIO (Asynchronous I/O) model as well as some other
useful Boost facilities. It provides the asynchronous notification mechanism
used to pass OpenZWave notifications to Thrift4OZW. For more info about
BoostStomp, check out its homepage:


