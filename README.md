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
    | 0.4.0         | 1.2.x - 1.3.x    |
    ------------------------------------

## Usage

Installation, make sure service is running and will be started at boot time:

     class { 'logstash': }

Install a certain version:

     class { 'logstash':
       version => '1.3.3-1_centos'
     }

This assumes an logstash package is already available to your distribution's package manager. To install it in a different way:

To download from http/https/ftp source:

     class { 'logstash':
       package_url => 'http://download.elasticsearch.org/logstash/logstash/packages/centos/logstash-1.3.3-1_centos.noarch.rpm'
     }

To download from a puppet:// source:

     class { 'logstash':
       package_url => 'puppet:///path/to/logstash-1.3.3-1_centos.noarch.rpm'
     }

Or use a local file source:

     class { 'logstash':
       package_url => 'file:/path/to/logstash-1.3.3-1_centos.noarch.rpm'
     }

Automatic upgrade of the software ( default set to false ):

     class { 'logstash':
       autoupgrade => true
     }

Removal/decommissioning:

     class { 'logstash':
       ensure => 'absent'
     }

Install everything but disable service(s) afterwards:

     class { 'logstash':
       status => 'disabled'
     }

Disable automated restart of Elasticsearch on config file change:

     class { 'logstash':
       restart_on_change => false
     }

## Configuration

For configuration you can use a single large file or multiple smaller files.
The `file` variable expects direct content or a template.


     logstash::configfile { 'configname':
       file => template('path/to/config.file')
     }

If you have multiple smaller files you can set the ordering of the files as they show up in the end result.
This allows you to split the different files into different locations / modules.

     logstash::configfile { 'input_redis':
       file  => template('input_redis.erb'),
       order => 1
     }

     logstash::configfile { 'filter_apache':
       file  => template('filter_apache.erb'),
       order => 2
     }

     logstash::configfile { 'output_es':
       file  => template('output_es_cluster.erb')
       order => 3
     }

## Pattern files

Grok and other plugins make the use of patterns.
Allot of them have been included into Logstash but sometimes there is need for extra patterns.
This define allows you to manage this and upload them to the machine.

Note: you will still need to define the path into the config.

     logstash::patternfile { 'extra_patterns':
       source => 'puppet:///path/to/extra_pattern'
     }

if you want the actual file name to be different then the source:

     logstash::patternfile { 'extra_patterns_firewall':
       source   => 'puppet:///path/to/extra_patterns_firewall_v1',
       filename => 'extra_patterns_firewall'
     }

## Java install

For those that have no separate module for installation of java:

     class { 'logstash':
       java_install => true
     }

If you want a specific java package/version:

     class { 'logstash':
       java_install => true,
       java_package => 'packagename'
     }

## Service providers

Currently only the 'init' service provider is supported but others can be implemented quite easy.

### init

#### Defaults file

You can populate the defaults file ( /etc/defaults/logstash or /etc/sysconfig/logstash )

##### hash representation

     class { 'logstash':
       init_defaults => { 'LS_USER' => 'logstash', 'LS_GROUP' => 'logstash' }
     }

##### file source

     class { 'logstash':
       init_defaults_file => 'puppet:///path/to/defaults'
     }

