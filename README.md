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

## Plugins

Every plugin in Logstash has its own define file.

For more information check the puppet files in the input, output and filter directories.
