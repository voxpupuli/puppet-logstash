$pipelines = [
  {
    'pipeline.id' => 'pipeline_zero',
    'path.config' => '/tmp/pipeline_zero.conf',
  },
  {
    'pipeline.id' => 'pipeline_one',
    'path.config' => '/tmp/pipeline_one.conf',
  },
]

class { 'elastic_stack::repo':
  version    => 6,
  prerelease => false,
}

class { 'logstash':
  manage_repo     => true,
  version         => '6.5.1',
  pipelines       => $pipelines,
  startup_options => { 'LS_USER' => 'root' },
}

logstash::configfile { 'pipeline_zero':
  content => 'input { heartbeat{} } output { null {} }',
  path    => '/tmp/pipeline_zero.conf',
}

logstash::configfile { 'pipeline_one':
  content => 'input { tcp { port => 2002 } } output { null {} }',
  path    => '/tmp/pipeline_one.conf',
}

logstash::plugin { 'logstash-input-mysql': }

$hiera_pluginlist = lookup({name => 'logstash::pluginlist', default_value => undef, merge => deep})
if $hiera_pluginlist {
  create_resources('logstash::plugin', $hiera_pluginlist)
}
