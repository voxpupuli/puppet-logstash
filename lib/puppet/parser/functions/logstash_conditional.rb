#
# logstah_conditional.rb
#
module Puppet::Parser::Functions
  newfunction(:logstash_conditional, :type => :rvalue, :doc => <<-EOS

      Documentation todo

    EOS
  ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "logstash_conditional(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    # Resolve Condition(s)
    conditions = arguments[0]

    # Check for second argument, delimiter
    if arguments[1]
      delimiter = arguments[1]
    else
      delimiter = "and"
    end

    # Todo: add additional param validation

    # Handle array/string variance
    if conditions.kind_of?(Array)
      conditions = conditions.join(" #{delimiter} ")
    end

    # Done
    return "if #{conditions} {"

  end
end
