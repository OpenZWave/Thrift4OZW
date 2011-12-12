require "thrift"
$:.push(File.join(Dir.getwd, 'gen-rb'))
require "ozw_constants"
require "remote_manager"

port = 9090
HomeID = 0x00006258

transport = Thrift::BufferedTransport.new(Thrift::Socket.new('localhost', port))
protocol = Thrift::BinaryProtocol.new(transport)
transport.open()

OZWmgr = OpenZWave::RemoteManager::Client.new(protocol)

#OZWmgr.GetNodeNeighbors(HomeID,1)

#~ OZWmgr.SetNodeOff(HomeID, 5)

Rvid = OpenZWave::RemoteValueID.new
Rvid._homeId  = HomeID
Rvid._nodeId = 5
Rvid._genre = 0 # OpenZWave::RemoteValueGenre::ValueGenre_Basic
Rvid._type = 1 # OpenZWave::RemoteValueType::ValueType_Byte
Rvid._instance = 1
Rvid._valueIndex = 0
Rvid._commandClassId = 32

#~ OZWmgr.GetValueAsByte(Rvid)