------------------------------------
Thrift Server Generator
a.k.a. "fills in the blanks for you"
------------------------------------
(c) 2011-2012 Elias Karakoulakis <elias.karakoulakis@gmail.com>

Requirements:
-------------
    Apache Thrift >= 0.7.0 (currently tested with 0.9.0)
    Ruby >= 1.9.1 (currently 1.9.2)
    RbGCCXML (http://rbplusplus.rubyforge.org/rbgccxml/) >= 1.0.3

About the script:
-----------------
When I learned about Thrift, I immediately fell in love with it: it made RPC 
almost "transparent", like the way I imagined it, and best of all, crossing 
most programming languages barriers with ease!

What it lacks though is the "sauce" that binds it to your infrastructure, 
and when you have a 100+ methods C++ API to begin with, it is awkward
that you still need to write the server code all by yourself.

This little script is a nice complement to Apache Thrift. All it does is to parse 
two sets of files: 1) the C++ server skeleton file produced by Thrift, and 
2) the headers of the C++ library you want to expose with Thrift. 
It uses the excellent tool "RbGCCXML" to build an XML-like tree of the two 
interfaces and binds them together (with a little help from you of course!).

So say you want to expose your shiny app/lib to the world. Only problem is 
it's API is of monstrous size (hundreds of methods) and you need it quick. 
Use this script and you can have the skeleton file automatically generate 
the actual server code for Thrift. And, if you're lucky (and the library's 
API is consistent), you even might compile it without errors!

For example, OpenZWave has a single "Manager" class for interfacing with 
the rest of the world, as shown below (comments stripped for brevity)

namespace OpenZWave {
    class Manager {
        bool isPolled( ValueID const _valueId );
        void SetPollInterval( int32 _seconds );
        string GetNodeType( uint32 const _homeId, uint8 const _nodeId );
	bool GetValueListSelection( ValueID const& _id, string* o_value );
	bool GetValueListSelection( ValueID const& _id, int32* o_value );
        ... etc
    }
}

You can declare all the API as a Thrift IDL file:

namespace OpenZWave {
	service RemoteManager {
		bool isPolled( 1:RemoteValueID _valueId );
		void SetPollInterval( 1:i32 _seconds );
		string GetNodeType( 1:i32 _homeId, 2:byte _nodeId );
		Bool_String GetValueListSelection_String( 1:RemoteValueID _id );
		Bool_Int GetValueListSelection_Int32( 1:RemoteValueID _id );
		... etc
	}
}

Then you configure & run the script:

ekarak@ekarak-laptop:~/ozw/thrift4ozw$ ruby1.9.1 create_server.rb
(...tons of debug messages: look out for WARNINGS)

the script tries to map functions (including overloaded ones) from 
the Thrift-generated skeleton file into the realm of the existing library, so that:

  bool IsPrimaryController(const int32_t _homeId) {
    // Your implementation goes here
    printf("IsPrimaryController\n");
  }

turns into:

  bool IsPrimaryController(const int32_t _homeId) {
	Manager* mgr = Manager::Get();
	g_criticalSection.lock();
	bool function_result =  mgr->IsPrimaryController((::uint32 const) _homeId);
	g_criticalSection.unlock();
	return(function_result);
  }

The critical section is needed to serialize access to OZW from the thrift 
server's thread. Got it? S&S (silly and simple....)

The produced C++ server file will probably still need some manual tweaking, 
but that's up to the quality of the library's API. In my case (the OpenZWave 
library), I only had to write some 15 lines of extra code for 3 methods with 
"peculiar" arguments, like iterating over a pointer array to fill in a vector of int's.

