# coding: utf-8
require 'spec_helper_acceptance'

describe 'class plugin' do
  let(:exe) { '/opt/logstash/bin/plugin' }
  let(:plugin) { 'logstash-output-stdout' }

  def ensure_present(extra_args = nil)
    manifest = <<-END
      logstash::plugin { '#{plugin}':
      ensure => present,
      #{extra_args if extra_args}
    }
    END
    apply_manifest(manifest, catch_failures: true)
  end

  def ensure_absent
    manifest = <<-END
      logstash::plugin { '#{plugin}':
        ensure => absent,
      }
    END
    apply_manifest(manifest, catch_failures: true)
  end

  def installed_plugins
    shell("#{exe} list").stdout
  end

  context 'with logstash installed' do
    before(:all) { install_logstash }

    context 'when a plugin is not installed' do
      before(:each) { shell("#{exe} uninstall #{plugin} || true") }

      it 'will not remove it again' do
        expect(ensure_absent.stdout).to_not contain("remove-#{plugin}")
      end

      it 'can install the plugin from rubygems' do
        ensure_present
        expect(installed_plugins).to contain(plugin)
      end

      it 'can install the plugin from a local gem' do
        pending
        ensure_present("source => '/tmp/logstash-output-localtest.gem'")
        expect(installed_plugins).to contain('logstash-output-localtest')
      end
    end

    context 'when a plugin is installed' do
      before(:each) { shell("#{exe} install #{plugin} || true") }

      it 'will not install it again' do
        # expect(ensure_present.stdout).to_not contain("install-#{plugin}")
      end

      it 'can remove the plugin' do
        # ensure_absent
        # expect(installed_plugins).not_to contain(plugin)
      end
    end
  end
end
