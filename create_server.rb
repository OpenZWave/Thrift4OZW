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
# create_server.rb: a Thrift server generator for OpenZWave
# transform a server skeleton file into a fully operational server
# a.k.a. "fills in the blanks for you"
#
# ---------------------------

require 'rubygems'
require 'rbgccxml'

OZWCpp = '/home/ekarak/ozw/open-zwave-read-only/cpp'
ThriftInc = "/usr/local/include/thrift/"

require 'getoptlong'

GetoptLong.new(
  #[ "--ozwroot",    GetoptLong::REQUIRED_ARGUMENT ],
  [ "--ozwroot",    GetoptLong::OPTIONAL_ARGUMENT ],
  [ "--thriftroot",   GetoptLong::OPTIONAL_ARGUMENT ],
  [ "--verbose", "-v",   GetoptLong::NO_ARGUMENT ],
).each { |opt, arg|
    case opt
    when '--ozwroot' then OZWCpp = arg
    when '--thriftroot' then ThriftInc = arg
    when '--verbose' then $DEBUG = true
    end
}

OverloadedRE = /([^_]*)(?:_(.*))/

MANAGER_INCLUDES = [
    "gen_cpp",
    ThriftInc,
    File.join(OZWCpp, "tinyxml"),
    File.join(OZWCpp, "src"),
    File.join(OZWCpp, "src", "value_classes"),
    File.join(OZWCpp, "src", "command_classes"),
    File.join(OZWCpp, "src", "platform")
]

#
# must load all source files in a single batch (RbGCCXML gets confused otherwise...)
#
files = [
    File.join(Dir.getwd, "gen-cpp", "RemoteManager_server.skeleton.cpp"),
    File.join(OZWCpp, "src", "Manager.h")
]
puts "Parsing:" + files.join("\n\t")
RootNode = RbGCCXML.parse(files, :includes => MANAGER_INCLUDES)

# read skeleton file in memory as an array
output = File.open("gen-cpp/RemoteManager_server.skeleton.cpp").readlines


# fix the constructor
#lineno = RootNode.classes("RemoteManagerHandler").constructors[1]['line'].to_i
#~ output[lineno] = Constructor
# add our extra hidden sauce
#lineno = foo.classes("RemoteManagerHandler").constructors[1]['endline'].to_i
#output[lineno] = Converter

a = RootNode.classes("RemoteManagerHandler").methods.find(:access => :public)
b = RootNode.namespaces("OpenZWave").classes("Manager").methods.find(:access => :public)
puts "RemoteManagerHandler: #{a.entries.size} public methods, OpenZWave::Manager: #{b.entries.size} public methods"

