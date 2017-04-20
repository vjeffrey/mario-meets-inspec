# Mario Meets InSpec

 ( cd ~/playground/vagrant-playground && vagrant up )

inspec shell -i ~/playground/vagrant-playground/.vagrant/machines/default/virtualbox/private_key -t ssh://vagrant@192.168.33.10

help

help resources

help ssh_config

sshd_config.Protocol

describe sshd_config do
  its('Protocol') { should eq '2' }
end

// impact
// desc
// ref
// tag
describe sshd_config do
  its('Protocol') { should eq '2' }
end

turn it into a control

have port control ready
have a couple more controls ready

make it a profile

turn one control into an or test

run the profile

test with attributes (inline and external)

run the profile

inheritance, include controls, require controls, skip controls

run the profile

supports

run the profile

custom resources, ruby code in a control (looping)