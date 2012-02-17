-ifndef(_ozw_types_included).
-define(_ozw_types_included, yeah).

-define(ozw_RemoteValueGenre_ValueGenre_Basic, 0).
-define(ozw_RemoteValueGenre_ValueGenre_User, 1).
-define(ozw_RemoteValueGenre_ValueGenre_Config, 2).
-define(ozw_RemoteValueGenre_ValueGenre_System, 3).
-define(ozw_RemoteValueGenre_ValueGenre_Count, 4).

-define(ozw_RemoteValueType_ValueType_Bool, 0).
-define(ozw_RemoteValueType_ValueType_Byte, 1).
-define(ozw_RemoteValueType_ValueType_Decimal, 2).
-define(ozw_RemoteValueType_ValueType_Int, 3).
-define(ozw_RemoteValueType_ValueType_List, 4).
-define(ozw_RemoteValueType_ValueType_Schedule, 5).
-define(ozw_RemoteValueType_ValueType_Short, 6).
-define(ozw_RemoteValueType_ValueType_String, 7).
-define(ozw_RemoteValueType_ValueType_Button, 8).
-define(ozw_RemoteValueType_ValueType_Max, 8).

-define(ozw_DriverControllerCommand_ControllerCommand_None, 0).
-define(ozw_DriverControllerCommand_ControllerCommand_AddController, 1).
-define(ozw_DriverControllerCommand_ControllerCommand_AddDevice, 2).
-define(ozw_DriverControllerCommand_ControllerCommand_CreateNewPrimary, 3).
-define(ozw_DriverControllerCommand_ControllerCommand_ReceiveConfiguration, 4).
-define(ozw_DriverControllerCommand_ControllerCommand_RemoveController, 5).
-define(ozw_DriverControllerCommand_ControllerCommand_RemoveDevice, 6).
-define(ozw_DriverControllerCommand_ControllerCommand_RemoveFailedNode, 7).
-define(ozw_DriverControllerCommand_ControllerCommand_HasNodeFailed, 8).
-define(ozw_DriverControllerCommand_ControllerCommand_ReplaceFailedNode, 9).
-define(ozw_DriverControllerCommand_ControllerCommand_TransferPrimaryRole, 10).
-define(ozw_DriverControllerCommand_ControllerCommand_RequestNetworkUpdate, 11).
-define(ozw_DriverControllerCommand_ControllerCommand_RequestNodeNeighborUpdate, 12).
-define(ozw_DriverControllerCommand_ControllerCommand_AssignReturnRoute, 13).
-define(ozw_DriverControllerCommand_ControllerCommand_DeleteAllReturnRoutes, 14).
-define(ozw_DriverControllerCommand_ControllerCommand_CreateButton, 15).
-define(ozw_DriverControllerCommand_ControllerCommand_DeleteButton, 16).

%% struct remoteValueID

-record(remoteValueID, {_homeId = undefined :: integer(), 
                        _nodeId = undefined :: integer(), 
                        _genre = undefined :: integer(), 
                        _commandClassId = undefined :: integer(), 
                        _instance = undefined :: integer(), 
                        _valueIndex = undefined :: integer(), 
                        _type = undefined :: integer()}).

%% struct driverData

-record(driverData, {s_SOFCnt = undefined :: integer(), 
                     s_ACKWaiting = undefined :: integer(), 
                     s_readAborts = undefined :: integer(), 
                     s_badChecksum = undefined :: integer(), 
                     s_readCnt = undefined :: integer(), 
                     s_writeCnt = undefined :: integer(), 
                     s_CANCnt = undefined :: integer(), 
                     s_NAKCnt = undefined :: integer(), 
                     s_ACKCnt = undefined :: integer(), 
                     s_OOFCnt = undefined :: integer(), 
                     s_dropped = undefined :: integer(), 
                     s_retries = undefined :: integer(), 
                     s_controllerReadCnt = undefined :: integer(), 
                     s_controllerWriteCnt = undefined :: integer()}).

%% struct getDriverStatisticsReturnStruct

-record(getDriverStatisticsReturnStruct, {_data = #driverData{} :: #driverData{}}).

%% struct getSwitchPointReturnStruct

-record(getSwitchPointReturnStruct, {retval = undefined :: boolean(), 
                                     o_hours = undefined :: integer(), 
                                     o_minutes = undefined :: integer(), 
                                     o_setback = undefined :: integer()}).

%% struct bool_Bool

-record(bool_Bool, {retval = undefined :: boolean(), 
                    o_value = undefined :: boolean()}).

%% struct bool_UInt8

-record(bool_UInt8, {retval = undefined :: boolean(), 
                     o_value = undefined :: integer()}).

%% struct bool_Float

-record(bool_Float, {retval = undefined :: boolean(), 
                     o_value = undefined :: float()}).

%% struct bool_Int

-record(bool_Int, {retval = undefined :: boolean(), 
                   o_value = undefined :: integer()}).

%% struct bool_Int16

-record(bool_Int16, {retval = undefined :: boolean(), 
                     o_value = undefined :: integer()}).

%% struct bool_String

-record(bool_String, {retval = undefined :: boolean(), 
                      o_value = undefined :: string()}).

%% struct bool_ListString

-record(bool_ListString, {retval = undefined :: boolean(), 
                          o_value = [] :: list()}).

%% struct uInt32_ListByte

-record(uInt32_ListByte, {retval = undefined :: integer(), 
                          _nodeNeighbors = [] :: list()}).

%% struct bool_GetNodeClassInformation

-record(bool_GetNodeClassInformation, {retval = undefined :: boolean(), 
                                       _className = undefined :: string(), 
                                       _classVersion = undefined :: integer()}).

%% struct getAssociationsReturnStruct

-record(getAssociationsReturnStruct, {retval = undefined :: integer(), 
                                      o_associations = [] :: list()}).

%% struct getAllScenesReturnStruct

-record(getAllScenesReturnStruct, {retval = undefined :: integer(), 
                                   _sceneIds = [] :: list()}).

%% struct sceneGetValuesReturnStruct

-record(sceneGetValuesReturnStruct, {retval = undefined :: integer(), 
                                     o_value = [] :: list()}).

-endif.
