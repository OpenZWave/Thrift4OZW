# a Thrift server generator for OpenZWave
# transform a server skeleton file into a fully operational server
# a.k.a. "fills in the blanks for you"
#
# (c) 2011 Elias Karakoulakis <elias.karakoulakis@gmail.com>
#
require 'rubygems'
require 'rbgccxml'

OverloadedRE = /([^_]*)(?:_(.*))/

MANAGER_INCLUDES = [
    "gen_cpp",
    "/usr/local/include/thrift/",
    "/home/ekarak/ozw/open-zwave-read-only/cpp/tinyxml",
    "/home/ekarak/ozw/open-zwave-read-only/cpp/src",
    "/home/ekarak/ozw/open-zwave-read-only/cpp/src/value_classes",
    "/home/ekarak/ozw/open-zwave-read-only/cpp/src/command_classes",
    "/home/ekarak/ozw/open-zwave-read-only/cpp/src/platform",
]

#
# must load all source files in a single batch (RbGCCXML gets confused otherwise...)
#
files = [
    "/home/ekarak/ozw/thrift4ozw/gen-cpp/RemoteManager_server.skeleton.cpp",
    "/home/ekarak/ozw/open-zwave-read-only/cpp/src/Manager.cpp"
]
puts "Parsing:" + files.join("\n\t")
RootNode = RbGCCXML.parse(files, :includes => MANAGER_INCLUDES)

# read skeleton file in memory as an array
output = File.open("gen-cpp/RemoteManager_server.skeleton.cpp").readlines

def ValueID_converter(arg)
    return  "*g_values[#{arg}]"
end

# fix the constructor
lineno = RootNode.classes("RemoteManagerHandler").constructors[1]['line'].to_i
#~ output[lineno] = Constructor
# add our extra hidden sauce
#lineno = foo.classes("RemoteManagerHandler").constructors[1]['endline'].to_i
#output[lineno] = Converter

RootNode.classes("RemoteManagerHandler").methods.each { |meth|
    # find line number, insert critical section enter code
    lineno = meth['line'].to_i
    #puts "Method #{meth.name} at line #{lineno}-------------------------"
    output[lineno] = "\tManager* mgr = Manager::Get();\n\tg_criticalSection.lock();\n"
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
    
    puts "CREATING MAPPING for (#{meth.return_type.to_cpp}) #{meth.name}"

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
    #   ozw_types.h:class Bool_ListString { 
    #       bool retval; 
    #       std::vector<std::string>  arg;
    #   }
    #
    
    # is the skeleton function's return type composite?
    composite_return = false
    function_return_clause = ''
    returnarg = nil
    
    # gather all required arguments
    # key = target_method_argument (RbGCCXML::Node)
    # value => source argument cpp definition (string) - e.g. "(cast) argname"
    
    #arr = target_method.arguments.map {|tma| meth.arguments.select { |a| a.name == tma.name}[0]}
    
    args = {} # target node => source node
    target_method.arguments.each {|tma| args[tma] = meth.arguments.select { |a| a.name == tma.name}[0]}

    #
    # create the function call
    #
    arg_array = []
    #
    args.each { |tgt_arg, src_arg|
        puts "tgt=#{tgt_arg.to_cpp}, src=#{src_arg and src_arg.qualified_name}"
        ampersand = (tgt_arg.cpp_type.to_cpp.include?('*') ? '&' : '')
        if src_arg then # argument names matched
            # maybe it's an OpenZWave::ValueID ???
            if (tgt_arg.to_cpp =~ /ValueID/) then
                arg_array << ValueID_converter(src_arg.name)
            else 
                arg_array << "(#{tgt_arg.cpp_type.to_cpp}) #{ampersand}#{src_arg.name}"
            end
        else # source argument not found by name, search elsewhere
            puts "method #{meth.name}, argument #{tgt_arg.name} not found by name..."
            # 1) try searching through thrift's special '_return' argument (if there is one)
            if (returnarg = meth.arguments.select{ |a| a.name == "_return"}[0]).is_a?(RbGCCXML::Argument) then
                puts "Thrift special _return argument detected!"
                last_argument_type = target_method.arguments[-1].cpp_type.to_cpp
                if md = OverloadedRE.match(returnarg.cpp_type.to_cpp)  then
                    # ...and it's a complex type (Thrift struct)
                    # 1st match is the function's return type
                    composite_return = true
                    function_return_clause = " _return.retval = "
                    # 2nd match is function's last argument type
                    arg_array << "(#{last_argument_type}) #{ampersand}_return#{composite_return ? '.arg' : ''}"
                else
                    function_return_clause = " _return = "
                    # _return is a simple data type
                    arg_array << "(#{last_argument_type}) #{ampersand}_return"
                end            
            else
                puts "WARNING:: estimated argument '#{tgt_arg.name}' in method '#{meth.name}'!!!"
                arg_array << "(#{tgt_arg.cpp_type.to_cpp}) #{ampersand}_return.arg"
            end
        end
    }

    # unleash the beast
    fcall = "#{function_return_clause} mgr->#{target_method.name}(#{arg_array.join(', ')})"

    #
    # FUNCTION RETURN CLAUSE
    #
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
# write out the generated file
File.new("gen-cpp/RemoteManager_server.cpp", File::CREAT|File::TRUNC|File::RDWR, 0644) << output.join
