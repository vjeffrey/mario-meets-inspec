# describe.one test ("the or test"), reference: Alex Pop
a = command("iptables -L").stdout.scan(/.+/)
describe.one do
  a.each do |entry|
    describe entry do
      it { should match(/^Chain INPUT \(policy (DROP|REJECT)\)$/) }
    end
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

## Custom resource
describe mario('why_so_mean') do
  it { should be_bowser }
end

## Ruby in a control, reference: https://github.com/chef/inspec/blob/master/docs/ruby_usage.md
output=command('echo test').stdout
describe command('echo test') do
  its('stdout') { should eq output }
end