RootNode.classes("RemoteManagerHandler").methods.each { |meth|
    # find line number, insert critical section enter code
    lineno = meth['line'].to_i
    #
    target_method = nil
    target_method_name = nil
    disambiguation_hint = nil
    
    # skeleton function's name has underscore => Overloaded. Needs disambiguation.
    if md = OverloadedRE.match(meth.name)  then
        target_method_name = md[1]
        disambiguation_hint = md[2]
    else
        target_method_name = meth.name
    end
    
    # 
    # SEARCH FOR MATCHING FUNCTION IN OPENZWAVE::MANAGER
    #
    search_result = RootNode.namespaces("OpenZWave").classes("Manager").methods.find(:name => target_method_name, :access => :public)
    #puts "search result: #{search_result.class.name}"
    case search_result
    when RbGCCXML::QueryResult then
        next if search_result.empty? # skip unknown functions (needed for "void SendAllValues()"
        raise "#{target_method_name}(): no disambiguation hint given!!!" unless disambiguation_hint
        #puts "  ...Overloaded method: #{meth.name}"
        search_result.each { |node|
            # last argument's type must match disambiguation_hint
            target_method = node if node.arguments[-1].cpp_type.to_cpp =~ Regexp.new(disambiguation_hint, Regexp::IGNORECASE)
            # FIXME:: ListString => list<string>
        }
    when RbGCCXML::Method then
        #puts "  ...exact match for #{meth.name}"
        target_method = search_result
    end
    
    raise "Unable to resolve target method! (#{meth.name})" unless target_method
    
    #
    # TIME TO BOOGEY
    #
    
    puts "CREATING MAPPING for (#{meth.return_type.to_cpp}) #{meth.name}" if $DEBUG

    #Thrift transforms methods with complex return types (string, vector<...>, user-defined structs etc)
    # example 1:
    #   (C++)       string GetLibraryVersion( uint32 const _homeId );
    #   (thrift)    string GetLibraryVersion( 1:i32 _homeId );
    #   (skeleton)  void GetLibraryVersion(std::string& _return, const int32_t _homeId)
    #
    # example 2:
    #   (C++)       uint32 GetNodeNeighbors( uint32 const _homeId, uint8 const _nodeId, uint8** _nodeNeighbors );
    #   (thrift)    UInt32_NeighborMap GetNodeNeighbors( 1:i32 _homeId, 2:byte _nodeId);
    #   (skeleton)  void GetNodeNeighbors(UInt32_ListByte& _return, const int32_t _homeId, const int8_t _nodeId)
    #   ozw_types.h: class UInt32_ListByte {
    #       int32_t retval;
    #       std::vector<int8_t>  arg; *** notice manual copying needed from C-style pointer to pointers of uint8's (not very C++ish)
    #   }
    #
    # example 3:
    #   (C++)       bool GetValueListItems( ValueID const& _id, vector<string>* o_value );
    #   (thrift)    Bool_ListString GetValueListItems( 1:RemoteValueID _id );
    #   (skeleton)  void GetValueListItems(Bool_ListString& _return, const RemoteValueID _id)
    # where the Thrift definition for Bool_ListString is:
    #   (ozw_types.h):class Bool_ListString { 
    #       bool retval; 
    #       std::vector<std::string>  arg;
    #   }
    #
    
    #
    # STEP 1. Map arguments from target (OpenZWave::Manager) to source (skeleton server)
    #
    argmap = {}  
        # KEY: target argument node
        # VALUE: hash with
        #       :descriptor => source argument DESCRIPTOR STRING (eg "_return._className")
        #       :node => the actual source argument node (Argument or Field)
    target_method.arguments.each {|a|   
        # 1) match directly by name
        if (arg = meth.arguments.find(:name => a.name )).is_a?RbGCCXML::Argument then
            argmap[a] = {}
            argmap[a][:descriptor] = arg.name
            argmap[a][:node] = arg
        # 2) else, match as a member of Thrift's special "_return" argument (class struct)
        elsif (_ret = meth.arguments.find(:name => "_return" )) and (_ret.cpp_type.base_type.is_a?RbGCCXML::Class) and
            (arg = _ret.cpp_type.base_type.variables.find(:name => a.name)).is_a?RbGCCXML::Field  then
            argmap[a] = {}
            argmap[a][:descriptor] = "_return.#{a.name}"
            argmap[a][:node] = arg
        else
            raise "Reverse argument mapping: couldn't resolve argument '#{a.name}' in method '#{target_method.name}'!!!"
        end
    }

    #
    # STEP 2.  Resolve the function call's return clause
    #
    function_return_clause = ''
    if (_return = meth.arguments.find(:name => '_return')).is_a?RbGCCXML::Argument then
        puts "Thrift special _return argument detected!" if $DEBUG
        if (_return.cpp_type.base_type.is_a?RbGCCXML::Class) and 
            (retval = _return.cpp_type.base_type.variables.find(:name => 'retval')) and
            (retval.is_a?RbGCCXML::Field)   then
                function_return_clause = "_return.retval = "
        else
            unless target_method.return_type.name == "void" then
                function_return_clause = "_return = "
            end
        end
    end

    #
    # STEP 3. Prepare argument array (ordered by target_method's argument order)
    #
    arg_array = []
    target_method.arguments.each { |tgt_arg|
        if (hsh = argmap[tgt_arg]) then
            src_arg = hsh[:node]
            descriptor = hsh[:descriptor]
            #puts "  src=#{descriptor}\ttgt=#{tgt_arg.qualified_name}"
            ampersand = (tgt_arg.cpp_type.to_cpp.include?('*') ? '&' : '')
            case src_arg.to_cpp
                when /RemoteValueID/
                    arg_array <<  "#{descriptor}.toValueID()"
                else
                    arg_array << "(#{tgt_arg.cpp_type.to_cpp}) #{ampersand}#{descriptor}"
                    size_src = src_arg.cpp_type.base_type['size'].to_i
                    size_tgt = tgt_arg.cpp_type.base_type['size'].to_i
                    # sanity check
                    puts "WARNING!!! method '#{meth.name}': Argument '#{descriptor}' size mismatch (src=#{size_src} tgt=#{size_tgt}) - CHECK GENERATED CODE!" unless size_src == size_tgt
            end
        end
    }
    
    # Get me the manager, and lock the criticalsection
    output[lineno] = "\tManager* mgr = Manager::Get();\n\tg_criticalSection.lock();\n"
    fcall = "#{function_return_clause} mgr->#{target_method.name}(#{arg_array.compact.join(', ')})"
    case meth.return_type.name 
    when "void"
        output[lineno+1] =  "\t#{fcall};\n"
    else
        output[lineno+1] = "\t#{meth.return_type.to_cpp} function_result = #{fcall};\n"
    end
    # unlock the critical section
    output[lineno+1] << "\tg_criticalSection.unlock();\n" 
    # output return statement (unless rettype == void)
    unless meth.return_type.name == "void"
        output[lineno+1] << "\treturn(function_result);\n"
    end

}

output[0] = "// Automatically generated OpenZWave::Manager_server wrapper\n"
output[1] = "// (c) 2011 Elias Karakoulakis <elias.karakoulakis@gmail.com>\n"
# comment out main()
((RootNode.functions("main")["line"].to_i-1)..(output.size)).each{ |i|
    output[i] = "// #{output[i]}"
}
# write out the generated file
puts "Writing generated server...."
File.new("gen-cpp/RemoteManager_server.cpp", File::CREAT|File::TRUNC|File::RDWR, 0644) << output.join
puts "Done!"