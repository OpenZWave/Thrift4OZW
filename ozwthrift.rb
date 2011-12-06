require "thrift"
$:.push("/home/ekarak/ozw/thrift4ozw/gen-rb")
require "ozw_constants"
require "remote_manager"

port = 9090
HomeID = 0x00006258

transport = Thrift::BufferedTransport.new(Thrift::Socket.new('localhost', port))
protocol = Thrift::BinaryProtocol.new(transport)
transport.open()

OZWmgr = OpenZWave::RemoteManager::Client.new(protocol)
#OZWmgr.SetNodeOff(HomeID, 2)

OZWmgr.GetNodeNeighbors(HomeID,1)

