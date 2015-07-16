# The puppet logstash module doesn't support multiple instances of logstash,
# so we're rolling our own here for log-st.
class ims_logserver(
  logstash_version = undef,
) {
  
  package { 'logstash':
    version     => $logstash_version,
  }

  # conf files
  file { '/etc/logstash/conf.d/logstash_server.conf':
    owner   => 'logstash',
    group   => 'logstash',
    mode    => 640,
    source  => 'puppet:///modules/logstash/log-st/logstash_server.conf',
  }

  file { '/etc/logstash/conf.d/logstash_receiver.conf':
    owner   => 'logstash',
    group   => 'logstash',
    mode    => 640,
    source  => 'puppet:///modules/logstash/log-st/logstash_receiver.conf',
  }

  # init.d
  file { '/etc/init.d/logstash_server':
    owner   => 'root',
    group   => 'root',
    mode    => 755,
    source  => 'puppet:///modules/logstash/log-st/logstash_server.initd',
  }

  file { '/etc/init.d/logstash_receiver':
    owner   => 'root',
    group   => 'root',
    mode    => 755,
    source  => 'puppet:///modules/logstash/log-st/logstash_receiver.initd',
  }

  # services
  service { 'logstash_receiver':
    enable    => true,
    ensure    => running,
    require   => File['/etc/init.d/logstash_receiver'],
    subscribe => File['/etc/logstash/conf.d/logstash_receiver.conf'],
  }

  service { 'logstash_server':
    enable    => true,
    ensure    => running,
    require   => File['/etc/init.d/logstash_server'],
    subscribe => File['/etc/logstash/conf.d/logstash_server.conf'],
  }

}
