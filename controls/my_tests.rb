# TODO: MAKE THIS describe.one (or test) better!
describe.one do
  describe ConfigurationA do
  its('setting_1') { should eq true }
  end

  describe ConfigurationB do
  its('setting_2') { should eq true }
  end
end

# Inline attributes
bowser_user = attribute('bowser-dude', default: 'bowser', description: 'An identification for the user')
bowser_password = attribute('sneakin-on-you', description: 'A value for the password')

describe bowser_user do
  it { should eq 'bowser-dude' }
end

describe bowser_password do
  it { should eq 'sneakinonyou' }
end

# For use with external attributes (princess-peach-attributes.yml).
describe princess_user do
  it { should eq 'princess-peach' }
end

describe princess_password do
  it { should eq 'yoshi4life' }
end

# The include_controls keyword may be used in a profile to import all rules from the named profile.
include_controls 'my-linux-profile' do

  skip_control "package-01"
  skip_control "package-02"

  control "package-08" do
    impact 0.2
  end
end

# The require_controls keyword may be used to load only specific controls from the named profile.
require_controls 'ssh-baseline' do

  control "sshd-05"
  control "sshd-06"

end

## Custom resource, reference: https://tech.spaceapegames.com/2016/09/23/custom-inspec-resources/

describe redis_config("leaderboard_service") do
  it { should exist }
  its('slave-priority') { should eq('50') }
  its('rdbcompression') { should eq('yes') }
  its('dbfilename') { should eq('leaderboard_service.rdb') }
end

## Ruby in a control, reference: https://github.com/chef/inspec/blob/master/docs/ruby_usage.md

output=command('echo test').stdout
describe command('echo test') do
  its('stdout') { should eq output }
end