// 
// OpenZWave hub for Project Ansible
// (c) 2011 Elias Karakoulakis <elias.karakoulakis@gmail.com>
//

#include "RemoteManager.h"
#include <protocol/TBinaryProtocol.h>
#include <server/TSimpleServer.h>
#include <transport/TServerSocket.h>
#include <transport/TBufferTransports.h>
#include <string>
#include <sstream>
#include <iostream>

//~ template <class T>
//~ std::string to_string(T t, std::ios_base & (*f)(std::ios_base&))
//~ {
  //~ std::ostringstream oss;
  //~ oss << f << t;
  //~ return oss.str();
//~ }

using namespace ::apache::thrift;
using namespace ::apache::thrift::protocol;
using namespace ::apache::thrift::transport;
using namespace ::apache::thrift::server;

using boost::shared_ptr;
 
using namespace OpenZWave;

// boost: extra includes
#include <boost/thread.hpp>
// the global mutex for accessing OpenZWave library
static boost::recursive_mutex     g_criticalSection;

//
// Struct to hold all valid OpenZWave ValueID's
// (used by RemoteManager_server.cpp)
typedef struct
{
	uint32			m_homeId;
	uint8			m_nodeId;
	bool			m_polled;
    //std::map<uint64, ValueID*>	m_values;
    list<ValueID>	m_values;
} NodeInfo;
//
static list<NodeInfo*>          g_nodes;
static std::map<uint64, ValueID*> g_values;

// OpenZWave includes
#include "Notification.h"

// PocoStromp
#include "PocoStomp.h"

static uint32 g_homeId = 0;
static bool   g_initFailed = false;
//

static boost::condition_variable  initCond ;
static boost::mutex                     initMutex;

// STOMP statics
static STOMP::PocoStomp* stomp_client;
static string*          notifications_topic = new string("/queue/zwave/monitor");

//-----------------------------------------------------------------------------
// <GetNodeInfo>
// Callback that is triggered when a value, group or node changes
//-----------------------------------------------------------------------------
NodeInfo* GetNodeInfo
(
	Notification const* _notification
)
{
	uint32 const homeId = _notification->GetHomeId();
	uint8 const nodeId = _notification->GetNodeId();
	for( list<NodeInfo*>::iterator it = g_nodes.begin(); it != g_nodes.end(); ++it )
	{
		NodeInfo* nodeInfo = *it;
		if( ( nodeInfo->m_homeId == homeId ) && ( nodeInfo->m_nodeId == nodeId ) )
		{
			return nodeInfo;
		}
	}

	return NULL;
}

