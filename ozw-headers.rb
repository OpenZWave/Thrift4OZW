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

# a generic Rexegp to parse C/C++ enums, must substitute %s in-place with enumeration name
ENUM_RE = %q(.* 
    enum \s* %s \s* 
    \{  
        ([^\{\}]*) 
    \}\;
)
# and the secondary regexp to parse enumeration items
# e.g.      			   Type_ValueChanged,	        /**< A node value has been updated from the Z-Wave network. */
ENUM_RE_LINE = /^ \s*  ([a-z_]+)  (\s*=\s*)* (\d*)  .*  \/\*\*\< \s (.*) \s \*\/$/ix
#                        md[1]      md[2]    md[3]                  md[4]  
#                       item name     =   default_index     textual_description

def parse_ozw_headers(cpp_src)
    notificationtypes, valuegenres, valuetypes = [], [], []
    [   
        [File.join(cpp_src, "Notification.h"), "NotificationType", notificationtypes],
        [File.join(cpp_src, "value_classes", "ValueID.h"), "ValueGenre", valuegenres],
        [File.join(cpp_src, "value_classes", "ValueID.h"), "ValueType", valuetypes]
    ].each { | headerfile, enum_name, enum_array |
        puts "Parsing #{headerfile} for enum #{enum_name}..."
        #~ puts enum_re % enum_name
        foo = File.open(headerfile).read
        if enum = Regexp.new(ENUM_RE % enum_name,  Regexp::EXTENDED | Regexp::IGNORECASE | Regexp::MULTILINE).match(foo) then
            index = 0
            #~ puts enum[1]
            #~ puts '-----------------'
            enum[1].each { |line|
                if md = ENUM_RE_LINE.match(line) then
                    #puts md[1..-1].inspect
                    index =  (md[2] and md[3].length > 0) ? md[3].to_i : index+1
                    key, value = md[1], md[4]
                    enum_array[index] = [key, value]
                    #puts "#{enum_name}[#{index}] = [#{key}, #{value}]"
                end
            }
        end
    }
    return notificationtypes, valuegenres, valuetypes
end
