# encoding: utf-8

only_if do
  command('ssh').exist?
end

control 'ssh-config-check' do
  impact 1.0
  title 'Check ssh config protocol'
  desc 'Protocol should be set to 2. Version 1 = bad monkeys'
  ref 'that doc that gives an overcomplicated explanation', url: 'http://someone/sounds/fancy'
  tag 'safety-first-friends'
  describe sshd_config do
    its('Protocol') { should eq '2' }
  end
end

describe sshd_config do
  its('Port') { should eq('22') }
end

control 'sshd-sure-is-strict' do
  impact 1.0
  title 'Server: Enable StrictModes'
  desc 'Prevent the use of insecure home directory and key file permissions.'
  describe sshd_config do
    its('StrictModes') { should eq('yes') }
  end
end

control 'no-mess-with-hostkey' do
  impact 1.0
  title 'Server: Specify SSH HostKeys'
  desc 'Specify HostKey for protection against Man-In-The-Middle Attacks'
  describe sshd_config do
    its('HostKey') { should cmp ssh_crypto.valid_hostkeys }
  end
end

control 'mums the word' do
  impact 1.0
  title 'Server: DebianBanner'
  desc 'Specifies whether to include OS distribution in version information'
  case os[:family]
  when 'debian' then
    describe sshd_config do
      its('DebianBanner') { should eq('no') }
    end
  else
    describe file(sshd_config.path) do
      its('content') { should_not match(/DebianBanner/) }
    end
  end
end

