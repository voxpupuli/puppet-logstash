$jarbase     = 'https://logstash.objects.dreamhost.com/release'
$jarfile     = 'logstash-1.1.9-monolithic.jar'
$jarpath     = "/tmp/$jarfile"
$jdk         = 'openjdk-7-jre-headless'
$installpath = '/opt/logstash'

package { 'curl':
  ensure => present,
}

package { $jdk:
  ensure => present,
}

exec { 'get-jarfile':
  command => "/usr/bin/curl -L ${jarbase}/${jarfile} -o ${jarpath}",
  creates => $jarpath,
  require => Package['curl'],
}

file { $installpath:
  ensure => directory,
  owner  => root,
  group  => root,
  mode   => '0755',
}

class { 'logstash':
  jarfile     => $jarpath,
  provider    => 'custom',
  installpath => $installpath,
  require     => [Exec['get-jarfile'], Package[$jdk], File[$installpath]],
}

