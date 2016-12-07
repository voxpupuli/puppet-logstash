# == define: logstash::configfile
#
# This define is to manage the pipeline configuration files for Logstash.
#
# === Parameters
# One of following:
#
# [*content*]
#  Literal content to be used for the config file.
#
# [*template*]
#  Location of template from which to render a config file.
#
# [*source*]
#  A file resource to be used for the config file.
#
# === Examples
#
#     Set config file content with a literal value:
#
#     logstash::configfile { 'heartbeat':
#       content => 'input { heartbeat {} }',
#     }
#
#     ...from a template:
#
#     logstash::configfile { 'from-template':
#       template => 'site-logstash-module/pipeline-config.erb',
#     }
#
#     ...or from a file source:
#
#     logstash::configfile { 'apache':
#       source => 'puppet://path/to/apache.conf',
#     }
#
# === Authors
#
# https://github.com/elastic/puppet-logstash/graphs/contributors
#
define logstash::configfile(
  $content = undef,
  $source = undef,
  $template = undef,
)
{
  include logstash

  $path = "/etc/logstash/conf.d/${name}.conf"
  $owner = $logstash::logstash_user
  $group = $logstash::logstash_group
  $mode ='0440'
  $require = Package['logstash'] # So that we have '/etc/logstash/conf.d'.
  $tag = [ 'logstash_config' ] # So that we notify the service.

  if($template)   { $config = template($template) }
  elsif($content) { $config = $content }

  if($config){
    file { $path:
      content => $config,
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