For instance, there's the "Manager::GetNodeNeighbors" method:
(uint32 GetNodeNeighbors( uint32 const _homeId, uint8 const _nodeId, uint8** _nodeNeighbors );

Look at the last argument: am I dreaming?? a double star in C++??  
The method is a C-style call to get a bitmap of node neighbors, its return 
value is the size of the array pointed by _nodeNeighbors. If the map is 
empty, you don't need to delete the map (so does the OpenZWave API say)
Its thrift IDL is:

struct UInt32_ListByte {
    1:i32   retval;
    2:list<byte> _nodeNeighbors; // will get mapped onto a std::vector<int> by Thrift
}
UInt32_ListByte GetNodeNeighbors( 1:i32 _homeId, 2:byte _nodeId);

And the produced Thrift server code for C++ is:

  void GetNodeNeighbors(UInt32_ListByte& _return, const int32_t _homeId, const int8_t _nodeId) {
	Manager* mgr = Manager::Get();
	g_criticalSection.lock();
	_return.retval =  mgr->GetNodeNeighbors((::uint32 const) _homeId, (::uint8 const) _nodeId, (::uint8**) &_return._nodeNeighbors); 
	// RUNTIME ERROR, vector<uint8> cannot be mapped onto a uint8**
	g_criticalSection.unlock();
  }

The create_server.rb script tried to cast a vector<uint8> to the _nodeNeighbors 
argument but this will coredump your executable because the method is 
expecting a plain-old C-style pointer to an array of uint8. Alas, you have to 
manually write a simple iterator:

  void GetNodeNeighbors(UInt32_ListByte& _return, const int32_t _homeId, const int8_t _nodeId) {
      uint8* arr;
	Manager* mgr = Manager::Get();
	g_criticalSection.lock();
	_return.retval =  mgr->GetNodeNeighbors((::uint32 const) _homeId, (::uint8 const) _nodeId, (::uint8**) &arr);
	g_criticalSection.unlock();
    if (_return.retval > 0) {
        for (int i=0; i<_return.retval; i++) _return._nodeNeighbors.push_back(arr[i]);
        delete arr;
    }
  }

I'm using a simple patching mechanism in order to store these manual changes. 
See Makefile for details. In general, all you have to do is: 1) edit the generated 
server code till it works (compiles and runs ok) 2) copy the manually edited server 
code (RemoteManager_server.cpp) into a backup (RemoteManager_server.cpp.patched)
and 3) call "make patchdiffs" to store the patch diffs for future use. 
All subsequent calls to "make" will use these patches to patch the server code 
right before compiling it into a binary.

1) The rough requirements are:
-----------------------------------------------
Use a universal naming conversion using the underscore('_') for overloaded 
functions and datatypes. For instance, these OpenZWave::Manager overloaded 
methods (look for "GetValueListSelection") must be declared in Thrift as:

    //(C++ API) bool GetValueListSelection( ValueID const& _id, string* o_value );
    Bool_String GetValueListSelection_String( 1:RemoteValueID _id );

    //(C++ API) bool GetValueListSelection( ValueID const& _id, int32* o_value );
    Bool_Int GetValueListSelection_Int32( 1:RemoteValueID _id );

This example illustrates the use of underscore in both intended cases:
- the function return struct (since there are two values we need to get them
returned)
- the function overloading mechanism (since Thrift doesn't support 
overloading by its own)

Bool_String and Bool_Int are simple Thrift structs with TWO members:
  1: bool retval = the function's result value (bool in our case)
  2: (string or i32) arg = the function's last argument, passed as a pointer

The Thrift function naming scheme maps these two functions to C++ server code as:

  void GetValueListSelection_String(Bool_String& _return, const RemoteValueID _id) 
  void GetValueListSelection_Int32(Bool_Int& _return, const RemoteValueID _id)

And the script's generated code for these two methods is:

  void GetValueListSelection_String(Bool_String& _return, const RemoteValueID _id) {
	Manager* mgr = Manager::Get();
	g_criticalSection.lock();
	 _return.retval =  mgr->GetValueListSelection(_id.toValueID(), (std::string*) &_return.o_value);
	g_criticalSection.unlock();
  }

  void GetValueListSelection_Int32(Bool_Int& _return, const RemoteValueID _id) {
	Manager* mgr = Manager::Get();
	g_criticalSection.lock();
	_return.retval =  mgr->GetValueListSelection(_id.toValueID(), (::int32*) &_return.o_value);
	g_criticalSection.unlock();
  }


December 2011,
Elias Karakoulakis
