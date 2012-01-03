require 'rubygems'
require 'onstomp'
require 'bit-struct'

require 'ozw-headers'
require 'zwave-command-classes'

cpp_src = "/home/ekarak/ozw/open-zwave-read-only/cpp/src"
notificationtypes, valuegenres, valuetypes = parse_ozw_headers(cpp_src) # in ozw-headers.rb

#~ // ID Packing:
#~ // Bits
#~ // 24-31:	8 bits. Node ID of device
#~ // 22-23:	2 bits. genre of value (see ValueGenre enum).
#~ // 14-21:	8 bits. ID of command class that created and manages this value.
#~ // 12-13:	2 bits. Unused.
#~ // 04-11:	8 bits. Index of value within all the value created by the command class
#~ //                  instance (in configuration parameters, this is also the parameter ID).
#~ // 00-03:	4 bits. Type of value (bool, byte, string etc).
class OZW_EventID_id < BitStruct
    unsigned    :node_id,       8, "Node ID of device"
    unsigned    :value_genre,   2, "Value Genre"
    unsigned    :cmd_class,     8, "command class"
    unsigned    :unused1,       2, "(unused)"
    unsigned    :value_idx,     8, "value index"
    unsigned    :value_type,    4, "value type( bool, byte, string etc)"
end

#~ // ID1 Packing:
#~ // Bits
#~ // 24-31	8 bits. Instance Index of the command class.
class OZW_EventID_id1 < BitStruct
    unsigned    :cmd_class_idx, 8, "cmd class index"
    unsigned    :unused2   , 24, "(unused)"    
end


val = "0x1000000 05 49 80 01"
id = [val.delete(' ')[-8..-1].to_i(16)].pack("N")
id1 = [val.delete(' ')[0..-9].to_i(16)].pack("N")
#
b = OZW_EventID_id.new(id)
#puts b.inspect_detailed
puts "  node ID of device: #{b.node_id}"
puts "        value genre: #{valuegenres[b.value_genre.to_i].join(': ')}"
puts "         value type: #{valuetypes[b.value_type.to_i].join(': ')}"
puts "          value idx: #{b.value_idx}"
puts "      command class: #{CommandClassesByID[b.cmd_class]}"
b = OZW_EventID_id1.new(id1)
puts "     subcommand idx: #{b.cmd_class_idx}"