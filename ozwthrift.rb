=begin
Thrift4OZW - An Apache Thrift wrapper for OpenZWave
----------------------------------------------------
Copyright (c) 2011 Elias Karakoulakis <elias.karakoulakis@gmail.com>

SOFTWARE NOTICE AND LICENSE

Thrift4OZW is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

Thrift4OZW is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Thrift4OZW.  If not, see <http://www.gnu.org/licenses/>.

for more information on the LGPL, see:
http://en.wikipedia.org/wiki/GNU_Lesser_General_Public_License
=end

# --------------------------
#
# ozwthrift.rb: an Ruby client example for Thrift4OZW
# shows most basic usage, lacks connection control and other goodies
#
# ---------------------------

require "onstomp"
require "thrift"

# load Thrift-generated client code
$:.push(File.join(Dir.getwd, 'gen-rb'))
require "ozw_constants"
require "remote_manager"

# load the ZWave monitor
require 'ozw-monitor'

port = 9090
  
transport = Thrift::BufferedTransport.new(Thrift::Socket.new('localhost', port))
protocol = Thrift::BinaryProtocol.new(transport)
transport.open()

OZWmgr = OpenZWave::RemoteManager::Client.new(protocol)
puts OZWmgr.inspect

#OZWmgr.GetNodeNeighbors(HomeID, 1)

#OZWmgr.SetNodeOff(HomeID, 5)
