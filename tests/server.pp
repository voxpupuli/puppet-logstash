class { 'logstash':
  status         => 'enabled',
  multi_instance => false,
  patternfiles   => ['grok-patterns', 'extras'],
}
logstash::input::zeromq { 'input_zeromq':
  type     => 'zeromq',
  address  => ['tcp://*:2120'],
  topology => 'pushpull',
  mode     => 'server',
}
logstash::output::elasticsearch { 'output_elasticsearch':
  embedded  => true,
  bind_host => '0.0.0.0'
}
