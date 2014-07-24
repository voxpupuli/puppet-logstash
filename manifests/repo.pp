# == Class: logstash::repo
#
# This class exists to install and manage yum and apt repositories
# that contain logstash official logstash packages
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'logstash::repo': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Phil Fenstermacher <mailto:phillip.fenstermacher@gmail.com>
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
# * Matthias Baur <mailto:matthias.baur@dmc.de>
#
class logstash::repo {

  case $::osfamily {
    'Debian': {
      if !defined(Class['apt']) {
        class { 'apt': }
      }

      apt::source { 'logstash':
        location    => "http://packages.elasticsearch.org/logstash/${logstash::repo_version}/debian",
        release     => 'stable',
        repos       => 'main',
        key         => 'D88E42B4',
        key_server  => 'pgp.mit.edu',
        include_src => false,
      }
    }
    'RedHat': {
      yumrepo { 'logstash':
        descr    => 'Logstash Centos Repo',
        baseurl  => "http://packages.elasticsearch.org/logstash/${logstash::repo_version}/centos",
        gpgcheck => 1,
        gpgkey   => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
        enabled  => 1,
      }
    }
    'Suse' : {
      zypprepo { 'logstash':
	type         => 'yum',
	baseurl      => "http://packages.elasticsearch.org/logstash/${logstash::repo_version}/centos/",
	enabled      => 1,
	autorefresh  => 0,
	name         => 'logstash',
	require     => Exec['add-rpm-gpg-key-elasticsearch'],
      }
      # Workaround until zypprepo allows the adding of the keys
      # https://github.com/deadpoint/puppet-zypprepo/issues/4
      exec { 'add-rpm-gpg-key-elasticsearch':
	path    =>  ['/bin', '/sbin', '/usr/bin/', '/usr/sbin/'],
	command =>  'wget -q -O /tmp/RPM-GPG-KEY-elasticsearch http://packages.elasticsearch.org/GPG-KEY-elasticsearch; rpm --import /tmp/RPM-GPG-KEY-elasticsearch',
	unless  =>  'rpm -q gpg-pubkey-d88e42b4',
      }     
    }
    default: {
      fail("\"${module_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
    }
  }
}
