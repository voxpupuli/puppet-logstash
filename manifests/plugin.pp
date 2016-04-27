# Manage the installation of a Logstash plugin.
#
# By default, plugins are downloaded from RubyGems, but it is also possible
# to install from a local Gem.
#
# @example install a plugin
#   logstash::plugin { 'logstash-input-stdin': }
#
# @example remove a plugin
#   logstash::plugin { 'logstash-input-stout':
#     ensure => absent
#   }
#
# @example install a plugin from a local file
#   logstash::plugin { 'logstash-input-custom':
#     source => 'file:///tmp/logstash-input-custom.gem'
#   }
#
# @example install a plugin from a file on the puppetmaster
#   logstash::plugin { 'logstash-input-custom':
#     source => 'puppet:///plugin-module/logstash-input-custom.gem'
#   }
#
# @param source [String] install from this file, not from RubyGems.
#
define logstash::plugin (
  $source = undef,
  $ensure = present,
)
{
  require logstash

  case $ensure {
    present: {
      exec { "install-logstash-plugin-${name}":
        command => "/opt/logstash/bin/plugin install ${name}"
      }
    }

    absent:  {

    }

    default: {
      fail "The parameter 'ensure' should be either 'present' or 'absent'."
    }
  }
}