//-----------------------------------------------------------------------------
// <OnNotification>
// Callback that is triggered by OpenZWave when a value, group or node changes
//-----------------------------------------------------------------------------
void OnNotification
(
    Notification const* _notification,
    void* _context
)
{
    bool notify_stomp = true;
    
    // Must do this inside a critical section to avoid conflicts with the main thread
    g_criticalSection.lock();
    
    switch( _notification->GetType() )
    {
        /**< A new node value has been added to OpenZWave's list. 
        These notifications occur after a node has been discovered, 
        and details of its command classes have been received.  
        Each command class may generate one or more values, 
        depending on the complexity of the item being represented.  */
        case Notification::Type_ValueAdded: 
        {
            if( NodeInfo* nodeInfo = GetNodeInfo( _notification ) )
            {
                // Add the new value to the node's value list
                ValueID v = _notification->GetValueID();
                nodeInfo->m_values.push_back( v );
                uint64 key = v.GetId();
                // ekarak: also add it to global ValueID map
                //std::cout << "========================= Adding "<<key<<std::hex<< " to g_values..."<<std::endl;
                g_values[ key ] = &v;
            }
            //send_valueID = true;
            break;
        }

        /**< A node value has been removed from OpenZWave's list.  
        This only occurs when a node is removed. */
        case Notification::Type_ValueRemoved:
        {
            if( NodeInfo* nodeInfo = GetNodeInfo( _notification ) )
            {
                // Remove the value from out list
				for( list<ValueID>::iterator it = nodeInfo->m_values.begin(); it != nodeInfo->m_values.end(); ++it )
				{
					if( (*it) == _notification->GetValueID() )
					{
						nodeInfo->m_values.erase( it );
						break;
					}
				}

                //~ // Remove the value from out list
                for( list<ValueID>::iterator it = nodeInfo->m_values.begin(); it != nodeInfo->m_values.end(); ++it )
                {
                    if( (*it) == _notification->GetValueID() )
                    {
                        nodeInfo->m_values.erase( it );
                        break;
                    }
                }
            }
            g_values.erase(_notification->GetValueID().GetId());
            //send_valueID = true;
            break;
        }
            
        /**< A node value has been updated from the Z-Wave network. */
        case Notification::Type_ValueChanged: {
            //send_valueID = true;
        /**< The associations for the node have changed. The application 
        should rebuild any group information it holds about the node. */
        }
        case Notification::Type_Group:
        /**< A new node has been found (not already stored in zwcfg*.xml file) */
        case Notification::Type_NodeNew:
        /**< Basic node information has been receievd, such as whether the node is a 
        listening device, a routing device and its baud rate and basic, generic and 
        specific types. It is after this notification that you can call Manager::GetNodeType 
        to obtain a label containing the device description. */
        case Notification::Type_NodeProtocolInfo:
        /**< A node has triggered an event.  This is commonly caused when a node sends 
        a Basic_Set command to the controller.  The event value is stored in the notification. */
        case Notification::Type_NodeEvent:
        {
            if( NodeInfo* nodeInfo = GetNodeInfo( _notification ) )
            {
                // One of the node's association groups has changed
                // TBD...
                nodeInfo = nodeInfo;
            }
            break;
        }


        /**< A new node has been added to OpenZWave's list.  This may be due 
        to a device being added to the Z-Wave network, or because 
        the application is initializing itself. */
        case Notification::Type_NodeAdded:
        {
            // Add the new node to our list
            NodeInfo* nodeInfo = new NodeInfo();
            nodeInfo->m_homeId = _notification->GetHomeId();
            nodeInfo->m_nodeId = _notification->GetNodeId();
            nodeInfo->m_polled = false;		
            g_nodes.push_back( nodeInfo );
            break;
        }

        /**< A node has been removed from OpenZWave's list.  This may be due 
        to a device being removed from the Z-Wave network, or because the application is closing. */
        case Notification::Type_NodeRemoved:
        {
            // Remove the node from our list
            uint32 const homeId = _notification->GetHomeId();
            uint8 const nodeId = _notification->GetNodeId();
            for( list<NodeInfo*>::iterator it = g_nodes.begin(); it != g_nodes.end(); ++it )
            {
                NodeInfo* nodeInfo = *it;
                if( ( nodeInfo->m_homeId == homeId ) && ( nodeInfo->m_nodeId == nodeId ) )
                {
                    g_nodes.erase( it );
                    break;
                }
            }
            break;
        }

        // Type_NodeNaming missing

        /**< Polling of a node has been successfully turned off by a call to Manager::DisablePoll */
        case Notification::Type_PollingDisabled:
        {
            if( NodeInfo* nodeInfo = GetNodeInfo( _notification ) )
            {
                nodeInfo->m_polled = false;
            }
            break;
        }

        /**< Polling of a node has been successfully turned on by a call to Manager::EnablePoll */
        case Notification::Type_PollingEnabled:
        {
            if( NodeInfo* nodeInfo = GetNodeInfo( _notification ) )
            {
                nodeInfo->m_polled = true;
            }
            break;
        }
        
        /**< A driver for a PC Z-Wave controller has been added and is ready to use.  The notification 
        will contain the controller's Home ID, which is needed to call most of the Manager methods. */
        case Notification::Type_DriverReady:
        {
            g_homeId = _notification->GetHomeId();
            break;
        }

        /**< Driver failed to load */
        case Notification::Type_DriverFailed:
        {
            g_initFailed = true;
            initCond.notify_all();
            break;
        }
        
        //missing Type_DriverReset:  < All nodes and values for this driver have been removed.  This is sent instead of potentially hundreds of individual node and value notifications. */
        //missing MsgComplete  < The last message that was sent is now complete. */
        //missing Type_EssentialNodeQueriesComplete,	/**< The queries on a node that are essential to its operation have been completed. The node can now handle incoming messages. */
        //missing Type_NodeQueriesComplete,			/**< All the initialisation queries on a node have been completed. */
        
        /*< All awake nodes have been queried, so client application can expected complete data for these nodes. */
        case Notification::Type_AwakeNodesQueried:
            
        /**< All nodes have been queried, so client application can expected complete data. */
        case Notification::Type_AllNodesQueried:
        {
                initCond.notify_all();
                break;
        }

        default:
        {
        }
    }
    
    // now we can send the captured event to STOMP queue
    //
    if (notify_stomp) {
        STOMP::hdrmap headers;
        headers["ValueHomeID"] =  to_string<uint32_t>(_notification->GetValueID().GetHomeId(), std::hex);
        headers["NotificationType"] =  to_string<uint32_t>(_notification->GetType(), std::hex);
        headers["NotificationByte"] =  to_string<uint32_t>(_notification->GetByte(), std::hex);
        //if (send_valueID) {
            headers["ValueID"] =  to_string<uint64_t>(_notification->GetValueID().GetId(), std::hex);
        //}
        //
        string empty = ""  ;
        stomp_client->send(*notifications_topic, headers, empty);
    }
    //
    g_criticalSection.unlock();
}

