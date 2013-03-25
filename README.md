# puppet-logstash

A puppet module for managing and configuring Logstash

http://www.logstash.net

[![Build Status](https://travis-ci.org/electrical/puppet-logstash.png?branch=master)](https://travis-ci.org/electrical/logstash)


## Usage

### Standard

Installation, make sure service is running and will be started at boot time:

     class { 'logstash': }

Removal/decommissioning:

     class { 'logstash':
       ensure => 'absent',
     }

Install everything but disable service(s) afterwards:

     class { 'logstash':
       status => 'disabled',
     }

When you want to use an other service manager like 'runit' or 'daemontools':

     class { 'logstash':
       status   => 'unmanaged'
     }

### Multi-instance

If you require running more then 1 instance on the same machine.
If no instances are defined it will default to 'agent'.

     class { 'logstash':
       instances => [ 'instance1', 'instance2' ]
     }

All plugins can be defined to a certain instance. For example:

     logstash::input::file { 'fileinput':
       instances => [ 'instance1' ]
     }

     logstash::input::file { 'fileinput2':
       instances => [ 'instance2' ]
     }


### Other options

If you rather supply your own init script:

     class { 'logstash':
       initfiles => { 'agent' => 'puppet:///path/to/initfile' }
     }

In all cases you can supply a defaults file:

     class { 'logstash':
       defaultsfiles => { 'agent' => 'puppet:///path/to/defaults' }
     }

Installation with a JAR file:

     class { 'logstash':
       provider => 'custom',
       jarfile  => 'puppet:///path/to/jarfile',
       installpath => '/path/to/install/dir'
     }

When no init script is provided when using custom provider, built in init script will be placed.
You can however supply your own init script and defaults file.

     class { 'logstash':
       provider      => 'custom',
       jarfile       => 'puppet:///path/to/jarfile',
       initfiles     => { 'agent' => 'puppet:///path/to/initfile' },
       defaultsfiles => { 'agent' => 'puppet:///path/to/defaultsfile' }
     }

If you want java to be installed by the module:

     class { 'logstash':
       java_install => true
     }

If you want a specific java package/version:

     class { 'logstash':
       java_install => true,
       java_package => 'packagename'
     }

## Plugins

Every plugin in Logstash has its own define file.

For more information check the puppet files in the input, output and filter directories.
