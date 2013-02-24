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
    ControllerCommand_DeleteAllReturnRoutes,			/**< Delete all return routes from a device. */
    ControllerCommand_CreateButton,             /** Create a handheld button id. */
	ControllerCommand_DeleteButton             /** Delete a handheld button id. */
}
    
struct RemoteValueID {
    1:i32   _homeId,
    2:byte  _nodeId,
    3:RemoteValueGenre _genre,
    4:byte  _commandClassId,
    5:byte  _instance,
    6:byte  _valueIndex,
    7:RemoteValueType _type
}

// Used in GetDriverStatistics
struct DriverData {
    1:i32 s_SOFCnt;			// Number of SOF bytes received
    2:i32 s_ACKWaiting;			// Number of unsolcited messages while waiting for an ACK
    3:i32 s_readAborts;			// Number of times read were aborted due to timeouts
    4:i32 s_badChecksum;			// Number of bad checksums
    5:i32 s_readCnt;			// Number of messages successfully read
    6:i32 s_writeCnt;			// Number of messages successfully sent
    7:i32 s_CANCnt;			// Number of CAN bytes received
    8:i32 s_NAKCnt;			// Number of NAK bytes received
    9:i32 s_ACKCnt;			// Number of ACK bytes received
    10:i32 s_OOFCnt;			// Number of bytes out of framing
    11:i32 s_dropped;			// Number of messages dropped & not delivered
    12:i32 s_retries;			// Number of messages retransmitted
    13:i32 s_controllerReadCnt;		// Number of controller messages read
    14:i32 s_controllerWriteCnt;		// Number of controller messages sent
}

struct GetDriverStatisticsReturnStruct {
    1:DriverData _data;
}

struct CommandClassData {
	1:byte m_commandClassId;
	2:i32  m_sentCnt;
	3:i32  m_receivedCnt;
}

struct NodeData {
	1:i32 m_sentCnt;
	2:i32 m_sentFailed;
	3:i32 m_retries;
	4:i32 m_receivedCnt;
	5:i32 m_receivedDups;
	6:i32 m_rtt;                                   // last round trip if successful in ms
	7:string m_sentTS;
	8:string m_receivedTS;
	9:i32 m_lastRTT;
	10:i32 m_averageRTT;                            // ms
	11:byte m_quality;                                // Node quality measure
	//12:byte[254] m_lastReceivedMessage;
	12:list<byte>  m_lastReceivedMessage;
	13:list<CommandClassData> m_ccData;
}
		
