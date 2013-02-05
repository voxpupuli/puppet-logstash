# puppet-logstash

A puppet module for managing and configuring Logstash

This module is puppet 3 tested

## Usage

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

Installation with a JAR file:

     class { 'logstash':
       provider => 'custom',
       jarfile  => 'puppet:///path/to/jarfile'
     }

When no init script is provided when using custom provider, built in init script will be placed.
You can however supply your own init script and defaults file.

     class { 'logstash':
       provider     => 'custom',
       jarfile      => 'puppet:///path/to/jarfile',
       initfile     => 'puppet:///path/to/initfile',
       defaultsfile => 'puppet:///path/to/defaultsfile'
     }

When you want to use an other service manager like 'runit' or 'daemontools':

     class { 'logstash':
       provider => 'custom',
       status   => 'unmanaged'
     }

## Plugins

Every plugin in Logstash has its own define file.

For more information check the puppet files in the input, output and filter directories.
