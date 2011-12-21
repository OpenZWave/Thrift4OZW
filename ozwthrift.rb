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
puts OZWmgr.inspect

#OZWmgr.GetNodeNeighbors(HomeID,1)

#~ OZWmgr.SetNodeOff(HomeID, 5)

Rvid = OpenZWave::RemoteValueID.new
Rvid._homeId  = HomeID
Rvid._nodeId = 5
Rvid._genre = 1 # OpenZWave::RemoteValueGenre::ValueGenre_User
Rvid._type = 1 # OpenZWave::RemoteValueType::ValueType_Byte
Rvid._instance = 1
Rvid._valueIndex = 0
Rvid._commandClassId = 38

OZWmgr.GetValueAsByte(Rvid)