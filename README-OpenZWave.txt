----------------------------------------------------------------------------------------------------
HOW TO USE OpenZWave FROM THE LANGUAGE OF YOUR CHOICE:
----------------------------------------------------------------------------------------------------
OK folks, after several months of tweaking I can now talk to my ZWave devices 
at the leisure of Ruby's friendly IRB interpreter. So can you, in any language you 
choose (Cocoa, C#, Erlang, Go, Java, JS, Perl, PHP, Python, Ruby...). Here's how:

- First get a copy of the code:    
    # wget https://github.com/ekarak/Thrift4OZW/zipball/master
- Then unzip it to a folder, preferrably next to OZW's root folder (open-zwave-read-only)
My folder hierarchy is:
/home/
    ekarak/
        ozw/ (all things about openzwave)
            Thrift4OZW (this library)
            open-zwave-read-only (the main OZW trunk)
            openzwave-control-panel (other OZW subproject)

- Skip to next section if you're running Linux x86/32-bit and just want to try talking
to the OpenZWave library (a precompiled binary is included)

- Take a look at ozw.thrift, it's the Thrift interface definition file. All of the useful 
public Manager methods (130 out of 137) are exposed. (Constructors/destructors are not exposed)

- Make sure you have the necessary required libraries (plus headers)
	BoostStomp: sister project , a tiny c++ STOMP client library based on Boost
	Apache Thrift: http://thrift.apache.org, grab sources, configure and make install

- I assume you have Ruby >=1.9.1 installed with RbGCCXML and bit-struct (gem install rbgccxml bit-struct)

- Inspect the Makefile, change directories (unless your username is ekarak!)

- Run make, cross fingers, pop champagne.

- The generated code is patched twice (I know, I know, this sucks) in order for the compilation 
of the C++ openzwave daemon to succeed:

1) these constructors/converters are patched in class RemoteValueID (gen-cpp/ozw_types.h) :
  RemoteValueID(ValueID vid);
  ValueID toValueID();

2) Inspect each function marked with a warning during the server generation phase. 
There are some functions in OZW that use C-ish arguments and need manual handling. 
(GetNodeNeighbors is an example I can think of). 
See gen-cpp/RemoteManager_server.cpp.patch to see the changes I made in order to have 
meaningful results from OpenZWave to the Thrift server.


---------------------------------------------------------------------
TALKING TO THE OPENZWAVE THRIFT SERVER (ozwd)
---------------------------------------------------------------------
OK, you have the server binary (./ozwd) either precompiled or you did it yourself. Fine.
- Install a STOMP Server (gem install stompserver), or if you're on Ruby 1.9 install 
stompserver_ng from git:
    # git clone git://github.com/gmallard/stompserver_ng.git
    # cd stompserver_ng
    # sudo ruby1.9.1 setup.rb
Then, run it with the debug flag (stompserver_ng -d). This will launch the STOMP server
which will route all notifications from OZW to anywhere you want it to.

Hook up your ZWave USB controller. Default is set at /dev/ttyUSB0, you can use the 
-p argument to tell ozwd to look for the controller anywhere else 

Other ozwd command-line flags are:

ekarak@ekarak-laptop ~/ozw/Thrift4OZW $ ./ozwd --help
----------------------------------------
Project Ansible - OpenZWave orbiter
----------------------------------------
command-line arguments:
  -? [ --help ]                         print this help message
  -h [ --stomphost ] arg (=localhost)   external STOMP server hostname
  -s [ --stompport ] arg (=61613)       external STOMP server port number
  -t [ --thriftport ] arg (=9090)       our Thrift service port
  -c [ --ozwconf ] arg (=/home/ekarak/ozw/open-zwave-read-only/config/)
                                        our OpenZWave manufacturer database
  -u [ --ozwuser ] arg (=/home/ekarak/ozw/Thrift4OZW)
                                        our OpenZWave user config database
  -p [ --ozwport ] arg (=/dev/ttyUSB0)  our OpenZWave driver port
  -j [ --json ]                         Should stomp messages have JSON body?
  -d [ --debug ]                        Show debug logging from OpenZwave and 
                                        BoostStomp?

  
- Fire up ./ozwd, preferrably in a debugger (gdb ./ozwd) if you need to trace its internals.

The OpenZWave orbiter tries to connect to the Stomp Server (localhost:61613) and then 
starts the OpenZWave engine.  When all ZWave processing is done, it also fires up the 
Thrift server at 127.0.0.1:9090, and listens for requests.

Let's connect from Ruby as an example. We'll be using the Interactive Ruby Shell to load the 
demo code. It will also load a rudimentary OpenZWave monitor that spits out notifications
that contain all sort of useful data, along with your ZWave HomeID:

