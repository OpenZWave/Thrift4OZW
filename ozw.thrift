//~ Thrift4OZW - An Apache Thrift wrapper for OpenZWave
//~ ----------------------------------------------------
//~ Copyright (c) 2011 Elias Karakoulakis <elias.karakoulakis@gmail.com>

//~ SOFTWARE NOTICE AND LICENSE

//~ Thrift4OZW is free software: you can redistribute it and/or modify
//~ it under the terms of the GNU Lesser General Public License as published
//~ by the Free Software Foundation, either version 3 of the License,
//~ or (at your option) any later version.

//~ Thrift4OZW is distributed in the hope that it will be useful,
//~ but WITHOUT ANY WARRANTY; without even the implied warranty of
//~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//~ GNU Lesser General Public License for more details.

//~ You should have received a copy of the GNU Lesser General Public License
//~ along with Thrift4OZW.  If not, see <http://www.gnu.org/licenses/>.

//~ for more information on the LGPL, see:
//~ http://en.wikipedia.org/wiki/GNU_Lesser_General_Public_License

namespace * OpenZWave
cpp_include "Manager.h"
cpp_include "ValueID.h"
cpp_include "Options.h"
cpp_include "Driver.h"

enum RemoteValueGenre {
	ValueGenre_Basic=0,
	ValueGenre_User=1,
	ValueGenre_Config=2,
	ValueGenre_System=3,
	ValueGenre_Count=4
}

enum RemoteValueType {
	ValueType_Bool=0,
	ValueType_Byte=1,
	ValueType_Decimal=2,
	ValueType_Int=3,
	ValueType_List=4,
	ValueType_Schedule=5,
	ValueType_Short=6,
	ValueType_String=7,
	ValueType_Button=8,
	ValueType_Max=8
}

enum DriverControllerCommand {
    ControllerCommand_None = 0,						/**< No command. */
    ControllerCommand_AddController,				/**< Add a new controller to the Z-Wave network.  The new controller will be a secondary. */
    ControllerCommand_AddDevice,					/**< Add a new device (but not a controller) to the Z-Wave network. */
    ControllerCommand_CreateNewPrimary,				/**< Add a new controller to the Z-Wave network.  The new controller will be the primary, and the current primary will become a secondary controller. */
    ControllerCommand_ReceiveConfiguration,			/**< Receive Z-Wave network configuration information from another controller. */
    ControllerCommand_RemoveController,				/**< Remove a controller from the Z-Wave network. */
    ControllerCommand_RemoveDevice,					/**< Remove a new device (but not a controller) from the Z-Wave network. */
    ControllerCommand_RemoveFailedNode,				/**< Move a node to the controller's failed nodes list. This command will only work if the node cannot respond. */
    ControllerCommand_HasNodeFailed,				/**< Check whether a node is in the controller's failed nodes list. */
    ControllerCommand_ReplaceFailedNode,			/**< Replace a non-responding node with another. The node must be in the controller's list of failed nodes for this command to succeed. */
    ControllerCommand_TransferPrimaryRole,			/**< Make a different controller the primary. */
    ControllerCommand_RequestNetworkUpdate,			/**< Request network information from the SUC/SIS. */
    ControllerCommand_RequestNodeNeighborUpdate,	/**< Get a node to rebuild its neighbour list.  This method also does ControllerCommand_RequestNodeNeighbors */
    ControllerCommand_AssignReturnRoute,			/**< Assign a network return routes to a device. */
    ControllerCommand_DeleteAllReturnRoutes			/**< Delete all return routes from a device. */
}
    
struct RemoteValueID {
			1:i32 _homeId,
			2:byte _nodeId,
			3:RemoteValueGenre _genre,
			4:byte _commandClassId,
			5:byte _instance,
			6:byte _valueIndex,
			7:RemoteValueType _type
}
//typedef i64 RemoteValueID

//~ struct RemoteValueID {
    //~ 1: i32 m_id;
    //~ 2: i32 m_id1;
    //~ 3: i32 m_homeId;
//~ }

struct GetSwitchPointReturnStruct {
    1:bool retval;
    2:byte o_hours;
    3:byte o_minutes;
    4:byte o_setback;
}

struct Bool_Bool {
    1:bool retval; // function succeeded?
    2:bool o_value; // value returned
}

struct Bool_UInt8 {
    1:bool retval; // function succeeded?
    2:byte o_value; // value returned
}    

struct Bool_Float {
    1:bool retval; // function succeeded?
    2:double o_value; // value returned    
}

struct Bool_Int {
    1:bool retval; // function succeeded?
    2:i32 o_value; // value returned    
}

struct Bool_Int16 {
    1:bool retval; // function succeeded?
    2:i16 o_value; // value returned    
}

struct Bool_String {
    1:bool retval; // function succeeded?
    2:string o_value; // value returned    
}

struct Bool_ListString {
    1:bool retval;
    2:list<string> o_value;
}

struct UInt32_ListByte {
    1:i32   retval;
    2:list<byte> _nodeNeighbors;
}

struct Bool_GetNodeClassInformation {
    1:bool retval;
    2:string _className;
    3:byte _classVersion;
}

struct GetAssociationsReturnStruct {
    1:i32 retval;
    2:list<byte> o_associations;
}

struct GetAllScenesReturnStruct {
    1:byte retval;
    2:list<byte> _sceneIds;
}

struct SceneGetValuesReturnStruct {
    1: i32 retval; 
    2: list<RemoteValueID> o_value;
}

