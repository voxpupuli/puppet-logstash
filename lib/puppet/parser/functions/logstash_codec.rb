module Puppet::Parser::Functions
  newfunction(:logstash_codec, :type => :rvalue, :doc => <<-EOS
  Logstash codec function
    EOS
  ) do |arguments|

    # We only expect maximum of 2 arguments.
    raise(Puppet::ParseError, "logstash_codec(): Wrong number of arguments given (#{arguments.size} given)") if arguments.size > 2

    codec_name = arguments[0]
    codec_config = arguments[1]

    # First argument is the codec name, this has to be a string
    unless codec_name.is_a?(String)
      raise(Puppet::ParseError, "logstash_codec(): Codec name requires to be a String")
    end

    # Second argument is the coded config, this has to be a hash.
    unless codec_config.nil? and codec_config.is_a?(Hash)
      raise(Puppet::ParseError, "logstash_codec(): Codec config requires to be a Hash")
    end

    case codec_name

      when 'compress_spooler'
        # spool_size - number
	unless codec_config['spool_size'].nil? and codec_config['spool_size'].is_a?(Number)
          opt_spool_size = "\t  spool_size => #{codec_config['spool_size']}\n"
        end

        # compress_level - number
        unless codec_config['compress_level'].nil? and codec_config['compress_level'].is_a?(Number)
          opt_spool_size = "\t  compress_level => #{codec_config['compress_level']}\n"
        end


        opts_codec = "#{opt_spool_size}"

      when 'dots'
        # No config

      when 'edn'
        # No config

      when 'fluent'
        # No config

      when 'graphite'
        # charset - String
        unless codec_config['charset'].nil? and codec_config['charset'].is_a?(String)
          if [ 'UTF-8', 'bla', 'bla2', 'bla3' ].include?(codec_config['charset'])
            opt_charset = "\t  charset => #{codec_config['charset']}\n"
          end
        end

        # metrics - hash
        unless codec_config['metrics'].nil? and codec_config['metrics'].is_a?(Hash)
            opt_metrics = "\t  metrics => #{codec_config['metrics']}\n"
        end

        # fields_are_metrics - bool
         unless codec_config['fields_are_metrics'].nil? and codec_config['fields_are_metrics'].is_a?(Bool)
            opt_fields_are_metrics = "\t  fields_are_metrics => #{codec_config['fields_are_metrics']}\n"
        end

        # include_metrics - array
        unless codec_config['include_metrics'].nil? and codec_config['include_metrics'].is_a?(Array)
            opt_include_metrics = "\t  include_metrics => #{codec_config['include_metrics']}\n"
        end

        # exclude_metrics - array
        unless codec_config['exclude_metrics'].nil? and codec_config['exclude_metrics'].is_a?(Array)
            opt_exclude_metrics = "\t  exclude_metrics => #{codec_config['exclude_metrics']}\n"
        end

        # metrics_format - string
        unless codec_config['metrics_format'].nil? and codec_config['metrics_format'].is_a?(String)
            opt_metrics_format = "\t  metrics_format => #{codec_config['metrics_format']}\n"
        end

        opt_codec = "#{opt_charset}#{opt_metrics}#{opt_fields_are_metrics}#{opt_include_metrics}#{opt_exclude_metrics}#{opt_metrics_format}"

      when 'json'
        unless codec_config['charset'].nil? and codec_config['charset'].is_a?(String)
          if [ 'UTF-8', 'bla', 'bla2', 'bla3' ].include?(codec_config['charset'])
            opt_charset = "\t  charset => #{codec_config['charset']}\n"
          end
        end

      opt_codec = "#{opt_charset}"

      when 'json_lines'
        unless codec_config['charset'].nil? and codec_config['charset'].is_a?(String)
          if [ 'UTF-8', 'bla', 'bla2', 'bla3' ].include?(codec_config['charset'])
            opt_charset = "\t  charset => #{codec_config['charset']}\n"
          end
        end

      opt_codec = "#{opt_charset}"

      when 'json_spooler'

        # spool_size - number
        unless codec_config['spool_size'].nil? and codec_config['spool_size'].is_a?(Number)
          opt_spool_size = "\t  spool_size => #{codec_config['spool_size']}\n"
        end

        opts_codec = "#{opt_spool_size}"

      when 'line'

        unless codec_config['format'].nil? and codec_config['format'].is_a?(String)
            opt_format = "\t  format => #{codec_config['format']}\n"
        end

        unless codec_config['charset'].nil? and codec_config['charset'].is_a?(String)
          if [ 'UTF-8', 'bla', 'bla2', 'bla3' ].include?(codec_config['charset'])
            opt_charset = "\t  charset => #{codec_config['charset']}\n"
          end
        end

      opt_codec = "#{opt_format}#{opt_charset}"

      when 'msgpack'

        # format - string
        unless codec_config['format'].nil? and codec_config['format'].is_a?(String)
          opt_format = "\t  format => #{codec_config['format']}\n"
        end

        opts_codec = "#{opt_format}"

      when 'multiline'

        # pattern - string
        unless codec_config['pattern'].nil? and codec_config['pattern'].is_a?(String)
          opt_pattern = "\t  pattern => #{codec_config['pattern']}\n"
        end

        # what - previous / next
        unless codec_config['what'].nil? and codec_config['what'].is_a?(String)
          if ['previous', 'next' ].include?(codec_config['what'])
            opt_what = "\t  what => #{codec_config['what']}\n"
          end
        end

        # negate - boolean
        unless codec_config['negate'].nil? and codec_config['negate'].is_a?(Bool)
          opt_negate = "\t  negate => #{codec_config['negate']}\n"
        end

       # patterns_dir - array
        unless codec_config['patterns_dir'].nil? and codec_config['patterns_dir'].is_a(Array)
          patterns_dir = codec_config['patterns_dir'].join("', '")
          opt_format = "\t  patterns_dir => ['"+patterns_dir+"']\n"
        end

        # charset - list
        unless codec_config['charset'].nil? and codec_config['charset'].is_a?(String)
          if [ 'UTF-8', 'bla', 'bla2', 'bla3' ].include?(codec_config['charset'])
            opt_charset = "\t  charset => #{codec_config['charset']}\n"
          end
        end

        # multiline_tag - string
        unless codec_config['multiline_tag'].nil? and codec_config['multiline_tag'].is_a?(String)
            opt_multiline_tag = "\t  multiline_tag => #{codec_config['multiline_tag']}\n"
        end

        opts_codec = "#{opt_pattern}#{opt_what}#{opt_negate}#{opt_format}#{opt_charset}#{opt_multiline_tag}"

      when 'netflow'
        # cache_ttl - number
        unless codec_config['cache_ttl'].nil? and codec_config['cache_ttl'].is_a?(Number)
            opt_cache_ttl = "\t  cache_ttl => #{codec_config['cache_ttl']}\n"
        end

        # target - string
         unless codec_config['target'].nil? and codec_config['target'].is_a?(String)
            opt_target = "\t  target => #{codec_config['target']}\n"
        end
       
	# version - list
        unless codec_config['version'].nil? and codec_config['version'].is_a?(Number)
          if [ '5', '9' ].include?(codec_config['version'])
            opt_version = "\t  version => #{codec_config['version']}\n"
          end
        end

        opt_codec = "#{opt_cache_ttl}#{opt_target}#{opt_version}"

      when 'noop'
        # No config

      when 'oldlogstashjson'
        # No config

      when 'plain'

        unless codec_config['format'].nil?
          opt_format = "\t  format => #{codec_config['format']}\n"
        end

        unless codec_config['charset'].nil?
          if [ 'UTF-8', 'bla', 'bla2', 'bla3' ].include?(codec_config['charset'])
            opt_charset = "\t  charset => #{codec_config['charset']}\n"
          end
        end

        opts_codec = "#{opt_format}#{opt_charset}"

      when 'rubydebug'
        # No config

      when 'spool'
        # spool_size - number
        unless codec_config['spool_size'].nil? and codec_config['spool_size'].is_a?(Number)
          opt_spool_size = "\t  spool_size => #{codec_config['spool_size']}\n"
        end

        opts_codec = "#{opt_spool_size}"
       
      else
        # We have an invalid codec name
        raise(Puppet::ParseError, "#{codec_name} is not a valid codec name")

    end # case codec_name

    opts = "\n#{opts_codec}\t" unless opts_codec.nil?
    result = "#{codec_name} {#{opts}}"
    return result

  end # do |arguments|

end
