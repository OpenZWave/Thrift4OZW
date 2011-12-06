homeId = 0x00006258

rvid = OpenZWave::RemoteValueID.new
rvid._homeId  = homeId
rvid._nodeId = 2
rvid._genre = OpenZWave::RemoteValueGenre::ValueGenre_Basic
rvid._type = OpenZWave::RemoteValueType::ValueType_Bool
rvid._instance = 0
rvid._valueIndex = 0
rvid._commandClassId = 0


OZWmgr.SwitchNodeOn(homeId, 2)