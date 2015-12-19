import ctypes
import RemoteManager

_DEFAULT_COMMAND_CLASS_ID = 0x25 # COMMAND_CLASS_SWITCH_BINARY
_DEFAULT_INSTANCE_ID = 1
_DEFAULT_VALUE_INDEX = 0
_DEFAULT_TYPE = RemoteManager.RemoteValueType.ValueType_Bool

def unpackValueID(homeId, valueId):
	"""Convert a value ID to a RemoveValueID

	This conversion has a reference implementation at
	https://github.com/OpenZWave/open-zwave/blob/master/cpp/src/value_classes/ValueID.h."""
	return RemoteManager.RemoteValueID(
			_homeId=ctypes.c_int32(homeId).value,
			_nodeId=(valueId & 0xFF000000) >> 24,
			_genre=(valueId & 0x00C00000) >> 22,
			_commandClassId=(valueId & 0x003FC000) >> 14,
			_instance=(valueId & 0xFF00000000000000) >> 56,
			_valueIndex=(valueId & 0x00000FF0) >> 4,
			_type=valueId & 0x0000000F)

def getSwitchValueID(homeId, nodeId):
	"""Create a value ID from the node ID of a switch"""
	return RemoteManager.RemoteValueID(
			_homeId=ctypes.c_int32(homeId).value,
			_nodeId=nodeId,
			_genre=RemoteManager.RemoteValueGenre.ValueGenre_User,
			_commandClassId=_DEFAULT_COMMAND_CLASS_ID,
			_instance=_DEFAULT_INSTANCE_ID,
			_valueIndex=_DEFAULT_VALUE_INDEX,
			_type=_DEFAULT_TYPE)
