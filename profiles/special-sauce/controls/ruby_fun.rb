## Ruby in a control, reference: https://github.com/chef/inspec/blob/master/docs/ruby_usage.md
output=command('echo test').stdout
describe command('echo test') do
  its('stdout') { should eq output }
end

## describe.one test ("the or test"), reference: Alex Pop
a = command("iptables -L").stdout.scan(/.+/)
describe.one do
  a.each do |entry|
    describe entry do
      it { should match(/^Chain INPUT \(policy (DROP|REJECT)\)$/) }
    end
  end
end

# usage with external yaml
my_services = yaml(content: inspec.profile.file('services.yml')).params

my_services.each do |s|
  describe service(s['name']) do
    it { should be_running }
  end

  describe port(s['port']) do
    it { should be_listening }
  end
end