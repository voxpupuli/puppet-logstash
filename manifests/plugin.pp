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
  $exe = '/opt/logstash/bin/plugin'

  if($source) {
    $plugin = $source
  }
  else {
    $plugin = $name
  }

  case $ensure {
    'present': {
      exec { "install-${name}":
        command => "${exe} install ${plugin}",
        unless  => "${exe} list | grep -q ^${name}$",
      }
    }

    'absent': {
      notify { "${exe} list | grep -q ^${name}$": } ->
      exec { "remove-${name}":
        command => "${exe} uninstall ${name}",
        onlyif  => "${exe} list | grep -q ^${name}$",
      }
    }

    default: {
      fail "'ensure' should be 'present' or 'absent'."
    }
  }
}
