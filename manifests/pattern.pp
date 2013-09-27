# == Define: logstash::pattern
#
# * Bartosz Kupidura <bkupidura@mirantis.com>
#

# == Class:logstash::pattern
#
class logstash::pattern(
  $instances = [ 'agent' ]
) {

  require logstash::params

  if $logstash::multi_instance == true {
    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $pattern_dir  = suffix($confdirstart, '/pattern')
    $services     = prefix($instances, 'logstash-')
  } else {
    $pattern_dir = "${logstash::configdir}/conf.d/pattern"
    $services    = 'logstash'
  }

  if $logstash::ensure == 'present' {

    File {
      owner => $logstash::logstash_user,
      group => $logstash::logstash_group,
    }

    #### Manage the config directory
    pattern_files { $logstash::patternfiles: pattern_dir => $pattern_dir, services => $services }

  } else {
    notify {'Not if':}
    #### Do we need to do anything to remove directories?
  }
}