struct GetNodeStatisticsReturnStruct {
    1:NodeData _data;
}

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
    
    //uint8 GetSUCNodeId( uint32 const _homeId );
    byte GetSUCNodeId( 1:i32 _homeId );
    
    //bool IsPrimaryController( uint32 const _homeId );
    bool IsPrimaryController(1: i32 _homeId );
    
    //bool IsStaticUpdateController( uint32 const _homeId );
    bool IsStaticUpdateController( 1:i32 _homeId );

    //bool IsBridgeController( uint32 const _homeId );
    bool IsBridgeController( 1:i32 _homeId );
    
    //string GetLibraryVersion( uint32 const _homeId );
    string GetLibraryVersion( 1:i32 _homeId );
    
    //string GetLibraryTypeName( uint32 const _homeId );
    string GetLibraryTypeName( 1:i32 _homeId );

    //int32 GetSendQueueCount( uint32 const _homeId );
    i32 GetSendQueueCount( 1:i32 _homeId );
    
    //void LogDriverStatistics( uint32 const _homeId );
    void LogDriverStatistics( 1:i32 _homeId );

    //TODO:: Driver::ControllerInterface GetControllerInterfaceType( uint32 const _homeId );

    //string GetControllerPath( uint32 const _homeId );
    string GetControllerPath( 1:i32 _homeId );
    
	//-----------------------------------------------------------------------------
	//	Polling Z-Wave devices
	//-----------------------------------------------------------------------------
	//int32 GetPollInterval();
    i32 GetPollInterval();

    //void SetPollInterval( int32 _milliseconds, bool _bIntervalBetweenPolls );
    void SetPollInterval( 1:i32 _milliseconds, 2:bool _bIntervalBetweenPolls );

    //bool EnablePoll( ValueID const _valueId, uint8 const _intensity = 1 );
    bool EnablePoll( 1:RemoteValueID _valueId, 2:byte _intensity = 1 );

    //bool DisablePoll( ValueID const _valueId );
    bool DisablePoll( 1:RemoteValueID _valueId );

	//bool isPolled( ValueID const _valueId );
    bool isPolled( 1:RemoteValueID _valueId );
        
    //void SetPollIntensity( ValueID const _valueId, uint8 const _intensity );
    void SetPollIntensity( 1:RemoteValueID _valueId, 2:byte _intensity );
    
    //-----------------------------------------------------------------------------
    //	Node information
    //-----------------------------------------------------------------------------
	//bool RefreshNodeInfo( uint32 const _homeId, uint8 const _nodeId );
    bool RefreshNodeInfo( 1:i32 _homeId, 2:byte _nodeId );

    //bool RequestNodeState( uint32 const _homeId, uint8 const _nodeId );
    bool RequestNodeState( 1:i32 _homeId, 2:byte _nodeId );

	//bool RequestNodeDynamic( uint32 const _homeId, uint8 const _nodeId );
    bool RequestNodeDynamic( 1:i32 _homeId, 2:byte _nodeId );

	//bool IsNodeListeningDevice( uint32 const _homeId, uint8 const _nodeId );
    bool IsNodeListeningDevice( 1:i32 _homeId, 2:byte _nodeId );
    
	//bool IsNodeFrequentListeningDevice( uint32 const _homeId, uint8 const _nodeId );
	bool IsNodeFrequentListeningDevice( 1:i32 _homeId, 2:byte _nodeId );

	//bool IsNodeBeamingDevice( uint32 const _homeId, uint8 const _nodeId );
	bool IsNodeBeamingDevice( 1:i32 _homeId, 2:byte _nodeId );

	//bool IsNodeRoutingDevice( uint32 const _homeId, uint8 const _nodeId );
    bool IsNodeRoutingDevice( 1:i32 _homeId, 2:byte _nodeId );

	//bool IsNodeSecurityDevice( uint32 const _homeId, uint8 const _nodeId );
	bool IsNodeSecurityDevice( 1:i32 _homeId, 2:byte _nodeId );

	//uint32 GetNodeMaxBaudRate( uint32 const _homeId, uint8 const _nodeId );
    i32 GetNodeMaxBaudRate( 1:i32 _homeId, 2:byte _nodeId );

    //uint8 GetNodeVersion( uint32 const _homeId, uint8 const _nodeId );
    byte GetNodeVersion( 1:i32 _homeId, 2:byte _nodeId );
    
    //uint8 GetNodeSecurity( uint32 const _homeId, uint8 const _nodeId );
    byte GetNodeSecurity( 1:i32 _homeId, 2:byte _nodeId );
    		
	//uint8 GetNodeBasic( uint32 const _homeId, uint8 const _nodeId );
    byte GetNodeBasic( 1:i32 _homeId, 2:byte _nodeId );
		
    //uint8 GetNodeGeneric( uint32 const _homeId, uint8 const _nodeId );
    byte GetNodeGeneric( 1:i32 _homeId, 2:byte _nodeId );
		
	//uint8 GetNodeSpecific( uint32 const _homeId, uint8 const _nodeId );
    byte GetNodeSpecific( 1:i32 _homeId, 2:byte _nodeId );

    //string GetNodeType( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeType( 1:i32 _homeId, 2:byte _nodeId );

	//uint32 GetNodeNeighbors( uint32 const _homeId, uint8 const _nodeId, uint8** _nodeNeighbors );
    UInt32_ListByte GetNodeNeighbors( 1:i32 _homeId, 2:byte _nodeId);

	//string GetNodeManufacturerName( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeManufacturerName( 1:i32 _homeId, 2:byte _nodeId );

	//string GetNodeProductName( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeProductName( 1:i32 _homeId, 2:byte _nodeId );

	//string GetNodeName( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeName( 1:i32 _homeId, 2:byte _nodeId );

	//string GetNodeLocation( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeLocation( 1:i32 _homeId, 2:byte _nodeId );

	//string GetNodeManufacturerId( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeManufacturerId( 1:i32 _homeId, 2:byte _nodeId );

	//string GetNodeProductType( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeProductType( 1:i32 _homeId, 2:byte _nodeId );

	//string GetNodeProductId( uint32 const _homeId, uint8 const _nodeId );
    string GetNodeProductId( 1:i32 _homeId, 2:byte _nodeId );

	//void SetNodeManufacturerName( uint32 const _homeId, uint8 const _nodeId, string const& _manufacturerName );
    void SetNodeManufacturerName( 1:i32 _homeId, 2:byte _nodeId, 3:string _manufacturerName );
		
	//void SetNodeProductName( uint32 const _homeId, uint8 const _nodeId, string const& _productName );
    void SetNodeProductName( 1:i32 _homeId, 2:byte _nodeId, 3:string _productName );

	//void SetNodeName( uint32 const _homeId, uint8 const _nodeId, string const& _nodeName );
    void SetNodeName( 1:i32 _homeId, 2:byte _nodeId, 3:string _nodeName );

	//void SetNodeLocation( uint32 const _homeId, uint8 const _nodeId, string const& _location );
    void SetNodeLocation( 1:i32 _homeId, 2:byte _nodeId, 3:string _location );

	//void SetNodeOn( uint32 const _homeId, uint8 const _nodeId );
    void SetNodeOn( 1:i32 _homeId, 2:byte _nodeId );

	//void SetNodeOff( uint32 const _homeId, uint8 const _nodeId );
    void SetNodeOff( 1:i32 _homeId, 2:byte _nodeId );

	//void SetNodeLevel( uint32 const _homeId, uint8 const _nodeId, uint8 const _level );
    void SetNodeLevel( 1:i32 _homeId, 2:byte _nodeId, 3:byte _level );

	//bool IsNodeInfoReceived( uint32 const _homeId, uint8 const _nodeId );
    bool IsNodeInfoReceived( 1:i32 _homeId, 2:byte _nodeId );

    //bool GetNodeClassInformation( uint32 const _homeId, uint8 const _nodeId, uint8 const _commandClassId, string *_className = NULL, uint8 *_classVersion = NULL);
    Bool_GetNodeClassInformation GetNodeClassInformation( 1:i32 _homeId, 2:byte _nodeId, 3:byte _commandClassId);
        
	//bool IsNodeAwake( uint32 const _homeId, uint8 const _nodeId );
	bool IsNodeAwake( 1:i32 _homeId, 2: byte _nodeId );
	
       //bool IsNodeFailed( uint32 const _homeId, uint8 const _nodeId );
       bool IsNodeFailed( 1:i32 _homeId, 2: byte _nodeId );
		
	//string GetNodeQueryStage( uint32 const _homeId, uint8 const _nodeId );
	string GetNodeQueryStage( 1:i32 _homeId, 2:byte _nodeId );
	
	//-----------------------------------------------------------------------------
	// Values
	//-----------------------------------------------------------------------------
	//string GetValueLabel( ValueID const& _id );
    string GetValueLabel( 1:RemoteValueID _id );

	//void SetValueLabel( ValueID const& _id, string const& _value );
    void SetValueLabel( 1:RemoteValueID _id, 2:string _value );
    
	//string GetValueUnits( ValueID const& _id );
    string GetValueUnits( 1:RemoteValueID _id );
		
	//void SetValueUnits( ValueID const& _id, string const& _value );
    void SetValueUnits( 1:RemoteValueID _id, 2:string _value );
		
	//string GetValueHelp( ValueID const& _id );
    string GetValueHelp( 1:RemoteValueID _id );

	//void SetValueHelp( ValueID const& _id, string const& _value );
    void SetValueHelp( 1:RemoteValueID _id, 2:string _value );

	//int32 GetValueMin( ValueID const& _id );
    i32 GetValueMin( 1:RemoteValueID _id );

	//int32 GetValueMax( ValueID const& _id );
    i32 GetValueMax( 1:RemoteValueID _id );

	//bool IsValueReadOnly( ValueID const& _id );
    bool IsValueReadOnly( 1:RemoteValueID _id );

	//bool IsValueWriteOnly( ValueID const& _id );
    bool IsValueWriteOnly( 1:RemoteValueID _id );
        
	//bool IsValueSet( ValueID const& _id );
    bool IsValueSet( 1:RemoteValueID _id );

    //bool IsValuePolled( ValueID const& _id );
    bool IsValuePolled( 1:RemoteValueID _id );
    
	//bool GetValueAsBool( ValueID const& _id, bool* o_value );
    Bool_Bool GetValueAsBool( 1:RemoteValueID _id);

	//bool GetValueAsByte( ValueID const& _id, uint8* o_value );
    Bool_UInt8 GetValueAsByte( 1:RemoteValueID _id );

	//bool GetValueAsFloat( ValueID const& _id, float* o_value );
    Bool_Float GetValueAsFloat( 1:RemoteValueID _id );

	//bool GetValueAsInt( ValueID const& _id, int32* o_value );
    Bool_Int GetValueAsInt( 1:RemoteValueID _id );

	//bool GetValueAsShort( ValueID const& _id, int16* o_value );
    Bool_Int16 GetValueAsShort( 1:RemoteValueID _id );
		
	//bool GetValueAsString( ValueID const& _id, string* o_value );
    Bool_String GetValueAsString( 1:RemoteValueID _id );
		
	// TODO: bool GetValueAsRaw( ValueID const& _id, uint8** o_value, uint8* o_length );
	
	//bool GetValueListSelection( ValueID const& _id, string* o_value );
    // ekarak: thrift does not support function overloading
    Bool_String GetValueListSelection_String( 1:RemoteValueID _id );

	//bool GetValueListSelection( ValueID const& _id, int32* o_value );
    // ekarak: overloading by name mangling
    Bool_Int GetValueListSelection_Int32( 1:RemoteValueID _id );

	//bool GetValueListItems( ValueID const& _id, vector<string>* o_value );
    // ekarak: client must ensure value's type is ValueType_List
    Bool_ListString GetValueListItems( 1:RemoteValueID _id );

	//bool GetValueFloatPrecision( ValueID const& _id, uint8* o_value );
    Bool_UInt8 GetValueFloatPrecision( 1:RemoteValueID _id );

	//bool SetValue( ValueID const& _id, bool const _value );
    // ekarak: client must ensure value's type is ValueType_Bool
    bool SetValue_Bool( 1:RemoteValueID _id, 2:bool _value );

	//bool SetValue( ValueID const& _id, uint8 const _value );
    // ekarak:  client must ensure value's type
    bool SetValue_UInt8( 1:RemoteValueID _id, 2:byte _value, 3:byte _length);

	//bool SetValue( ValueID const& _id, float const _value );
    // ekarak:  client must ensure value's type
    bool SetValue_Float( 1:RemoteValueID _id, 2:double _value );
		
	//bool SetValue( ValueID const& _id, int32 const _value );
    // ekarak: client must ensure value's type
    bool SetValue_Int32( 1:RemoteValueID _id, 2:i32 _value );

	//bool SetValue( ValueID const& _id, int16 const _value );
    // ekarak:  client must ensure value's type
    bool SetValue_Int16( 1:RemoteValueID _id, 2:i16 _value );

	//bool SetValue( ValueID const& _id, string const& _value );
    // ekarak:  client must ensure value's type
    bool SetValue_String( 1:RemoteValueID _id, 2:string _value );
    
	//bool SetValueListSelection( ValueID const& _id, string const& _selectedItem );
    bool SetValueListSelection( 1:RemoteValueID _id, 2:string _selectedItem );
    
    //bool RefreshValue( ValueID const& _id);
    bool RefreshValue( 1:RemoteValueID _id);

    //void SetChangeVerified( ValueID const& _id, bool _verify );
    void SetChangeVerified( 1:RemoteValueID _id, 2:bool _verify );
    
	//bool PressButton( ValueID const& _id );
    bool PressButton( 1:RemoteValueID _id );

	//bool ReleaseButton( ValueID const& _id );
    bool ReleaseButton( 1:RemoteValueID _id );


	//-----------------------------------------------------------------------------
	// Climate Control Schedules
	//-----------------------------------------------------------------------------
	//uint8 GetNumSwitchPoints( ValueID const& _id );
    byte GetNumSwitchPoints( 1:RemoteValueID _id );

	//bool SetSwitchPoint( ValueID const& _id, uint8 const _hours, uint8 const _minutes, int8 const _setback );
    bool SetSwitchPoint( 1:RemoteValueID _id, 2:byte _hours, 3:byte _minutes, 4:byte _setback );

	//bool RemoveSwitchPoint( ValueID const& _id, uint8 const _hours, uint8 const _minutes );
    bool RemoveSwitchPoint( 1:RemoteValueID _id, 2:byte _hours, 3:byte _minutes );

	//void ClearSwitchPoints( ValueID const& _id );
    void ClearSwitchPoints( 1:RemoteValueID _id );
		
	//bool GetSwitchPoint( ValueID const& _id, uint8 const _idx, uint8* o_hours, uint8* o_minutes, int8* o_setback );
    GetSwitchPointReturnStruct GetSwitchPoint( 1:RemoteValueID _id, 2:byte _idx);


	//-----------------------------------------------------------------------------
	// SwitchAll
	//-----------------------------------------------------------------------------
	void SwitchAllOn( 1:i32 _homeId );
	void SwitchAllOff( 1:i32 _homeId );


	//-----------------------------------------------------------------------------
	// Configuration Parameters
	//-----------------------------------------------------------------------------
	//bool SetConfigParam( uint32 const _homeId, uint8 const _nodeId, uint8 const _param, int32 _value, uint8 const _size = 2 );
    bool SetConfigParam( 1:i32 _homeId, 2:byte _nodeId, 3:byte _param, 4:i32 _value, 5:byte _size = 2 );

	//void RequestConfigParam( uint32 const _homeId, uint8 const _nodeId, uint8 const _param );
    void RequestConfigParam( 1:i32 _homeId, 2:byte _nodeId, 3:byte _param );

	//void RequestAllConfigParams( uint32 const _homeId, uint8 const _nodeId );
    void RequestAllConfigParams( 1:i32 _homeId, 2:byte _nodeId );

	//-----------------------------------------------------------------------------
	// Groups (wrappers for the Node methods)
	//-----------------------------------------------------------------------------
	//uint8 GetNumGroups( uint32 const _homeId, uint8 const _nodeId );
    byte GetNumGroups( 1:i32 _homeId, 2:byte _nodeId );

	//uint32 GetAssociations( uint32 const _homeId, uint8 const _nodeId, uint8 const _groupIdx, uint8** o_associations );
    // ekarak: return list of associations instead
    GetAssociationsReturnStruct GetAssociations( 1:i32 _homeId, 2:byte _nodeId, 3:byte _groupIdx);

	//uint8 GetMaxAssociations( uint32 const _homeId, uint8 const _nodeId, uint8 const _groupIdx );
    byte GetMaxAssociations( 1:i32 _homeId, 2:byte _nodeId, 3:byte _groupIdx );

	//string GetGroupLabel( uint32 const _homeId, uint8 const _nodeId, uint8 const _groupIdx );
    string GetGroupLabel( 1:i32 _homeId, 2:byte _nodeId, 3:byte _groupIdx );

	//void AddAssociation( uint32 const _homeId, uint8 const _nodeId, uint8 const _groupIdx, uint8 const _targetNodeId );
    void AddAssociation( 1:i32 _homeId, 2:byte _nodeId, 3:byte _groupIdx, 4:byte _targetNodeId );

	//void RemoveAssociation( uint32 const _homeId, uint8 const _nodeId, uint8 const _groupIdx, uint8 const _targetNodeId );
    void RemoveAssociation( 1:i32 _homeId, 2:byte _nodeId, 3:byte _groupIdx, 4:byte _targetNodeId );

    //-----------------------------------------------------------------------------
	// Controller commands
	//-----------------------------------------------------------------------------
	//void ResetController( uint32 const _homeId );
    void ResetController( 1:i32 _homeId );
    
	//void SoftReset( uint32 const _homeId );
    void SoftReset( 1:i32 _homeId );

	//bool BeginControllerCommand( uint32 const _homeId, Driver::ControllerCommand _command, Driver::pfnControllerCallback_t _callback = NULL, void* _context = NULL, bool _highPower = false, uint8 _nodeId = 0xff, uint8 _arg = 0 );
	bool BeginControllerCommand( 1:i32 _homeId, 2:DriverControllerCommand  _command, 3:bool _highPower, 4:byte _nodeId, 5:byte _arg );

	//bool CancelControllerCommand( uint32 const _homeId );
	bool CancelControllerCommand( 1:i32 _homeId );

        //-----------------------------------------------------------------------------
        // Network commands
        //-----------------------------------------------------------------------------
	
	//void TestNetworkNode( uint32 const _homeId, uint8 const _nodeId, uint32 const _count );
	void TestNetworkNode( 1:i32 _homeId, 2: byte _nodeId, 3: i32 _count );
	
	//void TestNetwork( uint32 const _homeId, uint32 const _count );
	void TestNetwork( 1:i32 _homeId, 2: i32 _count );

	//void HealNetworkNode( uint32 const _homeId, uint8 const _nodeId, bool _doRR );
	void HealNetworkNode( 1:i32 _homeId, 2:byte _nodeId, 3:bool _doRR );
	
	//void HealNetwork( uint32 const _homeId, bool _doRR );
	void HealNetwork( 1:i32 _homeId, 2:bool _doRR );
	
	//-----------------------------------------------------------------------------
	// Scene commands
	//-----------------------------------------------------------------------------
	//uint8 GetNumScenes( );
    byte GetNumScenes( );

	//uint8 GetAllScenes( uint8** _sceneIds );
    // ekarak: Notice change of return argument
    GetAllScenesReturnStruct GetAllScenes( );

	// void RemoveAllScenes( uint32 const _homeId );
	void RemoveAllScenes( 1:i32 _homeId );

	//uint8 CreateScene();
    byte CreateScene();

	//bool RemoveScene( uint8 const _sceneId );
    bool RemoveScene( 1:byte _sceneId );

	//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, bool const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_Bool( 1:byte _sceneId, 2:RemoteValueID  _valueId, 3:bool _value );

	//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, uint8 const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_Uint8( 1: byte  _sceneId, 2:RemoteValueID  _valueId, 3:byte _value );

	//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, float const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_Float(  1: byte  _sceneId, 2:RemoteValueID  _valueId, 3:double _value );

	//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, int32 const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_Int32(  1: byte  _sceneId, 2:RemoteValueID  _valueId, 3:i32 _value );
    
	//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, int16 const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_Int16(  1: byte  _sceneId, 2:RemoteValueID  _valueId, 3:i16 _value );

	//bool AddSceneValue( uint8 const _sceneId, ValueID const& _valueId, string const& _value );
    // ekarak: overloaded function renamed
    bool AddSceneValue_String(  1: byte  _sceneId, 2:RemoteValueID  _valueId, 3:string _value );

	//bool AddSceneValueListSelection( uint8 const _sceneId, ValueID const& _valueId, string const& _value );
    // ekarak: overloaded function renamed
    bool AddSceneValueListSelection_String( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:string _value );

	//bool AddSceneValueListSelection( uint8 const _sceneId, ValueID const& _valueId, int32 const _value );
    // ekarak: overloaded function renamed
    bool AddSceneValueListSelection_Int32( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:i32 _value );

	//bool RemoveSceneValue( uint8 const _sceneId, ValueID const& _valueId );
    bool RemoveSceneValue( 1:byte _sceneId, 2:RemoteValueID _valueId );

	//int SceneGetValues( uint8 const _sceneId, vector<ValueID>* o_value );
    // ekarak: Notice change of return argument
    SceneGetValuesReturnStruct SceneGetValues( 1:byte _sceneId );
    
	//bool SceneGetValueAsBool( uint8 const _sceneId, ValueID const& _valueId, bool* o_value );
    // ekarak: Notice change of return argument
    Bool_Bool SceneGetValueAsBool( 1:byte _sceneId, 2:RemoteValueID _valueId );

	//bool SceneGetValueAsByte( uint8 const _sceneId, ValueID const& _valueId, uint8* o_value );
    // ekarak: Notice change of return argument
    Bool_UInt8 SceneGetValueAsByte( 1:byte _sceneId, 2:RemoteValueID _valueId );

    //bool SceneGetValueAsFloat( uint8 const _sceneId, ValueID const& _valueId, float* o_value );
    // ekarak: Notice change of return argument
    Bool_Float SceneGetValueAsFloat( 1:byte _sceneId, 2:RemoteValueID _valueId );
    
	//bool SceneGetValueAsInt( uint8 const _sceneId, ValueID const& _valueId, int32* o_value );
    // ekarak: Notice change of return argument
    Bool_Int SceneGetValueAsInt( 1:byte _sceneId, 2:RemoteValueID _valueId );

	//bool SceneGetValueAsShort( uint8 const _sceneId, ValueID const& _valueId, int16* o_value );
    // ekarak: Notice change of return argument
    Bool_Int16 SceneGetValueAsShort( 1:byte _sceneId, 2:RemoteValueID _valueId );

	//bool SceneGetValueAsString( uint8 const _sceneId, ValueID const& _valueId, string* o_value );
    // ekarak: Notice change of return argument
    Bool_String SceneGetValueAsString( 1:byte _sceneId, 2:RemoteValueID _valueId);

	//bool SceneGetValueListSelection( uint8 const _sceneId, ValueID const& _valueId, string* o_value );
    // ekarak: Notice change of naming & return argument
    Bool_String SceneGetValueListSelection_String( 1:byte _sceneId, 2:RemoteValueID  _valueId );

    //bool SceneGetValueListSelection( uint8 const _sceneId, ValueID const& _valueId, int32* o_value );
    // ekarak: Notice change of naming & return argument
    Bool_Int SceneGetValueListSelection_Int32( 1:byte _sceneId, 2:RemoteValueID _valueId );

	//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, bool const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_Bool( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:bool _value );

	//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, uint8 const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_Uint8( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:byte _value );
    
	//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, float const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_Float( 1:byte _sceneId, 2:RemoteValueID _valueId, 3: double _value );

	//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, int32 const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_Int32( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:i32 _value );
    
	//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, int16 const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_Int16( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:i16 _value );

	//bool SetSceneValue( uint8 const _sceneId, ValueID const& _valueId, string const& _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValue_String( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:string _value );
    
	//bool SetSceneValueListSelection( uint8 const _sceneId, ValueID const& _valueId, string const& _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValueListSelection_String( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:string _value );
    
	//bool SetSceneValueListSelection( uint8 const _sceneId, ValueID const& _valueId, int32 const _value );
    // ekarak: Overloaded function renamed
    bool SetSceneValueListSelection_Int32( 1:byte _sceneId, 2:RemoteValueID _valueId, 3:i32 _value );
    
	//string GetSceneLabel( uint8 const _sceneId );
    string GetSceneLabel( 1:byte _sceneId );

	//void SetSceneLabel( uint8 const _sceneId, string const& _value );
    void SetSceneLabel( 1:byte _sceneId, 2:string _value );

	//bool SceneExists( uint8 const _sceneId );
    bool SceneExists( 1:byte _sceneId );

	//bool ActivateScene( uint8 const _sceneId );
    bool ActivateScene( 1:byte _sceneId );

	//-----------------------------------------------------------------------------
	// Statistics interface
	//-----------------------------------------------------------------------------
	//void GetDriverStatistics( uint32 const _homeId, Driver::DriverData* _data );
	GetDriverStatisticsReturnStruct GetDriverStatistics( 1:i32 _homeId );

       //void GetNodeStatistics( uint32 const _homeId, uint8 const _nodeId, Node::NodeData* _data );
	GetNodeStatisticsReturnStruct GetNodeStatistics( 1:i32 _homeId, 2:byte _nodeId);

    // ----------------------- ekarak: and a little extra candy server for missing functionality from OZW
    void SendAllValues();
    void ping();
}