# Mario Meets InSpec

### Well hello there human!  So you wanna learn some InSpec, do ya?
### Let's get a vm and docker container up for testing.

Build the VMs and Docker containers by running:
```
make start-vagrant-ubuntu
make start-vagrant-windows
make start-docker-ssh
make start-docker-mario
```

Set env var for keys and passwords so you don't have to typey typey too much:
```
export VAGRANT_KEY=./playground/vagrant-ubuntu/.vagrant/machines/default/virtualbox/private_key
export SSH_PASS='password'
export WINDOWS_PASS='vagrant'
```

## Step One: Get latest InSpec, via gem, cause that's how we roll
#### You could actually get it via package, chefdk, and chef-client 13+, docker image and hab package too. But this is easiest here and now in our friendly terminal.
```
gem install inspec
inspec help
inspec version
```
#### Are you on latest InSpec? Check by going to https://rubygems.org/gems/inspec/

## Step Two: Let's find out more about that node...
#### Pro tip: You're gonna wanna be at the root of the repo for all these commands, to ensure the KEY path is correct
```
inspec detect -t winrm://vagrant@127.0.0.1 --password $WINDOWS_PASS -p 55985
inspec detect -t ssh://pwsudo@localhost --password $SSH_PASS -p 11030
inspec detect -t ssh://vagrant@192.168.33.10 -i $VAGRANT_KEY
inspec detect -t docker://cc_pg
```

## Step Three: Hmmmmm, now what do I want to test?? Oh, I can use the InSpec shell to figure it out!
### What's InSpec shell, you say? It's a pry based Read–Eval–Print Loop that can be used to quickly run InSpec controls and tests without having to write it to a file. Its functionality is similar to chef shell.
#### We'll start by connecting to the shell with our key and transport information, and then play around in the shell for a bit and write our first test.
```
inspec help shell
inspec shell -t ssh://pwsudo@localhost --password $SSH_PASS -p 11030
help
help resources
help sshd_config
sshd_config.params
sshd_config.port
sshd_config.Protocol
help matchers
```
```ruby
describe sshd_config do
  its('Protocol') { should eq '2' }
end
```

## Step Four: We've got a test! Now we can talk about profiles:

```
inspec init profile my-first-profile
```

### We can copy the test into our test file (my-first-profile/controls/example.rb)
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
  impact 1.0  # how important is this test? (0-0.3 = minor, 0.4-0.7 = major, 0.7-1.0 critical)
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
### A what yml?? An InSpec yml! That's a small file that contains metadata information about your profile.
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

## Step Six: Supports; damnit Bob stop trying to crib my profiles for your windows! Get your own!
### Supports is used to specify the os-name, release, family, etc.
#### https://github.com/chef/inspec/blob/master/docs/profiles.md
```
supports:
  - os-name: ubuntu
```

## Step Seven: Is my profile ok? Are all my tests ok? How do I knowwww???
### Check is used to ensure your profile is in a good state
```
inspec check profiles/simple-ssh
```

## Step Eight: JSON output FTW! (and JUNIT too??? whoa man..)
### Running this profile should result in a combination of passes and fails
```
inspec exec profiles/simple-ssh -t ssh://pwsudo@localhost --password $SSH_PASS -p 11030
inspec exec profiles/simple-ssh -t ssh://pwsudo@localhost --password $SSH_PASS -p 11030 --format json
inspec exec profiles/simple-ssh -t ssh://pwsudo@localhost --password $SSH_PASS -p 11030 --format junit
```

## Step Nine: Attributes
### Attributes may be used in profiles to define secrets, such as user names and passwords, that should not otherwise be stored in plain-text in a cookbook
#### (see controls/example_tests.rb and princess-peach-attribute.yml)
```
inspec exec profiles/attributes --attrs profiles/attributes/princess-peach-attribute.yml
```

## Step Ten: Profile Inheritance; Vendoring a profile
### Give me alllll the profiles, alll the power! Alll of it!!!
#### (see controls/example_tests.rb)
#### Pro tip: --overwrite allows you to overwrite an already-vendored profile
#### Pro tip: --no-create-lockfile skips the lockfile creation
```
depends:
- name: my-linux-profile
  git: https://github.com/dev-sec/linux-baseline
- name: ssh-baseline
  url: https://github.com/dev-sec/ssh-baseline/archive/tar.gz
```
```
inspec vendor profiles/inheritance  # downloads all the dependencies
inspec exec profiles/inheritance -t ssh://pwsudo@localhost --password $SSH_PASS -p 11030
```

### Tarball a profile, because friends share profiles!
```
inspec archive profiles/simple-ssh
ls  # notice the tar file there?
```

## Step Eleven: InSpec Wonderfulness; it's like flying on yoshi thru cloudland...
### Seriously though, how dope is cloudland???  I love that place. Who doesn't wanna bounce on clouds?

### Docker Resource
#### (see controls/docker_tests.rb)
```
inspec exec profiles/docker-love
```

### Custom Resource
#### (see controls/example_tests.rb and libraries/custom_resource.rb)
```
inspec exec profiles/custom-resource
```

### Ruby Code in a Control
#### (see controls/example_tests.rb)
```
inspec exec profiles/special-sauce-ruby -t ssh://pwsudo@localhost --password $SSH_PASS -p 11030
```

## Bonus Points: Usage with Test Kitchen
Test-kitchen is a tool used to automatically test cookbook data across any combination of platforms and test suites.
Well, that sounds nice. I sure would love to do a quick test of my profile against all these different platform versions, but how oh how do I do so?
TADA: <a href="https://github.com/chef/kitchen-inspec">Kitchen Inspec</a>
What??? You're gonna InSpec my kitchen?? lol...you know you thought it was funny :)
kitchen-inspec is a tool you can use with test-kitchen by adding the following to your .kitchen.yml
```
verifier:
  name: inspec
```

## Bonus Points: Usage with Audit Cookbook
Hey there big spender!! So you wanna get all fancy devops-like with your compliance? Let us help you get started!
  Take a look at the <a href="https://github.com/chef-cookbooks/audit">audit cookbook</a>:

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

## More Cool Stuff

### Inspec + Supermarket:
    ```
    inspec help supermarket
    inspec supermarket profiles
    ```

### InSpec + Containers:
    * https://github.com/dev-sec/cis-docker-benchmark
    * https://blog.chef.io/2017/03/30/inspec-habitat-and-continuous-compliance/
    * https://blog.chef.io/2017/03/22/docker-container-compliance-with-inspec/

### Inspec + Cloud Modules:
    * https://blog.chef.io/2017/05/23/inspec-launches-support-cloud-platform-assessments/
    * https://github.com/alexpop/ec2-instance-profile

### WannaCry Exploit
    * https://blog.chef.io/2017/05/15/detecting-wannacry-exploit-inspec/


## But how does it all happen?? How does InSpec connect to these machines? It uses train! Go check it out <a href="https://github.com/chef/train">here</a>!
------------------------------------

# <a href="https://www.youtube.com/watch?v=wpNINl1qczc&feature=youtu.be">Watch the Presentation @ChefConf 2017!</a>

# <a href="https://goo.gl/forms/R6d5h0oo9x9nYRe93">Give us Feedback!</a>