/*-------------------------------------*/
service RemoteManager {
/*-------------------------------------*/
    
    //-----------------------------------------------------------------------------
	// Configuration
	//-----------------------------------------------------------------------------
	/** \name Configuration
	 *  For saving the Z-Wave network configuration so that the entire network does not need to be 
	 *  polled every time the application starts.
	 */
    
    //  void WriteConfig( uint32 const _homeId );
    void WriteConfig(1: i32 _homeId );
    
    //TODO:	Options* GetOptions()const{ return m_options; }
    //list<Options> GetOptions();

    //-----------------------------------------------------------------------------
	//	Drivers
	//-----------------------------------------------------------------------------
	/** \name Drivers
	 *  Methods for adding and removing drivers and obtaining basic controller information.
	 */
	
    //TODO: bool AddDriver( string const& _controllerPath, Driver::ControllerInterface const& _interface = Driver::ControllerInterface_Serial);
    //TODO: bool RemoveDriver( string const& _controllerPath );
    
    //uint8 GetControllerNodeId( uint32 const _homeId );
    byte GetControllerNodeId( 1:i32 _homeId );
    
    //bool IsPrimaryController( uint32 const _homeId );
    bool IsPrimaryController(1: i32 _homeId );
    
    //TODO    
    //bool IsStaticUpdateController( uint32 const _homeId );
    bool IsStaticUpdateController( 1:i32 _homeId );

		/**
		 * \brief Query if the controller is using the bridge controller library.
		 * A bridge controller is able to create virtual nodes that can be associated
		 * with other controllers to enable events to be passed on.
		 * \param _homeId The Home ID of the Z-Wave controller.
		 * \return true if it is a bridge controller, false if not.
		 */
		//bool IsBridgeController( uint32 const _homeId );
    bool IsBridgeController( 1:i32 _homeId );
    
		/**
		 * \brief Get the version of the Z-Wave API library used by a controller.
		 * \param _homeId The Home ID of the Z-Wave controller.
		 * \return a string containing the library version. For example, "Z-Wave 2.48".
		 */
		//string GetLibraryVersion( uint32 const _homeId );
    string GetLibraryVersion( 1:i32 _homeId );
    
		/**
		 * \brief Get a string containing the Z-Wave API library type used by a controller.
		 * The possible library types are:
		 * - Static Controller
		 * - Controller
		 * - Enhanced Slave
		 * - Slave            
		 * - Installer
		 * - Routing Slave
		 * - Bridge Controller
		 * - Device Under Test
		 * The controller should never return a slave library type.
		 * For a more efficient test of whether a controller is a Bridge Controller, use
		 * the IsBridgeController method.
		 * \param _homeId The Home ID of the Z-Wave controller.
		 * \return a string containing the library type.
		 * \see GetLibraryVersion, IsBridgeController
		 */
		//string GetLibraryTypeName( uint32 const _homeId );
    string GetLibraryTypeName( 1:i32 _homeId );

		/**
		 * \brief Get count of messages in the outgoing send queue.
		 * \param _homeId The Home ID of the Z-Wave controller.
		 * \return a integer message count
		 */
		//int32 GetSendQueueCount( uint32 const _homeId );
    i32 GetSendQueueCount( 1:i32 _homeId );

	//-----------------------------------------------------------------------------
	//	Polling Z-Wave devices
	//-----------------------------------------------------------------------------
	/** \name Polling Z-Wave devices
	 *  Methods for controlling the polling of Z-Wave devices.  Modern devices will not
	 *  require polling.  Some old devices need to be polled as the only way to detect
	 *  status changes.
	 */

		/**
		 * \brief Get the time period between polls of a node's state.
		 */
		//int32 GetPollInterval();
    i32 GetPollInterval();

		/**
		 * \brief Set the time period between polls of a node's state.
		 * Due to patent concerns, some devices do not report state changes automatically to the controller.
		 * These devices need to have their state polled at regular intervals.  The length of the interval
		 * is the same for all devices.  To even out the Z-Wave network traffic generated by polling, OpenZWave
		 * divides the polling interval by the number of devices that have polling enabled, and polls each
		 * in turn.  It is recommended that if possible, the interval should not be set shorter than the
		 * number of polled devices in seconds (so that the network does not have to cope with more than one
		 * poll per second).
		 * \param _seconds The length of the polling interval in seconds.
		 */
		//void SetPollInterval( int32 _seconds );
    void SetPollInterval( 1:i32 _seconds );

		/**
		 * \brief Enable the polling of a device's state.
		 * \param _valueId The ID of the value to start polling.
		 * \return True if polling was enabled.
		 */
		//bool EnablePoll( ValueID const _valueId );
    bool EnablePoll( 1:RemoteValueID _valueId );

		/**
		 * \brief Disable the polling of a device's state.
		 * \param _valueId The ID of the value to stop polling.
		 * \return True if polling was disabled.
		 */
		//bool DisablePoll( ValueID const _valueId );
    bool DisablePoll( 1:RemoteValueID _valueId );

		/**
		 * \brief Determine the polling of a device's state.
		 * \param _valueId The ID of the value to check polling.
		 * \return True if polling is active.
		 */
		//bool isPolled( ValueID const _valueId );
    bool isPolled( 1:RemoteValueID _valueId );
        
    //-----------------------------------------------------------------------------
    //	Node information
    //-----------------------------------------------------------------------------
    /** \name Node information
     *  Methods for accessing information on indivdual nodes.
     */
/**
		 * \brief Trigger the fetching of fixed data about a node.
		 * Causes the node's data to be obtained from the Z-Wave network in the same way as if it had just been added.
		 * This method would normally be called automatically by OpenZWave, but if you know that a node has been
		 * changed, calling this method will force a refresh of all of the data held by the library.  This can be especially 
		 * useful for devices that were asleep when the application was first run. This is the
		 * same as the query state starting from the beginning.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return True if the request was sent successfully.
		 */
		//bool RefreshNodeInfo( uint32 const _homeId, uint8 const _nodeId );
    bool RefreshNodeInfo( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Trigger the fetching of dynamic value data for a node.
		 * Causes the node's values to be requested from the Z-Wave network. This is the
		 * same as the query state starting from the associations state.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return True if the request was sent successfully.
		 */
		//bool RequestNodeState( uint32 const _homeId, uint8 const _nodeId );
    bool RequestNodeState( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Trigger the fetching of just the dynamic value data for a node.
		 * Causes the node's values to be requested from the Z-Wave network. This is the
		 * same as the query state starting from the dynamic state.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return True if the request was sent successfully.
		 */
		//bool RequestNodeDynamic( uint32 const _homeId, uint8 const _nodeId );
    bool RequestNodeDynamic( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get whether the node is a listening device that does not go to sleep
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return True if it is a listening node.
		 */
		//bool IsNodeListeningDevice( uint32 const _homeId, uint8 const _nodeId );
    bool IsNodeListeningDevice( 1:i32 _homeId, 2:byte _nodeId );
    
		/**
		 * \brief Get whether the node is a frequent listening device that goes to sleep but
		 * can be woken up by a beam. Useful to determine node and controller consistency.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return True if it is a frequent listening node.
		 */
		//bool IsNodeFrequentListeningDevice( uint32 const _homeId, uint8 const _nodeId );
	bool IsNodeFrequentListeningDevice( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get whether the node is a beam capable device.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return True if it is a frequent listening node.
		 */
		//bool IsNodeBeamingDevice( uint32 const _homeId, uint8 const _nodeId );
	bool IsNodeBeamingDevice( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get whether the node is a routing device that passes messages to other nodes
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return True if the node is a routing device
		 */
		//bool IsNodeRoutingDevice( uint32 const _homeId, uint8 const _nodeId );
    bool IsNodeRoutingDevice( 1:i32 _homeId, 2:byte _nodeId );

        /**
		 * \brief Get the security attribute for a node. True if node supports security features.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return true if security features implemented.
		 */
		//bool IsNodeSecurityDevice( uint32 const _homeId, uint8 const _nodeId );
	bool IsNodeSecurityDevice( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get the maximum baud rate of a node's communications
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return the baud rate in bits per second.
		 */
		//uint32 GetNodeMaxBaudRate( uint32 const _homeId, uint8 const _nodeId );
    i32 GetNodeMaxBaudRate( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get the version number of a node
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return the node's version number
		 */
		//uint8 GetNodeVersion( uint32 const _homeId, uint8 const _nodeId );
    byte GetNodeVersion( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get the security byte for a node.  Bit meanings are still to be determined.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return the node's security byte
		 */
		//uint8 GetNodeSecurity( uint32 const _homeId, uint8 const _nodeId );
	// REMOVED in OZW main trunk rev410
    //byte GetNodeSecurity( 1:i32 _homeId, 2:byte _nodeId );
    
		/**
		 * \brief Get the basic type of a node.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return the node's basic type.
		 */
		//uint8 GetNodeBasic( uint32 const _homeId, uint8 const _nodeId );
    byte GetNodeBasic( 1:i32 _homeId, 2:byte _nodeId );
		
		/**
		 * \brief Get the generic type of a node.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return the node's generic type.
		 */
		//uint8 GetNodeGeneric( uint32 const _homeId, uint8 const _nodeId );
    byte GetNodeGeneric( 1:i32 _homeId, 2:byte _nodeId );
		
		/**
		 * \brief Get the specific type of a node.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return the node's specific type.
		 */
		//uint8 GetNodeSpecific( uint32 const _homeId, uint8 const _nodeId );
    byte GetNodeSpecific( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get a human-readable label describing the node
		 * The label is taken from the Z-Wave specific, generic or basic type, depending on which of those values are specified by the node.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return A string containing the label text.
		 */
		//string GetNodeType( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeType( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get the bitmap of this node's neighbors
		 *
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \param _nodeNeighbors An array of 29 uint8s to hold the neighbor bitmap
		 */
		//uint32 GetNodeNeighbors( uint32 const _homeId, uint8 const _nodeId, uint8** _nodeNeighbors );
    UInt32_ListByte GetNodeNeighbors( 1:i32 _homeId, 2:byte _nodeId);

		/**
		 * \brief Get the manufacturer name of a device
		 * The manufacturer name would normally be handled by the Manufacturer Specific commmand class,
		 * taking the manufacturer ID reported by the device and using it to look up the name from the
		 * manufacturer_specific.xml file in the OpenZWave config folder.
		 * However, there are some devices that do not support the command class, so to enable the user
		 * to manually set the name, it is stored with the node data and accessed via this method rather
		 * than being reported via a command class Value object.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return A string containing the node's manufacturer name.
		 * \see SetNodeManufacturerName, GetNodeProductName, SetNodeProductName
		 */
		//string GetNodeManufacturerName( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeManufacturerName( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get the product name of a device
		 * The product name would normally be handled by the Manufacturer Specific commmand class,
		 * taking the product Type and ID reported by the device and using it to look up the name from the
		 * manufacturer_specific.xml file in the OpenZWave config folder.
		 * However, there are some devices that do not support the command class, so to enable the user
		 * to manually set the name, it is stored with the node data and accessed via this method rather
		 * than being reported via a command class Value object.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return A string containing the node's product name.
		 * \see SetNodeProductName, GetNodeManufacturerName, SetNodeManufacturerName
		 */
		//string GetNodeProductName( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeProductName( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get the name of a node
		 * The node name is a user-editable label for the node that would normally be handled by the
		 * Node Naming commmand class, but many devices do not support it.  So that a node can always
		 * be named, OpenZWave stores it with the node data, and provides access through this method
		 * and SetNodeName, rather than reporting it via a command class Value object.
		 * The maximum length of a node name is 16 characters.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return A string containing the node's name.
		 * \see SetNodeName, GetNodeLocation, SetNodeLocation
		 */
		//string GetNodeName( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeName( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get the location of a node
		 * The node location is a user-editable string that would normally be handled by the Node Naming
		 * commmand class, but many devices do not support it.  So that a node can always report its
		 * location, OpenZWave stores it with the node data, and provides access through this method
		 * and SetNodeLocation, rather than reporting it via a command class Value object.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return A string containing the node's location.
		 * \see SetNodeLocation, GetNodeName, SetNodeName
		 */
		//string GetNodeLocation( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeLocation( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get the manufacturer ID of a device
		 * The manufacturer ID is a four digit hex code and would normally be handled by the Manufacturer
		 * Specific commmand class, but not all devices support it.  Although the value reported by this
		 * method will be an empty string if the command class is not supported and cannot be set by the 
		 * user, the manufacturer ID is still stored with the node data (rather than being reported via a
		 * command class Value object) to retain a consistent approach with the other manufacturer specific data.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return A string containing the node's manufacturer ID, or an empty string if the manufactuer
		 * specific command class is not supported by the device.
		 * \see GetNodeProductType, GetNodeProductId, GetNodeManufacturerName, GetNodeProductName
		 */
		//string GetNodeManufacturerId( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeManufacturerId( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get the product type of a device
		 * The product type is a four digit hex code and would normally be handled by the Manufacturer Specific
		 * commmand class, but not all devices support it.  Although the value reported by this method will
		 * be an empty string if the command class is not supported and cannot be set by the user, the product
		 * type is still stored with the node data (rather than being reported via a command class Value object)
		 * to retain a consistent approach with the other manufacturer specific data.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return A string containing the node's product type, or an empty string if the manufactuer
		 * specific command class is not supported by the device.
		 * \see GetNodeManufacturerId, GetNodeProductId, GetNodeManufacturerName, GetNodeProductName
		 */
		//string GetNodeProductType( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeProductType( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get the product ID of a device
		 * The product ID is a four digit hex code and would normally be handled by the Manufacturer Specific
		 * commmand class, but not all devices support it.  Although the value reported by this method will
		 * be an empty string if the command class is not supported and cannot be set by the user, the product
		 * ID is still stored with the node data (rather than being reported via a command class Value object)
		 * to retain a consistent approach with the other manufacturer specific data.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return A string containing the node's product ID, or an empty string if the manufactuer
		 * specific command class is not supported by the device.
		 * \see GetNodeManufacturerId, GetNodeProductType, GetNodeManufacturerName, GetNodeProductName
		 */
		//string GetNodeProductId( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeProductId( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Set the manufacturer name of a device
		 * The manufacturer name would normally be handled by the Manufacturer Specific commmand class,
		 * taking the manufacturer ID reported by the device and using it to look up the name from the
		 * manufacturer_specific.xml file in the OpenZWave config folder.
		 * However, there are some devices that do not support the command class, so to enable the user
		 * to manually set the name, it is stored with the node data and accessed via this method rather
		 * than being reported via a command class Value object.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \param _manufacturerName	A string containing the node's manufacturer name.
		 * \see GetNodeManufacturerName, GetNodeProductName, SetNodeProductName
		 */
		//void SetNodeManufacturerName( uint32 const _homeId, uint8 const _nodeId, string const& _manufacturerName );
    void SetNodeManufacturerName( 1:i32 _homeId, 2:byte _nodeId, 3:string _manufacturerName );
		
		/**
		 * \brief Set the product name of a device
		 * The product name would normally be handled by the Manufacturer Specific commmand class,
		 * taking the product Type and ID reported by the device and using it to look up the name from the
		 * manufacturer_specific.xml file in the OpenZWave config folder.
		 * However, there are some devices that do not support the command class, so to enable the user
		 * to manually set the name, it is stored with the node data and accessed via this method rather
		 * than being reported via a command class Value object.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \param _productName A string containing the node's product name.
		 * \see GetNodeProductName, GetNodeManufacturerName, SetNodeManufacturerName
		 */
		//void SetNodeProductName( uint32 const _homeId, uint8 const _nodeId, string const& _productName );
    void SetNodeProductName( 1:i32 _homeId, 2:byte _nodeId, 3:string _productName );

		/**
		 * \brief Set the name of a node
		 * The node name is a user-editable label for the node that would normally be handled by the
		 * Node Naming commmand class, but many devices do not support it.  So that a node can always
		 * be named, OpenZWave stores it with the node data, and provides access through this method
		 * and GetNodeName, rather than reporting it via a command class Value object.
		 * If the device does support the Node Naming command class, the new name will be sent to the node.
		 * The maximum length of a node name is 16 characters.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \param _nodeName A string containing the node's name.
		 * \see GetNodeName, GetNodeLocation, SetNodeLocation
		 */
		//void SetNodeName( uint32 const _homeId, uint8 const _nodeId, string const& _nodeName );
    void SetNodeName( 1:i32 _homeId, 2:byte _nodeId, 3:string _nodeName );

		/**
		 * \brief Set the location of a node
		 * The node location is a user-editable string that would normally be handled by the Node Naming
		 * commmand class, but many devices do not support it.  So that a node can always report its
		 * location, OpenZWave stores it with the node data, and provides access through this method
		 * and GetNodeLocation, rather than reporting it via a command class Value object.
		 * If the device does support the Node Naming command class, the new location will be sent to the node.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \param _location A string containing the node's location.
		 * \see GetNodeLocation, GetNodeName, SetNodeName
		 */
		//void SetNodeLocation( uint32 const _homeId, uint8 const _nodeId, string const& _location );
    void SetNodeLocation( 1:i32 _homeId, 2:byte _nodeId, 3:string _location );

		/**
		 * \brief Turns a node on
		 * This is a helper method to simplify basic control of a node.  It is the equivalent of
		 * changing the level reported by the node's Basic command class to 255, and will generate a 
		 * ValueChanged notification from that class.  This command will turn on the device at its
		 * last known level, if supported by the device, otherwise it will turn	it on at 100%.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to be changed.
		 * \see SetNodeOff, SetNodeLevel
		 */
		//void SetNodeOn( uint32 const _homeId, uint8 const _nodeId );
    void SetNodeOn( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Turns a node off
		 * This is a helper method to simplify basic control of a node.  It is the equivalent of
		 * changing the level reported by the node's Basic command class to zero, and will generate
		 * a ValueChanged notification from that class.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to be changed.
		 * \see SetNodeOn, SetNodeLevel
		 */
		//void SetNodeOff( uint32 const _homeId, uint8 const _nodeId );
    void SetNodeOff( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Sets the basic level of a node
		 * This is a helper method to simplify basic control of a node.  It is the equivalent of
		 * changing the value reported by the node's Basic command class and will generate a 
		 * ValueChanged notification from that class.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to be changed.
		 * \param _level The level to set the node.  Valid values are 0-99 and 255.  Zero is off and
		 * 99 is fully on.  255 will turn on the device at its last known level (if supported).
		 * \see SetNodeOn, SetNodeOff
		 */
		//void SetNodeLevel( uint32 const _homeId, uint8 const _nodeId, uint8 const _level );
    void SetNodeLevel( 1:i32 _homeId, 2:byte _nodeId, 3:byte _level );

		/**
		 * \brief Get whether the node information has been received
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \return True if the node information has been received yet
		 */
		//bool IsNodeInfoReceived( uint32 const _homeId, uint8 const _nodeId );
    bool IsNodeInfoReceived( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Get whether the node has the defined class available or not
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to query.
		 * \param _commandClassId Id of the class to test for
		 * \return True if the node does have the class instantiated, will return name & version
		 */
        //bool GetNodeClassInformation( uint32 const _homeId, uint8 const _nodeId, uint8 const _commandClassId, string *_className = NULL, uint8 *_classVersion = NULL);
    Bool_GetNodeClassInformation GetNodeClassInformation( 1:i32 _homeId, 2:byte _nodeId, 3:byte _commandClassId);
        
	//-----------------------------------------------------------------------------
	// Values
	//-----------------------------------------------------------------------------
	/** \name Values
	 *  Methods for accessing device values.  All the methods require a ValueID, which will have been provided
	 *  in the ValueAdded Notification callback when the the value was first discovered by OpenZWave.
	 */
     		/**
		 * \brief Gets the user-friendly label for the value.
		 * \param _id The unique identifier of the value.
		 * \return The value label.
		 * \see ValueID
		 */
		//string GetValueLabel( ValueID const& _id );
    string GetValueLabel( 1:RemoteValueID _id );

		/**
		 * \brief Sets the user-friendly label for the value.
		 * \param _id The unique identifier of the value.
		 * \param _value The new value of the label.
		 * \see ValueID
		 */
		//void SetValueLabel( ValueID const& _id, string const& _value );
    void SetValueLabel( 1:RemoteValueID _id, 2:string _value );
    
		/**
		 * \brief Gets the units that the value is measured in.
		 * \param _id The unique identifier of the value.
		 * \return The value units.
		 * \see ValueID
		 */
		//string GetValueUnits( ValueID const& _id );
    string GetValueUnits( 1:RemoteValueID _id );
		
		/**
		 * \brief Sets the units that the value is measured in.
		 * \param _id The unique identifier of the value.
		 * \param _value The new value of the units.
		 * \see ValueID
		 */
		//void SetValueUnits( ValueID const& _id, string const& _value );
    void SetValueUnits( 1:RemoteValueID _id, 2:string _value );
		
		/**
		 * \brief Gets a help string describing the value's purpose and usage.
		 * \param _id The unique identifier of the value.
		 * \return The value help text.
		 * \see ValueID
		 */
		//string GetValueHelp( ValueID const& _id );
    string GetValueHelp( 1:RemoteValueID _id );

		/**
		 * \brief Sets a help string describing the value's purpose and usage.
		 * \param _id The unique identifier of the value.
		 * \param _value The new value of the help text.
		 * \see ValueID
		 */
		//void SetValueHelp( ValueID const& _id, string const& _value );
    void SetValueHelp( 1:RemoteValueID _id, 2:string _value );

		/**
		 * \brief Gets the minimum that this value may contain.
		 * \param _id The unique identifier of the value.
		 * \return The value minimum.
		 * \see ValueID
		 */
		//int32 GetValueMin( ValueID const& _id );
    i32 GetValueMin( 1:RemoteValueID _id );

		/**
		 * \brief Gets the maximum that this value may contain.
		 * \param _id The unique identifier of the value.
		 * \return The value maximum.
		 * \see ValueID
		 */
		//int32 GetValueMax( ValueID const& _id );
    i32 GetValueMax( 1:RemoteValueID _id );

		/**
		 * \brief Test whether the value is read-only.
		 * \param _id The unique identifier of the value.
		 * \return true if the value cannot be changed by the user.	
		 * \see ValueID
		 */
		//bool IsValueReadOnly( ValueID const& _id );
    bool IsValueReadOnly( 1:RemoteValueID _id );

		/**
		 * \brief Test whether the value is write-only.
		 * \param _id The unique identifier of the value.
		 * \return true if the value can only be written to and not read.	
		 * \see ValueID
		 */
		//bool IsValueWriteOnly( ValueID const& _id );
    bool IsValueWriteOnly( 1:RemoteValueID _id );
        
		/**
		 * \brief Test whether the value has been set.
		 * \param _id The unique identifier of the value.
		 * \return true if the value has actually been set by a status message from the device, rather than simply being the default.	
		 * \see ValueID
		 */
		//bool IsValueSet( ValueID const& _id );
    bool IsValueSet( 1:RemoteValueID _id );

		/**
		 * \brief Gets a value as a bool.
		 * \param _id The unique identifier of the value.
		 * \param o_value Pointer to a bool that will be filled with the value.
		 * \return true if the value was obtained.  Returns false if the value is not a ValueID::ValueType_Bool. The type can be tested with a call to ValueID::GetType.
		 * \see ValueID::GetType, GetValueAsByte, GetValueAsFloat, GetValueAsInt, GetValueAsShort, GetValueAsString, GetValueListSelection, GetValueListItems 
		 */
		//bool GetValueAsBool( ValueID const& _id, bool* o_value );
    Bool_Bool GetValueAsBool( 1:RemoteValueID _id);

		/**
		 * \brief Gets a value as an 8-bit unsigned integer.
		 * \param _id The unique identifier of the value.
		 * \param o_value Pointer to a uint8 that will be filled with the value.
		 * \return true if the value was obtained.  Returns false if the value is not a ValueID::ValueType_Byte. The type can be tested with a call to ValueID::GetType
		 * \see ValueID::GetType, GetValueAsBool, GetValueAsFloat, GetValueAsInt, GetValueAsShort, GetValueAsString, GetValueListSelection, GetValueListItems 
		 */
		//bool GetValueAsByte( ValueID const& _id, uint8* o_value );
    Bool_UInt8 GetValueAsByte( 1:RemoteValueID _id );

		/**
		 * \brief Gets a value as a float.
		 * \param _id The unique identifier of the value.
		 * \param o_value Pointer to a float that will be filled with the value.
		 * \return true if the value was obtained.  Returns false if the value is not a ValueID::ValueType_Decimal. The type can be tested with a call to ValueID::GetType
		 * \see ValueID::GetType, GetValueAsBool, GetValueAsByte, GetValueAsInt, GetValueAsShort, GetValueAsString, GetValueListSelection, GetValueListItems 
		 */
		//bool GetValueAsFloat( ValueID const& _id, float* o_value );
    Bool_Float GetValueAsFloat( 1:RemoteValueID _id );

		/**
		 * \brief Gets a value as a 32-bit signed integer.
		 * \param _id The unique identifier of the value.
		 * \param o_value Pointer to an int32 that will be filled with the value.
		 * \return true if the value was obtained.  Returns false if the value is not a ValueID::ValueType_Int. The type can be tested with a call to ValueID::GetType
		 * \see ValueID::GetType, GetValueAsBool, GetValueAsByte, GetValueAsFloat, GetValueAsShort, GetValueAsString, GetValueListSelection, GetValueListItems 
		 */
		//bool GetValueAsInt( ValueID const& _id, int32* o_value );
    Bool_Int GetValueAsInt( 1:RemoteValueID _id );

		/**
		 * \brief Gets a value as a 16-bit signed integer.
		 * \param _id The unique identifier of the value.
		 * \param o_value Pointer to an int16 that will be filled with the value.
		 * \return true if the value was obtained.  Returns false if the value is not a ValueID::ValueType_Short. The type can be tested with a call to ValueID::GetType.
		 * \see ValueID::GetType, GetValueAsBool, GetValueAsByte, GetValueAsFloat, GetValueAsInt, GetValueAsString, GetValueListSelection, GetValueListItems. 
		 */
		//bool GetValueAsShort( ValueID const& _id, int16* o_value );
    Bool_Int16 GetValueAsShort( 1:RemoteValueID _id );
		
		/**
		 * \brief Gets a value as a string.
		 * Creates a string representation of a value, regardless of type.
		 * \param _id The unique identifier of the value.
		 * \param o_value Pointer to a string that will be filled with the value.
		 * \return true if the value was obtained.</returns>
		 * \see ValueID::GetType, GetValueAsBool, GetValueAsByte, GetValueAsFloat, GetValueAsInt, GetValueAsShort, GetValueListSelection, GetValueListItems. 
		 */
		//bool GetValueAsString( ValueID const& _id, string* o_value );
    Bool_String GetValueAsString( 1:RemoteValueID _id );
		
		/**
		 * \brief Gets the selected item from a list (as a string).
		 * \param _id The unique identifier of the value.
		 * \param o_value Pointer to a string that will be filled with the selected item.
		 * \return True if the value was obtained.  Returns false if the value is not a ValueID::ValueType_List. The type can be tested with a call to ValueID::GetType.
		 * \see ValueID::GetType, GetValueAsBool, GetValueAsByte, GetValueAsFloat, GetValueAsInt, GetValueAsShort, GetValueAsString, GetValueListItems. 
		 */
		//bool GetValueListSelection( ValueID const& _id, string* o_value );
    // ekarak: thrift does not support function overloading
    Bool_String GetValueListSelection_String( 1:RemoteValueID _id );

		/**
		 * \brief Gets the selected item from a list (as an integer).
		 * \param _id The unique identifier of the value.
		 * \param o_value Pointer to an integer that will be filled with the selected item.
		 * \return True if the value was obtained.  Returns false if the value is not a ValueID::ValueType_List. The type can be tested with a call to ValueID::GetType.
		 * \see ValueID::GetType, GetValueAsBool, GetValueAsByte, GetValueAsFloat, GetValueAsInt, GetValueAsShort, GetValueAsString, GetValueListItems. 
		 */
		//bool GetValueListSelection( ValueID const& _id, int32* o_value );
    // ekarak: overloading by name mangling
    Bool_Int GetValueListSelection_Int32( 1:RemoteValueID _id );

		/**
		 * \brief Gets the list of items from a list value.
		 * \param _id The unique identifier of the value.
		 * \param o_value Pointer to a vector of strings that will be filled with list items. The vector will be cleared before the items are added.
		 * \return true if the list items were obtained.  Returns false if the value is not a ValueID::ValueType_List. The type can be tested with a call to ValueID::GetType.
		 * \see ValueID::GetType, GetValueAsBool, GetValueAsByte, GetValueAsFloat, GetValueAsInt, GetValueAsShort, GetValueAsString, GetValueListSelection. 
		 */
		//bool GetValueListItems( ValueID const& _id, vector<string>* o_value );
    // ekarak: client must ensure value's type is ValueType_List
    Bool_ListString GetValueListItems( 1:RemoteValueID _id );

		/**
		 * \brief Gets a float value's precision.
		 * \param _id The unique identifier of the value.
		 * \param o_value Pointer to a uint8 that will be filled with the precision value.
		 * \return true if the value was obtained.  Returns false if the value is not a ValueID::ValueType_Decimal. The type can be tested with a call to ValueID::GetType
		 * \see ValueID::GetType, GetValueAsBool, GetValueAsByte, GetValueAsInt, GetValueAsShort, GetValueAsString, GetValueListSelection, GetValueListItems 
		 */
		//bool GetValueFloatPrecision( ValueID const& _id, uint8* o_value );
    Bool_UInt8 GetValueFloatPrecision( 1:RemoteValueID _id );

		/**
		 * \brief Sets the state of a bool.
		 * Due to the possibility of a device being asleep, the command is assumed to suceeed, and the value
		 * held by the node is updated directly.  This will be reverted by a future status message from the device
		 * if the Z-Wave message actually failed to get through.  Notification callbacks will be sent in both cases.
		 * \param _id The unique identifier of the bool value.
		 * \param _value The new value of the bool.
		 * \return true if the value was set.  Returns false if the value is not a ValueID::ValueType_Bool. The type can be tested with a call to ValueID::GetType.
		 */
		//bool SetValue( ValueID const& _id, bool const _value );
    // ekarak: client must ensure value's type is ValueType_Bool
    bool SetValue_Bool( 1:RemoteValueID _id, 2:bool _value );

		/**
		 * \brief Sets the value of a byte.
		 * Due to the possibility of a device being asleep, the command is assumed to suceeed, and the value
		 * held by the node is updated directly.  This will be reverted by a future status message from the device
		 * if the Z-Wave message actually failed to get through.  Notification callbacks will be sent in both cases.
		 * \param _id The unique identifier of the byte value.
		 * \param _value The new value of the byte.
		 * \return true if the value was set.  Returns false if the value is not a ValueID::ValueType_Byte. The type can be tested with a call to ValueID::GetType.
		 */
		//bool SetValue( ValueID const& _id, uint8 const _value );
    // ekarak:  client must ensure value's type
    bool SetValue_UInt8( 1:RemoteValueID _id, 2:byte _value );

		/**
		 * \brief Sets the value of a decimal.
		 * It is usually better to handle decimal values using strings rather than floats, to avoid floating point accuracy issues.
		 * Due to the possibility of a device being asleep, the command is assumed to succeed, and the value
		 * held by the node is updated directly.  This will be reverted by a future status message from the device
		 * if the Z-Wave message actually failed to get through.  Notification callbacks will be sent in both cases.
		 * \param _id The unique identifier of the decimal value.
		 * \param _value The new value of the decimal.
		 * \return true if the value was set.  Returns false if the value is not a ValueID::ValueType_Decimal. The type can be tested with a call to ValueID::GetType.
		 */
		//bool SetValue( ValueID const& _id, float const _value );
    // ekarak:  client must ensure value's type
    bool SetValue_Float( 1:RemoteValueID _id, 2:double _value );
		
		/**
		 * \brief Sets the value of a 32-bit signed integer.
		 * Due to the possibility of a device being asleep, the command is assumed to suceeed, and the value
		 * held by the node is updated directly.  This will be reverted by a future status message from the device
		 * if the Z-Wave message actually failed to get through.  Notification callbacks will be sent in both cases.
		 * \param _id The unique identifier of the integer value.
		 * \param _value The new value of the integer.
		 * \return true if the value was set.  Returns false if the value is not a ValueID::ValueType_Int. The type can be tested with a call to ValueID::GetType.
		 */
		//bool SetValue( ValueID const& _id, int32 const _value );
    // ekarak: client must ensure value's type
    bool SetValue_Int32( 1:RemoteValueID _id, 2:i32 _value );

		/**
		 * \brief Sets the value of a 16-bit signed integer.
		 * Due to the possibility of a device being asleep, the command is assumed to suceeed, and the value
		 * held by the node is updated directly.  This will be reverted by a future status message from the device
		 * if the Z-Wave message actually failed to get through.  Notification callbacks will be sent in both cases.
		 * \param _id The unique identifier of the integer value.
		 * \param _value The new value of the integer.
		 * \return true if the value was set.  Returns false if the value is not a ValueID::ValueType_Short. The type can be tested with a call to ValueID::GetType.
		 */
		//bool SetValue( ValueID const& _id, int16 const _value );
    // ekarak:  client must ensure value's type
    bool SetValue_Int16( 1:RemoteValueID _id, 2:i16 _value );

		/**
		 * \brief Sets the value from a string, regardless of type.
		 * Due to the possibility of a device being asleep, the command is assumed to suceeed, and the value
		 * held by the node is updated directly.  This will be reverted by a future status message from the device
		 * if the Z-Wave message actually failed to get through.  Notification callbacks will be sent in both cases.
		 * \param _id The unique identifier of the integer value.
		 * \param _value The new value of the string.
		 * \return true if the value was set.  Returns false if the value could not be parsed into the correct type for the value.
		 */
		//bool SetValue( ValueID const& _id, string const& _value );
    // ekarak:  client must ensure value's type
    bool SetValue_String( 1:RemoteValueID _id, 2:string _value );
    
		/**
		 * \brief Sets the selected item in a list.
		 * Due to the possibility of a device being asleep, the command is assumed to suceeed, and the value
		 * held by the node is updated directly.  This will be reverted by a future status message from the device
		 * if the Z-Wave message actually failed to get through.  Notification callbacks will be sent in both cases.
		 * \param _id The unique identifier of the list value.
		 * \param _selectedItem A string matching the new selected item in the list.
		 * \return true if the value was set.  Returns false if the selection is not in the list, or if the value is not a ValueID::ValueType_List.
		 * The type can be tested with a call to ValueID::GetType
		 */
		//bool SetValueListSelection( ValueID const& _id, string const& _selectedItem );
    bool SetValueListSelection( 1:RemoteValueID _id, 2:string _selectedItem );

		/**
		 * \brief Starts an activity in a device.
		 * Since buttons are write-only values that do not report a state, no notification callbacks are sent.
		 * \param _id The unique identifier of the integer value.
		 * \return true if the activity was started.  Returns false if the value is not a ValueID::ValueType_Button. The type can be tested with a call to ValueID::GetType.
		 */
		//bool PressButton( ValueID const& _id );
    bool PressButton( 1:RemoteValueID _id );

		/**
		 * \brief Stops an activity in a device.
		 * Since buttons are write-only values that do not report a state, no notification callbacks are sent.
		 * \param _id The unique identifier of the integer value.
		 * \return true if the activity was stopped.  Returns false if the value is not a ValueID::ValueType_Button. The type can be tested with a call to ValueID::GetType.
		 */
		//bool ReleaseButton( ValueID const& _id );
    bool ReleaseButton( 1:RemoteValueID _id );


	//-----------------------------------------------------------------------------
	// Climate Control Schedules
	//-----------------------------------------------------------------------------
	/** \name Climate Control Schedules
	 *  Methods for accessing schedule values.  All the methods require a ValueID, which will have been provided
	 *  in the ValueAdded Notification callback when the the value was first discovered by OpenZWave.
	 *  <p>The ValueType_Schedule is a specialized Value used to simplify access to the switch point schedule
	 *  information held by a setback thermostat that supports the Climate Control Schedule command class.
	 *  Each schedule contains up to nine switch points for a single day, consisting of a time in
	 *  hours and minutes (24 hour clock) and a setback in tenths of a degree Celsius.  The setback value can
	 *  range from -128 (-12.8C) to 120 (12.0C).  There are two special setback values - 121 is used to set
	 *  Frost Protection mode, and 122 is used to set Energy Saving mode.
	 *  <p>The switch point methods only modify OpenZWave's copy of the schedule information.  Once all changes
	 *  have been made, they are sent to the device by calling SetSchedule.
	 */

		/**
		 * \brief Get the number of switch points defined in a schedule.
		 * \param _id The unique identifier of the schedule value.
		 * \return the number of switch points defined in this schedule.  Returns zero if the value is not a ValueID::ValueType_Schedule. The type can be tested with a call to ValueID::GetType.
		 */
		//uint8 GetNumSwitchPoints( ValueID const& _id );
    byte GetNumSwitchPoints( 1:RemoteValueID _id );

		/**
		 * \brief Set a switch point in the schedule.
		 * Inserts a new switch point into the schedule, unless a switch point already exists at the specified
		 * time in which case that switch point is updated with the new setback value instead.
		 * A maximum of nine switch points can be set in the schedule.
		 * \param _id The unique identifier of the schedule value.
		 * \param _hours The hours part of the time when the switch point will trigger.  The time is set using
		 * the 24-hour clock, so this value must be between 0 and 23.
		 * \param _minutes The minutes part of the time when the switch point will trigger.  This value must be
		 * between 0 and 59.
		 * \param _setback The setback in tenths of a degree Celsius.  The setback value can range from -128 (-12.8C)
		 * to 120 (12.0C).  There are two special setback values - 121 is used to set Frost Protection mode, and
		 * 122 is used to set Energy Saving mode.
		 * \return true if successful.  Returns false if the value is not a ValueID::ValueType_Schedule. The type can be tested with a call to ValueID::GetType.
		 * \see GetNumSwitchPoints, RemoveSwitchPoint, ClearSwitchPoints
		 */
		//bool SetSwitchPoint( ValueID const& _id, uint8 const _hours, uint8 const _minutes, int8 const _setback );
    bool SetSwitchPoint( 1:RemoteValueID _id, 2:byte _hours, 3:byte _minutes, 4:byte _setback );

		/**
		 * \brief Remove a switch point from the schedule.
		 * Removes the switch point at the specified time from the schedule.
		 * \param _id The unique identifier of the schedule value.
		 * \param _hours The hours part of the time when the switch point will trigger.  The time is set using
		 * the 24-hour clock, so this value must be between 0 and 23.
		 * \param _minutes The minutes part of the time when the switch point will trigger.  This value must be
		 * between 0 and 59.
		 * \return true if successful.  Returns false if the value is not a ValueID::ValueType_Schedule or if there 
		 * is not switch point with the specified time values. The type can be tested with a call to ValueID::GetType.
		 * \see GetNumSwitchPoints, SetSwitchPoint, ClearSwitchPoints
		 */
		//bool RemoveSwitchPoint( ValueID const& _id, uint8 const _hours, uint8 const _minutes );
    bool RemoveSwitchPoint( 1:RemoteValueID _id, 2:byte _hours, 3:byte _minutes );

		/**
		 * \brief Clears all switch points from the schedule.
		 * \param _id The unique identifier of the schedule value.
		 * \see GetNumSwitchPoints, SetSwitchPoint, RemoveSwitchPoint
		 */
		//void ClearSwitchPoints( ValueID const& _id );
    void ClearSwitchPoints( 1:RemoteValueID _id );
		
		/**
		 * \brief Gets switch point data from the schedule.
		 * Retrieves the time and setback values from a switch point in the schedule.
		 * \param _id The unique identifier of the schedule value.
		 * \param _idx The index of the switch point, between zero and one less than the value
		 * returned by GetNumSwitchPoints.
		 * \param o_hours a pointer to a uint8 that will be filled with the hours part of the switch point data.
		 * \param o_minutes a pointer to a uint8 that will be filled with the minutes part of the switch point data.
		 * \param o_setback a pointer to an int8 that will be filled with the setback value.  This can range from -128
		 * (-12.8C)to 120 (12.0C).  There are two special setback values - 121 is used to set Frost Protection mode, and
		 * 122 is used to set Energy Saving mode.
		 * \return true if successful.  Returns false if the value is not a ValueID::ValueType_Schedule. The type can be tested with a call to ValueID::GetType.
		 * \see GetNumSwitchPoints
		 */
		//bool GetSwitchPoint( ValueID const& _id, uint8 const _idx, uint8* o_hours, uint8* o_minutes, int8* o_setback );
    GetSwitchPointReturnStruct GetSwitchPoint( 1:RemoteValueID _id, 2:byte _idx);


	//-----------------------------------------------------------------------------
	// SwitchAll
	//-----------------------------------------------------------------------------
	/** \name SwitchAll
	 *  Methods for switching all devices on or off together.  The devices must support
	 *	the SwitchAll command class.  The command is first broadcast to all nodes, and
	 *	then followed up with individual commands to each node (because broadcasts are
	 *	not routed, the message might not otherwise reach all the nodes).
	 */

		/**
		 * \brief Switch all devices on.
		 * All devices that support the SwitchAll command class will be turned on.
		 */
		void SwitchAllOn( 1:i32 _homeId );

		/**
		 * \brief Switch all devices off.
		 * All devices that support the SwitchAll command class will be turned off.
		 */
		void SwitchAllOff( 1:i32 _homeId );



	//-----------------------------------------------------------------------------
	// Configuration Parameters
	//-----------------------------------------------------------------------------
	/** \name Configuration Parameters
	 *  Methods for accessing device configuration parameters.
	 *  Configuration parameters are values that are managed by the Configuration command class.
	 *	The values are device-specific and are not reported by the devices. Information on parameters
	 *  is provided only in the device user manual.
	 *  <p>An ongoing task for the OpenZWave project is to create XML files describing the available
	 *  parameters for every Z-Wave.  See the config folder in the project source code for examples.
	 */

        /**
		 * \brief Set the value of a configurable parameter in a device.
		 * Some devices have various parameters that can be configured to control the device behaviour.
		 * These are not reported by the device over the Z-Wave network, but can usually be found in
		 * the device's user manual.
		 * This method returns immediately, without waiting for confirmation from the device that the
		 * change has been made.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to configure.
		 * \param _param The index of the parameter.
		 * \param _value The value to which the parameter should be set.
		 * \param _size Is an optional number of bytes to be sent for the paramter _value. Defaults to 2.
		 * \return true if the a message setting the value was sent to the device.
		 * \see RequestConfigParam
		 */
		//bool SetConfigParam( uint32 const _homeId, uint8 const _nodeId, uint8 const _param, int32 _value, uint8 const _size = 2 );
    bool SetConfigParam( 1:i32 _homeId, 2:byte _nodeId, 3:byte _param, 4:i32 _value, 5:byte _size = 2 );

		/**
		 * \brief Request the value of a configurable parameter from a device.
		 * Some devices have various parameters that can be configured to control the device behaviour.
		 * These are not reported by the device over the Z-Wave network, but can usually be found in
		 * the device's user manual.
		 * This method requests the value of a parameter from the device, and then returns immediately, 
		 * without waiting for a response.  If the parameter index is valid for this device, and the 
		 * device is awake, the value will eventually be reported via a ValueChanged notification callback.
		 * The ValueID reported in the callback will have an index set the same as _param and a command class
		 * set to the same value as returned by a call to Configuration::StaticGetCommandClassId. 
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to configure.
		 * \param _param The index of the parameter.
		 * \see SetConfigParam, ValueID, Notification
		 */
		//void RequestConfigParam( uint32 const _homeId, uint8 const _nodeId, uint8 const _param );
    void RequestConfigParam( 1:i32 _homeId, 2:byte _nodeId, 3:byte _param );

		/**
		 * \brief Request the values of all known configurable parameters from a device.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node to configure.
		 * \see SetConfigParam, ValueID, Notification
		 */
		//void RequestAllConfigParams( uint32 const _homeId, uint8 const _nodeId );
    void RequestAllConfigParams( 1:i32 _homeId, 2:byte _nodeId );

	//-----------------------------------------------------------------------------
	// Groups (wrappers for the Node methods)
	//-----------------------------------------------------------------------------
	/** \name Groups
	 *  Methods for accessing device association groups.
	 */
	
		/**
		 * \brief Gets the number of association groups reported by this node
		 * In Z-Wave, groups are numbered starting from one.  For example, if a call to GetNumGroups returns 4, the _groupIdx 
		 * value to use in calls to GetAssociations, AddAssociation and RemoveAssociation will be a number between 1 and 4.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node whose groups we are interested in.
		 * \return The number of groups.
		 * \see GetAssociations, GetMaxAssociations, AddAssociation, RemoveAssociation
		 */
		//uint8 GetNumGroups( uint32 const _homeId, uint8 const _nodeId );
    byte GetNumGroups( 1:i32 _homeId, 2:byte _nodeId );

		/**
		 * \brief Gets the associations for a group.
		 * Makes a copy of the list of associated nodes in the group, and returns it in an array of uint8's.
		 * The caller is responsible for freeing the array memory with a call to delete [].
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node whose associations we are interested in.
		 * \param _groupIdx One-based index of the group (because Z-Wave product manuals use one-based group numbering).
		 * \param o_associations If the number of associations returned is greater than zero, o_associations will be set to point to an array containing the IDs of the associated nodes.
		 * \return The number of nodes in the associations array.  If zero, the array will point to NULL, and does not need to be deleted.
		 * \see GetNumGroups, AddAssociation, RemoveAssociation, GetMaxAssociations
		 */
		//uint32 GetAssociations( uint32 const _homeId, uint8 const _nodeId, uint8 const _groupIdx, uint8** o_associations );
    // ekarak: return list of associations instead
    GetAssociationsReturnStruct GetAssociations( 1:i32 _homeId, 2:byte _nodeId, 3:byte _groupIdx);

		/**
		 * \brief Gets the maximum number of associations for a group.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node whose associations we are interested in.
		 * \param _groupIdx one-based index of the group (because Z-Wave product manuals use one-based group numbering).
		 * \return The maximum number of nodes that can be associated into the group.
		 * \see GetNumGroups, AddAssociation, RemoveAssociation, GetAssociations
		 */
		//uint8 GetMaxAssociations( uint32 const _homeId, uint8 const _nodeId, uint8 const _groupIdx );
    byte GetMaxAssociations( 1:i32 _homeId, 2:byte _nodeId, 3:byte _groupIdx );

		/**
		 * \brief Returns a label for the particular group of a node.
		 * This label is populated by the device specific configuration files.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node whose associations are to be changed.
		 * \param _groupIdx One-based index of the group (because Z-Wave product manuals use one-based group numbering).
		 * \see GetNumGroups, GetAssociations, GetMaxAssociations, AddAssociation
		 */
		//string GetGroupLabel( uint32 const _homeId, uint8 const _nodeId, uint8 const _groupIdx );
    string GetGroupLabel( 1:i32 _homeId, 2:byte _nodeId, 3:byte _groupIdx );

		/**
		 * \brief Adds a node to an association group.
		 * Due to the possibility of a device being asleep, the command is assumed to suceeed, and the association data
		 * held in this class is updated directly.  This will be reverted by a future Association message from the device
		 * if the Z-Wave message actually failed to get through.  Notification callbacks will be sent in both cases.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node whose associations are to be changed.
		 * \param _groupIdx One-based index of the group (because Z-Wave product manuals use one-based group numbering).
		 * \param _targetNodeId Identifier for the node that will be added to the association group.
		 * \see GetNumGroups, GetAssociations, GetMaxAssociations, RemoveAssociation
		 */
		//void AddAssociation( uint32 const _homeId, uint8 const _nodeId, uint8 const _groupIdx, uint8 const _targetNodeId );
    void AddAssociation( 1:i32 _homeId, 2:byte _nodeId, 3:byte _groupIdx, 4:byte _targetNodeId );

		/**
		 * \brief Removes a node from an association group.
		 * Due to the possibility of a device being asleep, the command is assumed to suceeed, and the association data
		 * held in this class is updated directly.  This will be reverted by a future Association message from the device
		 * if the Z-Wave message actually failed to get through.   Notification callbacks will be sent in both cases.
		 * \param _homeId The Home ID of the Z-Wave controller that manages the node.
		 * \param _nodeId The ID of the node whose associations are to be changed.
		 * \param _groupIdx One-based index of the group (because Z-Wave product manuals use one-based group numbering).
		 * \param _targetNodeId Identifier for the node that will be removed from the association group.
		 * \see GetNumGroups, GetAssociations, GetMaxAssociations, AddAssociation
		 */
		//void RemoveAssociation( uint32 const _homeId, uint8 const _nodeId, uint8 const _groupIdx, uint8 const _targetNodeId );
    void RemoveAssociation( 1:i32 _homeId, 2:byte _nodeId, 3:byte _groupIdx, 4:byte _targetNodeId );

	//-----------------------------------------------------------------------------
	//	Notifications   (TODO)
	//-----------------------------------------------------------------------------
	/** \name Notifications
	 *  For notification of changes to the Z-Wave network or device values and associations.
	 */
     
    //-----------------------------------------------------------------------------
	// Controller commands
	//-----------------------------------------------------------------------------
	/** \name Controller Commands
	 *  Commands for Z-Wave network management using the PC Controller.
	 */

        /**
		 * \brief Hard Reset a PC Z-Wave Controller.
		 * Resets a controller and erases its network configuration settings.  The controller becomes a primary controller ready to add devices to a new network.
		 * \param _homeId The Home ID of the Z-Wave controller to be reset.
		 * \see SoftReset
		 */
		//void ResetController( uint32 const _homeId );
    void ResetController( 1:i32 _homeId );

		/**
		 * \brief Soft Reset a PC Z-Wave Controller.
		 * Resets a controller without erasing its network configuration settings.
		 * \param _homeId The Home ID of the Z-Wave controller to be reset.
		 * \see SoftReset
		 */
		//void SoftReset( uint32 const _homeId );
    void SoftReset( 1:i32 _homeId );

		/**
		 * \brief Start a controller command process.
		 * \param _homeId The Home ID of the Z-Wave controller.
		 * \param _command The command to be sent to the controller.
		 * \param _callback pointer to a function that will be called at various stages during the command process
		 * \param _context pointer to user defined data that will be passed into to the callback function.  Defaults to NULL.
		 * \param _highPower used only with the AddDevice, AddController, RemoveDevice and RemoveController commands. 
		 * Usually when adding or removing devices, the controller operates at low power so that the controller must
		 * be physically close to the device for security reasons.  If _highPower is true, the controller will 
		 * operate at normal power levels instead.  Defaults to false.
		 * \param _nodeId used only with the ReplaceFailedNode command, to specify the node that is going to be replaced.
		 * \return true if the command was accepted and has started.
		 * \see CancelControllerCommand, HasNodeFailed, RemoveFailedNode, Driver::ControllerCommand, Driver::pfnControllerCallback_t, 
		 * to notify the user of progress or to request actions on the user's part.  Defaults to NULL.
		 * <p> Commands
		 * - Driver::ControllerCommand_AddController - Add a new secondary controller to the Z-Wave network.
		 * - Driver::ControllerCommand_AddDevice - Add a new device (but not a controller) to the Z-Wave network.
		 * - Driver::ControllerCommand_CreateNewPrimary (Not yet implemented)
		 * - Driver::ControllerCommand_ReceiveConfiguration -   
		 * - Driver::ControllerCommand_RemoveController - remove a controller from the Z-Wave network.
		 * - Driver::ControllerCommand_RemoveDevice - remove a device (but not a controller) from the Z-Wave network.
 		 * - Driver::ControllerCommand_RemoveFailedNode - move a node to the controller's list of failed nodes.  The node must actually
		 * have failed or have been disabled since the command will fail if it responds.  A node must be in the controller's failed nodes list
		 * for ControllerCommand_ReplaceFailedNode to work.
		 * - Driver::ControllerCommand_HasNodeFailed - Check whether a node is in the controller's failed nodes list.
		 * - Driver::ControllerCommand_ReplaceFailedNode - replace a failed device with another. If the node is not in 
		 * the controller's failed nodes list, or the node responds, this command will fail.
		 * - Driver:: ControllerCommand_TransferPrimaryRole	(Not yet implemented) - Add a new controller to the network and
		 * make it the primary.  The existing primary will become a secondary controller.  
		 * - Driver::ControllerCommand_RequestNetworkUpdate - Update the controller with network information from the SUC/SIS.
		 * - Driver::ControllerCommand_RequestNodeNeighborUpdate - Get a node to rebuild its neighbour list.  This method also does ControllerCommand_RequestNodeNeighbors afterwards.
		 * - Driver::ControllerCommand_AssignReturnRoute - Assign a network return route to a device.
		 * - Driver::ControllerCommand_DeleteAllReturnRoutes - Delete all network return routes from a device.
		 * <p> Callbacks
		 * - Driver::ControllerState_Waiting, the controller is waiting for a user action.  A notice should be displayed 
		 * to the user at this point, telling them what to do next.
		 * For the add, remove, replace and transfer primary role commands, the user needs to be told to press the 
		 * inclusion button on the device that  is going to be added or removed.  For ControllerCommand_ReceiveConfiguration, 
		 * they must set their other controller to send its data, and for ControllerCommand_CreateNewPrimary, set the other
		 * controller to learn new data.
		 * - Driver::ControllerState_InProgress - the controller is in the process of adding or removing the chosen node.  It is now too late to cancel the command.
		 * - Driver::ControllerState_Complete - the controller has finished adding or removing the node, and the command is complete.
		 * - Driver::ControllerState_Failed - will be sent if the command fails for any reason.
		 */		
		//bool BeginControllerCommand( uint32 const _homeId, Driver::ControllerCommand _command, Driver::pfnControllerCallback_t _callback = NULL, void* _context = NULL, bool _highPower = false, uint8 _nodeId = 0xff, uint8 _arg = 0 );
		bool BeginControllerCommand( 1:i32 _homeId, 2:DriverControllerCommand  _command, 3:bool _highPower, 4:byte _nodeId, 5:byte _arg );

		/**
		 * \brief Cancels any in-progress command running on a controller.
		 * \param _homeId The Home ID of the Z-Wave controller.
		 * \return true if a command was running and was cancelled.
		 * \see BeginControllerCommand 
		 */
		//bool CancelControllerCommand( uint32 const _homeId );
		bool CancelControllerCommand( 1:i32 _homeId );

	//-----------------------------------------------------------------------------
	// Scene commands
	//-----------------------------------------------------------------------------
	/** \name Scene Commands
	 *  Commands for Z-Wave scene interface.
	 */

        /**
		 * \brief Gets the number of scenes that have been defined.
		 * \return The number of scenes.
		 * \see GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//uint8 GetNumScenes( );
    byte GetNumScenes( );

		/**
		 * \brief Gets a list of all the SceneIds.
		 * \param _sceneIds is a pointer to an array of integers.
		 * \return The number of scenes. If zero, _sceneIds will be NULL and doesn't need to be freed.
		 * \see GetNumScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//uint8 GetAllScenes( uint8** _sceneIds );
        // ekarak: Notice change of return argument
    GetAllScenesReturnStruct GetAllScenes( );

		/**
		 * \brief Create a new Scene passing in Scene ID
		 * \return uint8 Scene ID used to reference the scene. 0 is failure result.
		 * \see GetNumScenes, GetAllScenes, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene

		 */
		//uint8 CreateScene();
    byte CreateScene();

		/**
		 * \brief Remove an existing Scene.
		 * \param _sceneId is an integer representing the unique Scene ID to be removed.
		 * \return true if scene was removed.
		 * \see GetNumScenes, GetAllScenes, CreateScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool RemoveScene( uint8 const _sceneId );
    bool RemoveScene( 1:byte _sceneId );

		/**
		 * \brief Add a bool Value ID to an existing scene.
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the bool value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, bool const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_Bool( 1:byte _sceneId, 2:RemoteValueID  _valueId, 3:bool _value );

		/**
		 * \brief Add a byte Value ID to an existing scene.
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the byte value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, uint8 const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_Uint8( 1: byte  _sceneId, 2:RemoteValueID  _valueId, 3:byte _value );

		/**
		 * \brief Add a decimal Value ID to an existing scene.
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the float value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, float const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_Float(  1: byte  _sceneId, 2:RemoteValueID  _valueId, 3:double _value );

		/**
		 * \brief Add a 32-bit signed integer Value ID to an existing scene.
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the int32 value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, int32 const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_Int32(  1: byte  _sceneId, 2:RemoteValueID  _valueId, 3:i32 _value );
    
		/**
		 * \brief Add a 16-bit signed integer Value ID to an existing scene.
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the int16 value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, int16 const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_Int16(  1: byte  _sceneId, 2:RemoteValueID  _valueId, 3:i16 _value );

		/**
		 * \brief Add a string Value ID to an existing scene.
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the string value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, string const& _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_String(  1: byte  _sceneId, 2:RemoteValueID  _valueId, 3:string _value );

		/**
		 * \brief Add the selected item list Value ID to an existing scene (as a string).
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the string value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool AddSceneValueListSelection( uint8 const _sceneId, ValueID const& _valueId, string const& _value );
    // ekarak: overloaded function renamed
    bool AddSceneValueListSelection_String( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:string _value );

		/**
		 * \brief Add the selected item list Value ID to an existing scene (as a integer).
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the integer value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool AddSceneValueListSelection( uint8 const _sceneId, ValueID const& _valueId, int32 const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValueListSelection_Int32( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:i32 _value );

		/**
		 * \brief Remove the Value ID from an existing scene.
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be removed.
		 * \return true if Value ID was removed.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool RemoveSceneValue( uint8 const _sceneId, ValueID const& _valueId );
    bool RemoveSceneValue( 1:byte _sceneId, 2:RemoteValueID _valueId );

		/**
		 * \brief Retrieves the scene's list of values.
		 * \param _sceneId The Scene ID of the scene to retrieve the value from.
		 * \param o_value Pointer to an array of ValueIDs if return is non-zero.
		 * \return The number of nodes in the o_value array. If zero, the array will point to NULL and does not need to be deleted.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//int SceneGetValues( uint8 const _sceneId, vector<ValueID>* o_value );
    // ekarak: Notice change of return argument
    SceneGetValuesReturnStruct SceneGetValues( 1:byte _sceneId );
    
		/**
		 * \brief Retrieves a scene's value as a bool.
		 * \param _sceneId The Scene ID of the scene to retrieve the value from.
		 * \param _valueId The Value ID of the value to retrieve.
		 * \param o_value Pointer to a bool that will be filled with the returned value.
		 * \return true if the value was obtained.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SceneGetValueAsBool( uint8 const _sceneId, ValueID const& _valueId, bool* o_value );
    // ekarak: Notice change of return argument
    Bool_Bool SceneGetValueAsBool( 1:byte _sceneId, 2:RemoteValueID _valueId );

		/**
		 * \brief Retrieves a scene's value as an 8-bit unsigned integer.
		 * \param _sceneId The Scene ID of the scene to retrieve the value from.
		 * \param _valueId The Value ID of the value to retrieve.
		 * \param o_value Pointer to a uint8 that will be filled with the returned value.
		 * \return true if the value was obtained.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SceneGetValueAsByte( uint8 const _sceneId, ValueID const& _valueId, uint8* o_value );
    // ekarak: Notice change of return argument
    Bool_UInt8 SceneGetValueAsByte( 1:byte _sceneId, 2:RemoteValueID _valueId );

		/**
		 * \brief Retrieves a scene's value as a float.
		 * \param _sceneId The Scene ID of the scene to retrieve the value from.
		 * \param _valueId The Value ID of the value to retrieve.
		 * \param o_value Pointer to a float that will be filled with the returned value.
		 * \return true if the value was obtained.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
        //bool SceneGetValueAsFloat( uint8 const _sceneId, ValueID const& _valueId, float* o_value );
    // ekarak: Notice change of return argument
    Bool_Float SceneGetValueAsFloat( 1:byte _sceneId, 2:RemoteValueID _valueId );
    
		/**
		 * \brief Retrieves a scene's value as a 32-bit signed integer.
		 * \param _sceneId The Scene ID of the scene to retrieve the value from.
		 * \param _valueId The Value ID of the value to retrieve.
		 * \param o_value Pointer to a int32 that will be filled with the returned value.
		 * \return true if the value was obtained.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SceneGetValueAsInt( uint8 const _sceneId, ValueID const& _valueId, int32* o_value );
    // ekarak: Notice change of return argument
    Bool_Int SceneGetValueAsInt( 1:byte _sceneId, 2:RemoteValueID _valueId );

		/**
		 * \brief Retrieves a scene's value as a 16-bit signed integer.
		 * \param _sceneId The Scene ID of the scene to retrieve the value from.
		 * \param _valueId The Value ID of the value to retrieve.
		 * \param o_value Pointer to a int16 that will be filled with the returned value.
		 * \return true if the value was obtained.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SceneGetValueAsShort( uint8 const _sceneId, ValueID const& _valueId, int16* o_value );
    // ekarak: Notice change of return argument
    Bool_Int16 SceneGetValueAsShort( 1:byte _sceneId, 2:RemoteValueID _valueId );

		/**
		 * \brief Retrieves a scene's value as a string.
		 * \param _sceneId The Scene ID of the scene to retrieve the value from.
		 * \param _valueId The Value ID of the value to retrieve.
		 * \param o_value Pointer to a string that will be filled with the returned value.
		 * \return true if the value was obtained.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SceneGetValueAsString( uint8 const _sceneId, ValueID const& _valueId, string* o_value );
    // ekarak: Notice change of return argument
    Bool_String SceneGetValueAsString( 1:byte _sceneId, 2:RemoteValueID _valueId);

		/**
		 * \brief Retrieves a scene's value as a list (as a string).
		 * \param _sceneId The Scene ID of the scene to retrieve the value from.
		 * \param _valueId The Value ID of the value to retrieve.
		 * \param o_value Pointer to a string that will be filled with the returned value.
		 * \return true if the value was obtained.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SceneGetValueListSelection( uint8 const _sceneId, ValueID const& _valueId, string* o_value );
    // ekarak: Notice change of naming & return argument
    Bool_String SceneGetValueListSelection_String( 1:byte _sceneId, 2:RemoteValueID  _valueId );
		/**
		 * \brief Retrieves a scene's value as a list (as a integer).
		 * \param _sceneId The Scene ID of the scene to retrieve the value from.
		 * \param _valueId The Value ID of the value to retrieve.
		 * \param o_value Pointer to a integer that will be filled with the returned value.
		 * \return true if the value was obtained.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SceneGetValueListSelection( uint8 const _sceneId, ValueID const& _valueId, int32* o_value );
    // ekarak: Notice change of naming & return argument
    Bool_Int SceneGetValueListSelection_Int32( 1:byte _sceneId, 2:RemoteValueID _valueId );

		/**
		 * \brief Set a bool Value ID to an existing scene's ValueID
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the bool value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, bool const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_Bool( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:bool _value );

		/**
		 * \brief Set a byte Value ID to an existing scene's ValueID
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the byte value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, uint8 const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_Uint8( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:byte _value );
    
		/**
		 * \brief Set a decimal Value ID to an existing scene's ValueID
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the float value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, float const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_Float( 1:byte _sceneId, 2:RemoteValueID _valueId, 3: double _value );

		/**
		 * \brief Set a 32-bit signed integer Value ID to an existing scene's ValueID
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the int32 value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, int32 const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_Int32( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:i32 _value );
    
		/**
		 * \brief Set a 16-bit integer Value ID to an existing scene's ValueID
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the int16 value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, int16 const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_Int16( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:i16 _value );

		/**
		 * \brief Set a string Value ID to an existing scene's ValueID
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the string value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, string const& _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_String( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:string _value );
    
		/**
		 * \brief Set the list selected item Value ID to an existing scene's ValueID (as a string).
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the string value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SetSceneValueListSelection( uint8 const _sceneId, ValueID const& _valueId, string const& _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValueListSelection_String( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:string _value );
    
		/**
		 * \brief Set the list selected item Value ID to an existing scene's ValueID (as a integer).
		 * \param _sceneId is an integer representing the unique Scene ID.
		 * \param _valueId is the Value ID to be added.
		 * \param _value is the integer value to be saved.
		 * \return true if Value ID was added.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists, ActivateScene
		 */
		//bool SetSceneValueListSelection( uint8 const _sceneId, ValueID const& _valueId, int32 const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValueListSelection_Int32( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:i32 _value );
    
		/**
		 * \brief Returns a label for the particular scene.
		 * \param _sceneId The Scene ID
		 * \return The label string.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, SetSceneLabel, SceneExists, ActivateScene
		 */
		//string GetSceneLabel( uint8 const _sceneId );
    string GetSceneLabel( 1:byte _sceneId );

		/**
		 * \brief Sets a label for the particular scene.
		 * \param _sceneId The Scene ID
		 * \param _value The new value of the label.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SceneExists, ActivateScene
		 */
		//void SetSceneLabel( uint8 const _sceneId, string const& _value );
    void SetSceneLabel( 1:byte _sceneId, 2:string _value );

		/**
		 * \brief Check if a Scene ID is defined.
		 * \param _sceneId The Scene ID.
		 * \return true if Scene ID exists.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, ActivateScene
		 */
		//bool SceneExists( uint8 const _sceneId );
    bool SceneExists( 1:byte _sceneId );

		/**
		 * \brief Activate given scene to perform all its actions.
		 * \param _sceneId The Scene ID.
		 * \return true if it is successful.
		 * \see GetNumScenes, GetAllScenes, CreateScene, RemoveScene, AddSceneValue, RemoveSceneValue, SceneGetValues, SceneGetValueAsBool, SceneGetValueAsByte, SceneGetValueAsFloat, SceneGetValueAsInt, SceneGetValueAsShort, SceneGetValueAsString, SetSceneValue, GetSceneLabel, SetSceneLabel, SceneExists
		 */
		//bool ActivateScene( uint8 const _sceneId );
    bool ActivateScene( 1:byte _sceneId );


    // ----------------------- ekarak: and a little extra candy server for missing functionality from OZW
    void SendAllValues();
}