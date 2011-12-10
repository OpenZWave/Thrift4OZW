------------------------------------
Thrift Server Generator
a.k.a. "fills in the blanks for you"
------------------------------------
(c) 2011 Elias Karakoulakis <elias.karakoulakis@gmail.com>

Requirements:
-------------
    Apache Thrift >= 0.7.0
    Ruby >= 1.9.1
    RbGCCXML (http://rbplusplus.rubyforge.org/rbgccxml/) >= 1.0.1

About the script:
-----------------
When I learned about Thrift, I immediately fell in love with it: it made RPC almost "transparent", like the way I imagined it, and best of all, crossing most programming languages barriers with ease!

What it lacks though is the "sauce" that binds it to your infrastructure, and when you have a 100+ methods API to begin with it is shocking that you still need to write the server code all by yourself.

This little script is a nice complement to Apache Thrift. All it does is to parse two sets of files: 1) the server skeleton file produced by Thrift, and 2) the headers of the library you want to expose with Thrift. It uses the excellent tool "RbGCCXML" to build an XML-like tree of the two interfaces and  binds them together (*ahem* at least it tries to).

So say you want to expose your shiny app/lib to the world. Only problem is it's API is of monstrous size (hundreds of methods) and you need it quick. Use this script and you can have the skeleton file automatically generate the actual server code for Thrift. And, if you're lucky, you even might compile it without errors!

For example, OpenZWave has a single "Manager" class for interfacing with the rest of the world. 

namespace OpenZWave {
    class Manager {
        bool isPolled( ValueID const _valueId );
        void SetPollInterval( int32 _seconds );
        string GetNodeType( uint32 const _homeId, uint8 const _nodeId );
        ... etc
    }}

You can declare all the API as a Thrift IDL file:

service RemoteManager {
    bool isPolled( 1:RemoteValueID _valueId );
    void SetPollInterval( 1:i32 _seconds );
    string GetNodeType( 1:i32 _homeId, 2:byte _nodeId );
    ...
}

Then you configure & run the script:
ekarak@ekarak-laptop:~/ozw/thrift4ozw$ ruby1.9.1 create_server.rb
CREATING MAPPING for (bool) IsPrimaryController
tgt=::uint32 const _homeId, src=RemoteManagerHandler::IsPrimaryController::_homeId
...tons

the resulting code tries to map functions (including overloaded ones) from the Thrift skeleton file into the realm of the existing library, such as:

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

Got it? S&S (silly and simple....)

The produced C++ server file will probably still need some manual tweaking, but that's up to the quality of the library's API. In my case (the OpenZWave library), I only had to write some 15 lines of extra code for 3 methods with "peculiar" arguments.



1) The rough requirements are:
-----------------------------------------------
    Use a universal naming conversion using the underscore('_') for overloaded functions and datatypes. For instance, these OpenZWave::Manager overloaded methods ("GetValueListSelection") must be declared in Thrift as:

    //(c++) bool GetValueListSelection( ValueID const& _id, int32* o_value );
    Bool_String GetValueListSelection_String( 1:RemoteValueID _id );

    //(c++) bool GetValueListSelection( ValueID const& _id, int32* o_value );
    Bool_Int GetValueListSelection_Int32( 1:RemoteValueID _id );

This example illustrates the use of underscore in both intended cases:
- the function return struct (since there are two values we need to get them returned)
- the function overloading mechanism (since Thrift doesn't support overloading by its own)

Bool_xxxxx is a simple struct with TWO members:
  1: bool retval = the function's result value (bool in our case)
  2: (string/i32) arg = the last argument, passed as a pointer
(*FIXME* possible memory leak here!)

The Thrift function naming scheme maps these two functions as:
  void GetValueListSelection_String(Bool_String& _return, const RemoteValueID _id) 
  void GetValueListSelection_Int32(Bool_Int& _return, const RemoteValueID _id)

And the script's generated code for these two methods is:

  void GetValueListSelection_String(Bool_String& _return, const RemoteValueID _id) {
	Manager* mgr = Manager::Get();
	g_criticalSection.lock();
	 _return.retval =  mgr->GetValueListSelection(*g_values[_id], (std::string*) &_return.arg);
	g_criticalSection.unlock();
  }

  void GetValueListSelection_Int32(Bool_Int& _return, const RemoteValueID _id) {
	Manager* mgr = Manager::Get();
	g_criticalSection.lock();
	 _return.retval =  mgr->GetValueListSelection(*g_values[_id], (::int32*) &_return.arg);
	g_criticalSection.unlock();
  }

That's all for now, have to change diapers!!!
