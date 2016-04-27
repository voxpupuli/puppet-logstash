require 'spec_helper_acceptance'

describe 'class plugin' do
  context 'with logstash installed' do
    install_logstash
    exe = '/opt/logstash/bin/plugin'
    plugin = 'logstash-output-stdout'

    context 'when a plugin is not installed' do
      if shell("#{exe} list").stdout.include?(plugin)
        shell("#{exe} uninstall #{plugin}")
      end

      it 'can install the plugin from rubygems' do
        apply_manifest("logstash::plugin { '#{plugin}': }")
        expect(shell("#{exe} list").stdout).to contain(plugin)
      end
    end

    context 'when a plugin is installed' do
      unless shell("#{exe} list").stdout.include?(plugin)
        shell("#{exe} install #{plugin}")
      end

      it 'can remove the plugin' do
        apply_manifest("logstash::plugin { '#{plugin}': ensure => absent }")
        expect(shell("#{exe} list").stdout).not_to contain(plugin)
      end
    end
  end
end
