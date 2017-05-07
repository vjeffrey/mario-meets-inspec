# Mario Meets InSpec

Build the VM and Docker Container:
```
cd playground && vagrant up && docker build -t mariomeetsinspec .
```

Set env var for vagrant key:
```
export VM_KEY_PATH=./playground/.vagrant/machines/default/virtualbox/private_key
```

## Step One: Get latest InSpec
```
gem install inspec
```

## Step Two: Let's find out more about that node...
```
inspec detect -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10
```

## Step Three: What do i want to test?? Oh, i can use the InSpec shell to figure it out!
```
inspec shell -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10
help
help resources
help ssh_config
ssh_config.Protocol
```
```ruby
describe sshd_config do
  its('Protocol') { should eq '2' }
end
```

## Step Four: We've got a test! Now we can copy the test into our ssh_tests.rb file.
### Oh, but they wanted some information about that test, right? Let's write some comments...
```ruby
# impact 1.0
# title 'check ssh config'
# ref 'something', url: 'http://something'
# tag 'safety first!'
describe sshd_config do
  its('Protocol') { should eq '2' }
end
```

### Hey look, it's a control now!
```ruby
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
```

## Step Five: From a control to a profile and all about the inspec.yml
### Stick some controls together in a file, stick it together with an inspec.yml and a profile is made!:
#### (see controls/ssh_tests.rb and inspec.yml)
```
name: mario-meets-inspec
title: Mario Meets InSpec, The Story of a Profile
maintainer: Victoria Jeffrey, Hannah Maddy
copyright: Victoria Jeffrey, Hannah Maddy
copyright_email: vjeffrey@chef.io
license: All Rights Reserved
summary: Bowser keeps trying to break into my vms! This should help keep him out.
version: 0.1.0
```

## Step Six: Is my profile ok? Are all my tests ok?
```
inspec check profiles/simple-ssh
```

## Step Seven: Supports; damnit bob stop trying to crib my profiles for your windows! get your own!
```
supports:
  - os-name: ubuntu
```

## Step Eight: JSON output FTW!
```
inspec exec profiles/simple-ssh -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10 --format json
```

## Step Nine: Attributes
#### (see controls/example_tests.rb and princess-peach-attribute.yml)
```
inspec exec profiles/attributes -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10 --attrs princess-peach-attribute.yml
```

## Step Ten: Profile Inheritance; Vendoring a profile
#### (see controls/example_tests.rb)
```
depends:
- name: my-linux-profile
  git: https://github.com/dev-sec/linux-baseline
- name: ssh-baseline
  url: https://github.com/dev-sec/linux-baseline/archive/tar.gz
```
```
inspec vendor profiles/inheritance
inspec exec profiles/inheritance -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10
```

## Step Eleven: InSpec Wonderfulness; it's like flying on yoshi thru cloudland...

### Docker Resource
#### (see controls/docker_tests.rb)
```
inspec exec profiles/special-stuff/controls/docker_tests.rb
```

### Custom Resource
#### (see controls/example_tests.rb and libraries/custom_resource.rb)
```
inspec exec profiles/special-stuff -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10
```

### Ruby Code in a Control
#### (see controls/example_tests.rb)
```
inspec exec profiles/special-stuff -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10
```

## Bonus Points: Usage with Test Kitchen

TODO: FILL THIS IN

## Bonus Points: Usage with Audit Cookbook
Hey there big spender!! So you wanna get all fancy devops-like with your compliance? Let us help you get started!
  Take a look at the <a href="https://github.com/chef-cookbooks/audit">audit cookbook</a>:

### Reporting to Chef Automate through Chef Server
```ruby
default['audit']['reporter'] = 'chef-server-automate'
default['audit']['insecure'] = false,
default['audit']['profiles'] = [
  {
    name: 'cis-ubuntu14.04-level2',
    compliance: 'workstation-1/cis-ubuntu14.04lts-level2'
  },
  {
    'name': 'my-local-profile',
    'path': '/some/base_linux.tar.gz'
  },
  {
    "name": "ssh",
    "supermarket": "hardening/ssh-hardening"
  }
]
```

### Reporting to Chef Automate Directly
```ruby
# Set the `data_collector.server_url` and `data_collector.token` in your `client.rb`

'audit': {
  'reporter' = 'chef-automate'
  'insecure' = false,  ## true skips ssl cert verification
  'profiles' = [
    {
      "name": "ssl",
      "git": "https://github.com/dev-sec/ssl-baseline.git"
    },
    {
      "name": "ssh",
      "url": "https://github.com/dev-sec/ssh-baseline/archive/master.zip"
    }
  ]
}
```

## Bonus Points: Usage with Habitat

<a href="https://blog.chef.io/2017/03/30/inspec-habitat-and-continuous-compliance/">Blog Post</a>
<a href="https://www.youtube.com/watch?v=07c-7yJraK0">Video</a>
