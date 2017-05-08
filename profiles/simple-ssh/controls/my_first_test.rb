# title yo man you should use ssh config protocol 2
# desc keep bowser out ya stuff
# impact SUPER IMPORTANT
describe sshd_config do
  its('Protocol') { should eq '2' }
end