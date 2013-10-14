# puppet-logstash

A puppet module for managing and configuring Logstash

http://www.logstash.net

[![Build Status](https://travis-ci.org/logstash/puppet-logstash.png?branch=master)](https://travis-ci.org/logstash/puppet-logstash)

## Versions

This overview shows you which puppet module and logstash version work together.

    ------------------------------------
    | Puppet module | Logstash         |
    ------------------------------------
    | 0.0.1 - 0.1.0 | 1.1.9            |
    ------------------------------------
    | 0.2.0         | 1.1.10           |
    ------------------------------------
    | 0.3.0 - 0.3.4 | 1.1.12 - 1.1.13  |
    ------------------------------------
    | in progress   | 1.2.x            |
    ------------------------------------

## Version changes

From version 0.0.6 to 0.1.0 the following has been removed/changed:

initfile (string)     => initfiles (hash)

defaultsfile (string) => defaultsfiles (hash)

## Notes

With introduction of the multi-instance feature the default 'logstash' service gets disabled by the module when installed with a package.
The module will create and manage the services based on the instance names, the old init script will remain on the system but will not be used.


Setting up logstash without configuration will cause logstash not to start.
You will need to define atleast one plugin for Logstash to start.


For OS packages of logstash, see http://build.logstash.net/job/logstash-1.1.x/


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

If you rather not use the multi-instance feature you can diable this:

     class { 'logstash':
       multi_instance => false
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

If you want to define your own logstash config (multi-instance):
     class { 'logstash':
       conffile => { 'agent' => 'puppet:///data/logstash/agent.config' }
     }

If you want to define your own logstash config (single-instance):
     class { 'logstash':
       conffile => 'puppet:///data/logstash/agent.config'
     }

If you want to have the logstash files owned by an other user then 'root':

     class { 'logstash':
       logstash_user  => 'logstash',
       logstash_group => 'logstash'
     }

Please note that this does not set the user in the init file!!

## Plugins

Every plugin in Logstash has its own define file.

For more information check the puppet files in the input, output and filter directories.

Simple examples:

     logstash::input::syslog { 'logstash-syslog':
       type => 'syslog',
       port => '5544',
     }

     logstash::output::redis { 'logstash-redis':
       host      => [$::fqdn],
       data_type => 'list',
     }

### File transfers

From version 0.2.0 its now possible to automatically transfer files to the host for plugins that require a file.

For example lumberjack requires a certificate, so you can do the following:

     logstash::input::lumberjack { 'lumberjack_input':
       ssl_certificate => 'puppet:///path/to/ssl.cert':
     }

the file 'ssl.cert' will be placed in a pre-defined place and set in the configuration.