ekarak@ekarak-laptop:~/ozw/Thrift4OZW$ irb1.9.1 -I. -r ozwthrift.rb
Parsing /home/ekarak/ozw/open-zwave-read-only/cpp/src/Notification.h for enum NotificationType...
Parsing /home/ekarak/ozw/open-zwave-read-only/cpp/src/value_classes/ValueID.h for enum ValueGenre...
Parsing /home/ekarak/ozw/open-zwave-read-only/cpp/src/value_classes/ValueID.h for enum ValueType...
#<OpenZWave::RemoteManager::Client:0x95d3ff0 @iprot=#<Thrift::BinaryProtocol:0x95d4590 @trans=#<Thrift::BufferedTransport:0x95d45cc @transport=#<Thrift::Socket:0x95d461c @host="localhost", @port=9090, @timeout=nil, @desc="localhost:9090", @handle=#<Socket:fd 7>>, @wbuf="", @rbuf="", @index=0>, @strict_read=true, @strict_write=true, @rbuf="\x00\x00\x00\x00\x00\x00\x00\x00">, @oprot=#<Thrift::BinaryProtocol:0x95d4590 @trans=#<Thrift::BufferedTransport:0x95d45cc @transport=#<Thrift::Socket:0x95d461c @host="localhost", @port=9090, @timeout=nil, @desc="localhost:9090", @handle=#<Socket:fd 7>>, @wbuf="", @rbuf="", @index=0>, @strict_read=true, @strict_write=true, @rbuf="\x00\x00\x00\x00\x00\x00\x00\x00">, @seqid=0>

Go ahead and fire commands at OpenZWave, be sure to set your HomeID first:
irb(main):002:0> HomeID = 0x00001234 (!!!example!!!)

# Get a node's name
irb(main):002:0> OZWmgr.GetNodeName(HomeID, 5)
=> "ACT Schuko Dimmer"

# Switch on node 2
irb(main):003:0> OZWmgr.SetNodeOn(HomeID, 2)
=> nil 
# (*tack*) did you see the baanshee turning on the christmas tree lights?? :-)

# Set dimmer node 5 at 50% via SetNodeLevel
irb(main):004:0> OZWmgr.SetNodeLevel(HomeID, 5, 50)
=> nil

# Construct a RemoteValueID for node 5, BasicSet command class
Rvid = OpenZWave::RemoteValueID.new
Rvid._homeId  = HomeID
Rvid._nodeId = 5
Rvid._genre = 0 # OpenZWave::RemoteValueGenre::ValueGenre_Basic
Rvid._type = 1 # OpenZWave::RemoteValueType::ValueType_Byte
Rvid._instance = 1
Rvid._valueIndex = 0
Rvid._commandClassId = 32

# Set dimmer node 5 at 50% via SetValue
irb(main):012:0> OZWmgr.SetValue_UInt8(Rvid,50)
=> true 

# Read node's ValueID
irb(main):013:0> OZWmgr.GetValueAsByte(Rvid)
=> <OpenZWave::Bool_UInt8 retval:true, o_value:50>

# Set that value to 25 (percent if its a dimmer)
irb(main):014:0> OZWmgr.SetValue_UInt8(Rvid,25)
=> true

# Set it to 0
irb(main):015:0> OZWmgr.SetValue_UInt8(Rvid,0)
=> true


-------------------
STOMP Notifications
-------------------
The other useful feature of the Ruby client example is OpenZWave notifications.
Take a look at ozw-monitor.rb, its a basic STOMP client in Ruby listening for OpenZWave 
notifications. The script uses the BitStruct library to break down ValueIDs into fields. 
Take into account that you should keep all ValueID's in a Hash or Array for subsequent 
calls to OpenZWave. All asynchronous notifications will appear in the irb console:

------ ZWAVE MESSAGE (2013-03-31 10:37:34 +0300) ------
   NotificationByte : 0
   NotificationNodeId : 0x1
  notification type: Type_DriverReady: A driver for a PC Z-Wave controller has been added and is ready to use.  The notification will contain the controller's Home ID, which is needed to call most of the Manager methods.
   destination : /queue/zwave/monitor
   session : ssng_1364715183.7324069
   message-id : ekarak-laptop-1364715183-871618-2349
   subscription : 1

------ ZWAVE MESSAGE (2013-03-31 10:37:34 +0300) ------
   NotificationByte : 0
   NotificationNodeId : 0x1
  notification type: Type_NodeAdded: A new node has been added to OpenZWave's list.  This may be due to a device being added to the Z-Wave network, or because the application is initializing itself.
   destination : /queue/zwave/monitor
   session : ssng_1364715183.7324069
   message-id : ekarak-laptop-1364715183-907925-2350
   subscription : 1



----------------------------
OpenZWave + other languages
----------------------------
You can try using the server from other languages. I've posted the generated Thrift code 
for all languages it can generate client code, Read Thrift's tutorial (more info at 
http://thrift.apache.org) and you should be able to talk to OpenZWave from your 
language of choice with minimal effort.

That's it for the time being.
Elias
