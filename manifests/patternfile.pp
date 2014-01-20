define logstash::patternfile (
  $source,
  $filename = '',
){

  validate_re($source, '^puppet://', 'Source must be from a puppet fileserver (begin with puppet://)' )

  $patterns_dir = "${logstash::configdir}/patterns"

  $filename_real = $filename ? {
    ''      => inline_template('<%= @source.split("/").last %>'),
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
