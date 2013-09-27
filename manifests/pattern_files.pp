# == Define: pattern_files
#
# === Authors
#
# * Bartosz Kupidura <bkupidura@mirantis.com>
# * Tomasz Z. Napierala <tnapierala@mirantis.com>
#
define logstash::pattern_files(
  $pattern_dir = undef,
  $services    = undef,
) {
  file { "${pattern_dir}/${name}":
      mode    => '0440',
      require => File[$pattern_dir],
      content => template("${module_name}/etc/pattern/${name}.erb"),
      notify  => Service[$services]
    }
}
