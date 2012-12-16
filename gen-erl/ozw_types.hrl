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

-record(remoteValueID, {_homeId :: integer(),
                        _nodeId :: integer(),
                        _genre :: integer(),
                        _commandClassId :: integer(),
                        _instance :: integer(),
                        _valueIndex :: integer(),
                        _type :: integer()}).

%% struct driverData

-record(driverData, {s_SOFCnt :: integer(),
                     s_ACKWaiting :: integer(),
                     s_readAborts :: integer(),
                     s_badChecksum :: integer(),
                     s_readCnt :: integer(),
                     s_writeCnt :: integer(),
                     s_CANCnt :: integer(),
                     s_NAKCnt :: integer(),
                     s_ACKCnt :: integer(),
                     s_OOFCnt :: integer(),
                     s_dropped :: integer(),
                     s_retries :: integer(),
                     s_controllerReadCnt :: integer(),
                     s_controllerWriteCnt :: integer()}).

%% struct getDriverStatisticsReturnStruct

-record(getDriverStatisticsReturnStruct, {_data :: #driverData{}}).

%% struct commandClassData

-record(commandClassData, {m_commandClassId :: integer(),
                           m_sentCnt :: integer(),
                           m_receivedCnt :: integer()}).

%% struct nodeData

-record(nodeData, {m_sentCnt :: integer(),
                   m_sentFailed :: integer(),
                   m_retries :: integer(),
                   m_receivedCnt :: integer(),
                   m_receivedDups :: integer(),
                   m_rtt :: integer(),
                   m_sentTS :: string() | binary(),
                   m_receivedTS :: string() | binary(),
                   m_lastRTT :: integer(),
                   m_averageRTT :: integer(),
                   m_quality :: integer(),
                   m_lastReceivedMessage :: list(),
                   m_ccData :: list()}).

%% struct getNodeStatisticsReturnStruct

-record(getNodeStatisticsReturnStruct, {_data :: #nodeData{}}).

%% struct getSwitchPointReturnStruct

-record(getSwitchPointReturnStruct, {retval :: boolean(),
                                     o_hours :: integer(),
                                     o_minutes :: integer(),
                                     o_setback :: integer()}).

%% struct bool_Bool

-record(bool_Bool, {retval :: boolean(),
                    o_value :: boolean()}).

%% struct bool_UInt8

-record(bool_UInt8, {retval :: boolean(),
                     o_value :: integer()}).

%% struct bool_Float

-record(bool_Float, {retval :: boolean(),
                     o_value :: float()}).

%% struct bool_Int

-record(bool_Int, {retval :: boolean(),
                   o_value :: integer()}).

%% struct bool_Int16

-record(bool_Int16, {retval :: boolean(),
                     o_value :: integer()}).

%% struct bool_String

-record(bool_String, {retval :: boolean(),
                      o_value :: string() | binary()}).

%% struct bool_ListString

-record(bool_ListString, {retval :: boolean(),
                          o_value :: list()}).

%% struct uInt32_ListByte

-record(uInt32_ListByte, {retval :: integer(),
                          _nodeNeighbors :: list()}).

%% struct bool_GetNodeClassInformation

-record(bool_GetNodeClassInformation, {retval :: boolean(),
                                       _className :: string() | binary(),
                                       _classVersion :: integer()}).

%% struct getAssociationsReturnStruct

-record(getAssociationsReturnStruct, {retval :: integer(),
                                      o_associations :: list()}).

%% struct getAllScenesReturnStruct

-record(getAllScenesReturnStruct, {retval :: integer(),
                                   _sceneIds :: list()}).

%% struct sceneGetValuesReturnStruct

-record(sceneGetValuesReturnStruct, {retval :: integer(),
                                     o_value :: list()}).

-endif.
