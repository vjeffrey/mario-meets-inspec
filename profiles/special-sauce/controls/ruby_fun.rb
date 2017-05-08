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