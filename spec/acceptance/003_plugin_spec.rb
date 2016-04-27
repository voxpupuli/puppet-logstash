# coding: utf-8
require 'spec_helper_acceptance'

describe 'class plugin' do
  exe = '/opt/logstash/bin/plugin'
  plugin = 'logstash-output-stdout'

  ensure_present = <<-END
    logstash::plugin { '#{plugin}':
      ensure => present,
    }
    END

  ensure_absent = <<-END
    logstash::plugin { '#{plugin}':
      ensure => absent,
    }
    END

  context 'with logstash installed' do
    before(:all) do
      install_logstash
    end

    context 'when a plugin is not installed' do
      before(:each) do
        shell("#{exe} uninstall #{plugin} || true")
      end

      it 'will not remove it again' do
        log = apply_manifest(ensure_absent).stdout
        expect(log).to_not contain("remove-#{plugin}")
      end

      it 'can install the plugin from rubygems' do
        log = apply_manifest(ensure_present).stdout
        expect(log).to contain("install-#{plugin}")
        expect(shell("#{exe} list").stdout).to contain(plugin)
      end
    end

    context 'when a plugin is installed' do
      before(:each) do
        shell("#{exe} install #{plugin} || true")
      end

      it 'will not install it again' do
        log = apply_manifest(ensure_present).stdout
        expect(log).to_not contain("install-#{plugin}")
      end

      it 'can remove the plugin' do
        log = apply_manifest(ensure_absent).stdout
        expect(log).to contain("remove-#{plugin}")
        expect(shell("#{exe} list").stdout).not_to contain(plugin)
      end
    end
  end
end