// Send all known values via STOMP
void send_all_values() {
    std::map<uint64, ValueID*>::iterator it;
    for ( it=g_values.begin() ; it != g_values.end(); it++ ) {
        ValueID* v = (*it).second;
        STOMP::hdrmap headers;
        headers["ValueHomeID"] =  to_string<uint32_t>(v->GetHomeId(), std::hex);
        headers["ValueID"] =  to_string<uint64_t>(v->GetId(), std::hex);
        //
        string empty = ""  ;
        stomp_client->send(*notifications_topic, headers, empty);
    }
}

// ------------------------
// THRIFT MAGIC
// ------------------------
// the Thrift-generated (and manually edited) RemoteManager implementation
// for OpenZWave::Manager class
#include "gen-cpp/RemoteManager_server.cpp"
//

int main(int argc, char **argv) {
    // STOMP
    stomp_client = new STOMP::PocoStomp("localhost", 61613);
    stomp_client->connect();

    // OpenZWave initialization
	//initMutex.lock();
    
      // Create the OpenZWave Manager.
	// The first argument is the path to the config files (where the manufacturer_specific.xml file is located
	// The second argument is the path for saved Z-Wave network state and the log file.  If you leave it NULL 
	// the log file will appear in the program's working directory.
	Options::Create( "/home/ekarak/ozw/open-zwave-read-only/config/", "", "" );
	Options::Get()->Lock();

	Manager::Create();
      
    // Add a callback handler to the manager.  The second argument is a context that
	// is passed to the OnNotification method.  If the OnNotification is a method of
	// a class, the context would usually be a pointer to that class object, to
	// avoid the need for the notification handler to be a static.
	Manager::Get()->AddWatcher( OnNotification, NULL );

	// Add a Z-Wave Driver
	// Modify this line to set the correct serial port for your PC interface.

	string ozw_port = "/dev/ttyUSB0";

	Manager::Get()->AddDriver( ozw_port );
	//Manager::Get()->AddDriver( "HID Controller", Driver::ControllerInterface_Hid );

	// Now we just wait for the driver to become ready, and then write out the loaded config.
	// In a normal app, we would be handling notifications and building a UI for the user.
    boost::unique_lock<boost::mutex> initLock(initMutex);
	initCond.wait(initLock);

    // initialize RemoteManager
    int port = 9090;
    shared_ptr<RemoteManagerHandler> handler(new RemoteManagerHandler());
    shared_ptr<TProcessor> processor(new RemoteManagerProcessor(handler));
    shared_ptr<TServerTransport> serverTransport(new TServerSocket(port));
    shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());
    shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());

    TSimpleServer server(processor, serverTransport, transportFactory, protocolFactory);
    server.serve();
    return 0;
}