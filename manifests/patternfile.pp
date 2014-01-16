define logstash::patternfile (
  $source,
  $instance = undef,
  $filename = '',
){

  if $logstash::multi_instance and !$instance {
    fail("You are running multi-insntace logstash and have not specified an instance for ${name}")
  } elsif !$logstash::multi_instance and $instance {
    fail("Cannot set instance with logstash multi-instance disabled")
  }

  validate_re($source, '^puppet://', 'Source must be from a puppet fileserver (begin with puppet://)' )

  if $logstash::multi_instance {
    $patterns_dir  = "${logstash::configdir}/${instance}/config/patterns"
  } else {
    $patterns_dir = "${logstash::configdir}/conf.d/patterns"
  }

  $filename_real = $filename ? {
    ''      => inline_template("<%= @source.split('/').last %>"),
    default => $filename
  }

  file { "${patterns_dir}/${filename_real}":
    ensure  => 'file',
    owner   => $logstash::logstash_user,
    group   => $logstash::logstsah_group,
    mode    => '0440',
    source  => $source,
  }

}
