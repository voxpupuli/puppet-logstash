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
    install_logstash

    context 'when a plugin is not installed' do
      if shell("#{exe} list").stdout.include?(plugin)
        shell("#{exe} uninstall #{plugin}")
      end

      it 'will not remove it again' do
        expect(apply_manifest(ensure_absent).exit_code).to(be_zero)
      end

      it 'can install the plugin from rubygems' do
        apply_manifest(ensure_present)
        expect(shell("#{exe} list").stdout).to contain(plugin)
      end
    end

    context 'when a plugin is installed' do
      unless shell("#{exe} list").stdout.include?(plugin)
        shell("#{exe} install #{plugin}")
      end

      it 'will not install it again' do
        expect(apply_manifest(ensure_present).exit_code).to(be_zero)
      end

      it 'can remove the plugin' do
        apply_manifest(ensure_absent)
        expect(shell("#{exe} list").stdout).not_to contain(plugin)
      end
    end
  end
end
