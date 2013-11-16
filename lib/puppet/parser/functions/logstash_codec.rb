#
# logstah_codec.rb
#
module Puppet::Parser::Functions
  newfunction(:logstash_codec, :type => :rvalue, :doc => <<-EOS

      Documentation todo

    EOS
  ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "logstash_codec(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    # Resolve Codec
    codec = arguments[0].downcase

    # Evaluate Codec
    case codec
      when "dots", "graphite", "json", "json_lines", "json_spooler", "line", "msgpack", "multiline", "netflow", "noop", "oldlogstashjson", "plain", "rubydebug", "spool"
      else
        Puppet::Error.new( "Invalid logstash codec: '#{codec}'" )
    end

    # Todo: add additional param validation

    # Start the string
    ret = "#{codec} {"

    # Parse params
    if arguments[1]
      arguments[1].each do |field, val|
        ret << "\n    #{field} => '#{val}'"
      end
      ret << "\n   }"
    else
      ret << "}"
    end

    # Done
    return ret

  end
end
