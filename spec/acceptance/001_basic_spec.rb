require 'spec_helper_acceptance'

# Here we put the more basic fundamental tests, ultra obvious stuff.
describe 'puppet' do
  it 'should be the right version' do
    expect(shell('puppet --version').stdout.chomp).to eq(PUPPET_VERSION)
  end
end

describe 'logstash module' do
  it 'should be available' do
    shell(
      "ls #{default['distmoduledir']}/logstash/Modulefile",
      acceptable_exit_codes: 0
    )
  end

  it 'should be parsable' do
    shell(
      "puppet parser validate #{default['distmoduledir']}/logstash/manifests/",
      acceptable_exit_codes: 0
    )
  end
end
