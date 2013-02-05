$vpup = '/opt/vagrant_ruby/bin/puppet'
$vmods = '/tmp/vagrant-puppet/modules'

define vpupmod() {
  $modulename = inline_template('<%= name.split("/")[1] %>')
  exec { "install module ${name}":
    command => "${vpup} module install ${name} --modulepath ${vmods}",
    creates => "${vmods}/${modulename}",
  }
}

vpupmod { 
  'puppetlabs/stdlib':
}
