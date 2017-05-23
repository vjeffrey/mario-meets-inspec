# Yo is my container here??
describe docker.containers do
  its('images') { should include 'mariomeetsinspec' }
end

# What docker version am i running??
describe docker.version do
  its('Server.Version') { should cmp >= '1.12'}
  its('Client.Version') { should cmp >= '1.12'}
end

# Check up on that container
describe docker.containers do
  its('ids') { should_not include 'sha:71b5df59...442b' }
  its('commands') { should_not include '/bin/sh' }
  its('ports') { should_not include '0.0.0.0:1234->1234/tcp' }
  its('labels') { should_not include 'License=GPLv2,Vendor=CentOS' }
end

# Reference: https://github.com/chef/inspec/blob/master/docs/resources/docker.md.erb