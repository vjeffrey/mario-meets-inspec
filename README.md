# Mario Meets InSpec

Build the VM:
`cd ~/playground/vagrant-playground/ && vagrant up`

Build the Docker Container:
`docker build -t mariomeetsinspec .`

Make my life easier:
`export VM_KEY_PATH=~/playground/vagrant-playground/.vagrant/machines/default/virtualbox/private_key`
`export INSPEC_TESTS_REPO=~/presentations/mario-star-infrastructure-inspec/mario-meets-inspec`

## step one: spin up a vm to test against
 `cd ~/playground/vagrant-playground && vagrant up`

## step two: hmm, we should find out more about that vm..
 `inspec detect -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10`

## step three: alright, what was it we wanted to find out? The ssh config protocol? hmm, let's see:
 `inspec shell -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10`
 `help`
 `help resources`
 `help ssh_config`
 `ssh_config.Protocol`
  ```
  describe sshd_config do
    its('Protocol') { should eq '2' }
  end
  ```

## step four: great, we've got a test. now we can copy the test into our rb file.
### oh, but they wanted some information about that test, right? let's write some comments
  ```
  // impact 1.0
  // title 'check ssh config'
  // ref 'something', url: 'http://something'
  // tag 'safety first!'
  describe sshd_config do
    its('Protocol') { should eq '2' }
  end
  ```

### hey look, it's a control
  ```
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

## step five: is my profile ok? are all my tests ok?
`inspec check $INSPEC_TESTS_REPO`

## step six: describe.one test
`inspec exec $INSPEC_TESTS_REPO -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10`

## step seven: attributes
`inspec exec $INSPEC_TESTS_REPO -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10 --attrs princess-peach-attribute.yml`

## step eight: whoa, there's json output too?
`inspec exec $INSPEC_TESTS_REPO -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10 --attrs princess-peach-attribute.yml --format json`

## step nine: profile inheritance, vendor profile
`inspec vendor $INSPEC_TESTS_REPO`
`inspec exec $INSPEC_TESTS_REPO -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10`

## step ten: supports; damnit bob stop trying to crib my profiles for your windows! get your own!
  ```
  supports:
    - os-name: ubuntu
  ```

## step eleven: inspec wonderfulness; it's like flying on yoshi thru cloudland with 3x starpower

### docker resource
`docker run -d -p 4000:80 mariomeetsinspec`
`docker ps -a` # get container id

`inspec exec $INSPEC_TESTS_REPO/controls/docker_tests.rb docker://cf96e6af9470`

### custom resource
`inspec exec $INSPEC_TESTS_REPO -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10`

### ruby code in a control
`inspec exec $INSPEC_TESTS_REPO -i $VM_KEY_PATH -t ssh://vagrant@192.168.33.10`


## Bonus Points: Usage with Audit Cookbook
Hey there big spender!! So you wanna get all fancy devops-like with your compliance? Let us help you get started!
  Take a look at the <a href="https://github.com/chef-cookbooks/audit">audit cookbook</a>:

### Reporting to Chef Automate through Chef Server
```
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
```
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

## Bonus Points: Usage with Test Kitchen

TODO: FILL THIS IN

## Bonus Points: Usage with Habitat

TODO: FILL THIS IN
