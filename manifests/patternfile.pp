# == Define: logstash::patternfile
#
# This define allows you to transport custom pattern files to the Logstash instance
#
# All default values are defined in the logstashc::params class.
#
#
# === Parameters
#
# [*source*]
#   Puppet file resource of the pattern file ( puppet:// )
#   Value type is string
#   Default value: None
#
# [*content*]
#   Content of the Pattern file
#   Value type is string
#   Default value: None
#
# [*filename*]
#   if you would like the actual file name to be different then the source file name
#   Value type is string
#   This variable is optional
#
#
# === Examples
#
#     logstash::patternfile { 'mypattern':
#       source => 'puppet:///path/to/my/custom/pattern'
#     }
#
#     or wil an other actual file name
#
#     logstash::patternfile { 'mypattern':
#       source   => 'puppet:///path/to/my/custom/pattern_v1',
#       filename => 'custom_pattern'
#     }
#
#
# === Authors
#
# * Justin Lambert
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
define logstash::patternfile (
  $source = undef,
  $content = undef,
  $filename = '',
){

  if $source {
    validate_re($source, '^(puppet|file)://', 'Source must be from a puppet fileserver or a locally accessible file (begins with either puppet:// or file://)' )
    $filename_real = $filename ? {
      ''      => inline_template('<%= @source.split("/").last %>'),
      default => $filename
    }
  }
  elsif $content {
    $filename_real = $title
  }
  else {
    fail("you must specify ${source} or ${content}")
  }

  $patterns_dir = "${logstash::configdir}/patterns"


  file { "${patterns_dir}/${filename_real}":
    ensure  => 'file',
    owner   => $logstash::logstash_user,
    group   => $logstash::logstash_group,
    mode    => '0644',
    source  => $source,
    content => $content,
  }
}
