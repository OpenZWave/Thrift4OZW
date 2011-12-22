----------------------------------------------------------------------------------------------------
HOW TO USE OpenZWave FROM THE LANGUAGE OF YOUR CHOICE:
----------------------------------------------------------------------------------------------------
OK folks, after several months of tweaking I can now talk to my ZWave devices 
at the leisure of Ruby's friendly IRB interpreter. So can you, in any language you 
choose (Cocoa, C#, Erlang, Go, Java, JS, Perl, PHP, Python, Ruby...). Here's how:

- First get a copy of the code:    https://github.com/ekarak/Thrift4OZW/zipball/master
- Then unzip it to a folder, preferrably next to OZW's root folder (open-zwave-read-only)
My folder hierarchy is:
/home/
    ekarak/
        ozw/ (all things about openzwave)
            Thrift4OZW (this library)
            open-zwave-read-only (the main OZW trunk)
            openzwave-control-panel (other OZW subproject)

- Skip to next section if you're running Linux 32-bit and just want to try talking to the library 
(a precompiled binary is included)
- Take a look at ozw.thrift , it's the Thrift interface definition file. Most (not all!) of Manager 
(124 out of 138) public methods are exposed.
- Install SMC (http://smc.sf.net) , and Poco  (http://www.pocoproject.org), both development 
versions (with headers)
- I assume you have Ruby >=1.9.1 installed with RbGCCXML and Nokogiri (gem install rbgccxml)
- Inspect the Makefile, change directories (unless your username is ekarak!)
- Run make, cross fingers, pop champagne.
- The generated code is patched twice (I know, I know, this sucks) in order for the compilation to succeed:

1) these constructors/converters are patched in class RemoteValueID (gen-cpp/ozw_types.h) :
// ekarak: constructor from ValueID
  RemoteValueID(ValueID vid) : 
    _homeId ((int32_t) vid.GetHomeId()), 
    _nodeId ((int8_t) vid.GetNodeId()), 
    _genre  ((RemoteValueGenre::type) vid.GetGenre()),
    _commandClassId((int8_t) vid.GetCommandClassId()), 
      _instance ((int8_t) vid.GetInstance()), 
      _valueIndex((int8_t) vid.GetIndex()),
    _type ((RemoteValueType::type) vid.GetType()) { }
// ekarak: converter to ValueID
ValueID toValueID() const {
    return ValueID((uint32)_homeId, (uint8)_nodeId, (ValueID::ValueGenre)_genre, (uint8)_commandClassId, (uint8)_instance, (uint8)_valueIndex, (ValueID::ValueType)_type);
}

2) Inspect each function marked with a warning during the server generation phase. 
There are two or three functions in OZW that use C-ish arguments and need manual handling. 
(GetNodeNeighbors is an example I can think of). 
See gen-cpp/RemoteManager_server.cpp.patch to see the changes I made in order to have 
meaningful results from OpenZWave to the Thrift server.


---------------------------------------------------------------------
TALKING TO THE OPENZWAVE THRIFT SERVER 
---------------------------------------------------------------------
OK, you have the server binary (./main) either precompiled or you did it yourself. Fine.
- Install a STOMP Server (gem install stompserver). It will route all notifications from OZW to anywhere you want it to.
- Hook up your favourite USB controller at /dev/ttyUSB0 (sorry its hardcoded for the time being, see Main.cpp)
- Fire up ./main, preferrably in a debugger (gdb ./main)

The server tries to connect to the Stomp Server (localhost:61613) and then starts the OpenZWave engine. 
When all ZWave processing is done, it also fires up the Thrift server at port 9090, and listens for requests.

Let's connect from Ruby as an example. First edit ozwthrift.rb and fill in the correct HomeID for your controller.
Then fire up the Interactive Ruby Shell and load the bootup code:

ekarak@ekarak-laptop:~/ozw/Thrift4OZW$ irb1.9.1
irb(main):001:0> load 'ozwthrift.rb'
=> true

# Get a node's name
irb(main):002:0> OZWmgr.GetNodeName(HomeID, 5)
=> "ACT Schuko Dimmer"

# Switch on node 2
irb(main):003:0> OZWmgr.SetNodeOn(HomeID, 2)
=> nil 
(*tack*) did you see the baanshee turning on the christmas tree lights?? :-)

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

irb(main):014:0> OZWmgr.SetValue_UInt8(Rvid,25)
=> true

irb(main):015:0> OZWmgr.SetValue_UInt8(Rvid,0)
=> true


You can try using the server from other languages. I've posted the generated Thrift code in the project, 
Read Thrift's tutorial (http://thrift.apache.org) and you should be able to talk to OpenZWave with minimal effort.

That's it for the time being.
Elias