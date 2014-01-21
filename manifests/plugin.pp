#
#
define logstash::plugin (
  $ensure,
  $source,
  $type,
  $filename = '',
){

  validate_re($source, '^puppet://', 'Source must be from a puppet fileserver (begin with puppet://)' )

  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  if ! ($type in [ 'input', 'output', 'filter', 'codec' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  $plugins_dir = "${logstash::configdir}/plugins"

  $filename_real = $filename ? {
    ''      => inline_template('<%= @source.split("/").last %>'),
    default => $filename
  }

  file { "${plugins_dir}/logstash/${type}s/${filename_real}":
    ensure  => $ensure,
    owner   => $logstash::logstash_user,
    group   => $logstash::logstsah_group,
    mode    => '0440',
    source  => $source,
  }

}
