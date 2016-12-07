# == define: logstash::configfile
#
# This define is to manage the pipeline config files for Logstash
#
# === Parameters
#
# [*content*]
#  Supply content to be used for the config file, possibly rendered with
#  template().
#
# [*source*]
#  Supply a file resource to be used for the config file.
#
# === Examples
#
#     Set config file content with a literal value:
#
#     logstash::configfile { 'heartbeat':
#       content => 'input { heartbeat {} }',
#     }
#
#     or with a file source:
#
#     logstash::configfile { 'apache':
#       source => 'puppet://path/to/apache.conf',
#     }
#
# === Authors
#
# https://github.com/elastic/puppet-logstash/graphs/contributors
#
define logstash::configfile($content = undef, $source = undef) {
  include logstash

  $path = "/etc/logstash/conf.d/${name}.conf"
  $owner = $logstash::logstash_user
  $group = $logstash::logstash_group
  $mode ='0440'
  $require = Package['logstash'] # So that we have '/etc/logstash/conf.d'.
  $tag = [ 'logstash_config' ] # So that we notify the service.

  if($content){
    file { $path:
      content => $content,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      require => $require,
      tag     => $tag,
    }
  }
  elsif($source){
    file { $path:
      source  => $source,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      require => $require,
      tag     => $tag,
    }
  }
}
