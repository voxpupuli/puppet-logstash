class { 'logstash':
  status         => 'enabled',
  multi_instance => false,
  patternfiles   => ['grok-patterns', 'extras'],
}
logstash::input::file { 'glance':
  type           => 'glance',
  start_position => 'beginning',
  path           => ['/var/log/glance/api.log', '/var/log/glance/registry.log', '/var/log/glance/scrubber.log']
}
logstash::input::file { 'keystone':
  type           => 'keystone',
  start_position => 'beginning',
  path           => ['/var/log/keystone/keystone.log']
}
logstash::input::file { 'nova':
  type           => 'nova',
  start_position => 'beginning',
  path           => ['/var/log/nova/nova-consoleauth.log', '/var/log/nova/nova-api.log', '/var/log/nova/nova-manage.log', '/var/log/nova/nova-network.log', '/var/log/nova/nova-scheduler.log', '/var/log/nova/nova-xvpvncproxy.log', '/var/log/nova/nova-compute.log']
}
logstash::input::file { 'quantum':
  type           => 'quantum',
  start_position => 'beginning',
  path           => ['/var/log/nova/quantum-server.log']
}
logstash::input::file { 'apache-access':
  type           => 'apache-access',
  start_position => 'beginning',
  path           => ['/var/log/apache2/access.log', '/var/log/nginx/access.log', '/var/log/apache2/other_vhosts_access.log']
}
logstash::input::file { 'apache-error':
  type           => 'apache-error',
  start_position => 'beginning',
  path           => ['/var/log/apache2/error.log', '/var/log/nginx/error.log']
}
logstash::input::file { 'rabbitmq':
  type           => 'rabbitmq',
  start_position => 'beginning',
  path           => ['/var/log/rabbitmq/rabbit@*.log']
}
logstash::input::file { 'libvirt':
  type           => 'libvirt',
  start_position => 'beginning',
  path           => ['/var/log/libvirt/libvirtd.log']
}

logstash::input::file { 'swift':
  type           => 'swift',
  start_position => 'beginning',
  path           => ['/var/log/messages']
}

logstash::output::zeromq { 'zeromq':
  address  => ['tcp://192.168.33.10:2120'],
  topology => 'pushpull',
  mode     => 'client',
}

logstash::filter::grok { 'glance':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'glance',
  pattern      => ['%{TIMESTAMP_ISO8601:timestamp} %{NUMBER:response}%{SPACE} %{AUDITLOGLEVEL:level} \[%{PROG:program}\] %{GREEDYDATA:message}']
}
logstash::filter::grok { 'keystone':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'keystone',
  pattern      => ['%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} \[%{PROG:program}\]: %{GREEDYDATA:message}']
}
logstash::filter::grok { 'nova':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'nova',
  pattern      => ['%{TIMESTAMP_ISO8601:timestamp} %{AUDITLOGLEVEL:level} %{PROG:program} %{GREEDYDATA:message}']
}
logstash::filter::grok { 'quantum':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'quantum',
  pattern      => ['%{TIMESTAMP_ISO8601:timestamp} %{SPACE} %{LOGLEVEL:level} \[%{PROG:program}\] %{GREEDYDATA:message}']
}

logstash::filter::grok { 'swift':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'swift',
  pattern      => ['%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} () %{GREEDYDATA:syslog_message}'],
}

logstash::filter::grok { 'apache-access':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'apache-access',
  pattern      => ['%{COMBINEDAPACHELOG}']
}
logstash::filter::grok { 'apache-error':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'apache-error',
  pattern      => ['[%{APACHE_DATETIME_ERROR:timestamp}] [%{APACHE_LOG_LEVEL:level}] %{GREEDYDATA:message}']
}
logstash::filter::grok { 'rabbitmq':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'rabbitmq',
  pattern      => ['=%{LOGLEVEL:level} REPORT==== %{RABBITMQ_DATE:timestamp} ===']
}
logstash::filter::grok { 'libvirt':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'libvirt',
  pattern      => ['%{TIMESTAMP_ISO8601:timestamp}: %{NUMBER:code}: %{LOGLEVEL} : %{GREEDYDATA:message}']
}
logstash::filter::date { 'date':
  match => ['yyyy-MM-dd HH:mm:ss.SSSZ', 'dd-MMM-YYYY::HH:mm:ss', 'yyyy-MM-dd HH:mm:ss,SSS', 'yyyy-MM-dd HH:mm:ss.SSS', 'yyyy-MM-dd HH:mm:ss', 'EEE MMM DD HH:mm:ss YYYY', 'dd/MMM/yyyy:HH:mm:ss Z', 'yyyy-MM-dd\\\'T\\\'HH:mm:ss.SSS\\\'Z\\\'']
}
logstash::filter::multiline { 'glance':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'glance',
  negate       => true,
  what         => 'previous',
  pattern      => '^(([0-9]+-(?:0?[1-9]|1[0-2])-(?:3[01]|[1-2]?[0-9]|0?[1-9]))|((?:0?[1-9]|1[0-2])/(?:3[01]|[1-2]?[0-9]|0?[1-9]))).*$'
}
logstash::filter::multiline { 'keystone':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'keystone',
  negate       => true,
  what         => 'previous',
  pattern      => '^(([0-9]+-(?:0?[1-9]|1[0-2])-(?:3[01]|[1-2]?[0-9]|0?[1-9]))|((?:0?[1-9]|1[0-2])/(?:3[01]|[1-2]?[0-9]|0?[1-9]))).*$'
}
logstash::filter::multiline { 'nova':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'nova',
  negate       => true,
  what         => 'previous',
  pattern      => '^(([0-9]+-(?:0?[1-9]|1[0-2])-(?:3[01]|[1-2]?[0-9]|0?[1-9]))|((?:0?[1-9]|1[0-2])/(?:3[01]|[1-2]?[0-9]|0?[1-9]))).*$'
}
logstash::filter::multiline { 'rabbitmq':
  patterns_dir => ['/etc/logstash/conf.d/pattern'],
  type         => 'rabbitmq',
  negate       => true,
  what         => 'previous',
  pattern      => '^='
}
