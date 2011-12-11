
OZWmgr.SwitchNodeOn(homeId, 2)

OZWmgr.SetNodeOff(HomeID, 5)

Rvid = OpenZWave::RemoteValueID.new
Rvid._homeId  = HomeID
Rvid._nodeId = 5
Rvid._genre = 0 # OpenZWave::RemoteValueGenre::ValueGenre_Basic
Rvid._type = 1 # OpenZWave::RemoteValueType::ValueType_Byte
Rvid._instance = 1
Rvid._valueIndex = 0
Rvid._commandClassId = 32

irb(main):019:0> OZWmgr.GetValueAsByte(Rvid)
=> <OpenZWave::Bool_UInt8 retval:true, o_value:44>
irb(main):020:0> OZWmgr.GetValueAsString(Rvid)
=> <OpenZWave::Bool_String retval:true, o_value:"44">
