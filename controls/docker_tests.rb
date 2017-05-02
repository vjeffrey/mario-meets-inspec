### Yo my container running???
describe docker.containers.where { name == 'mariomeetsinspec' } do
  it { should be_running }
end

### Gotta be healthy to run!
docker.containers.running?.ids.each do |id|
  describe docker.object(id) do
    its('State.Health.Status') { should eq 'healthy' }
  end
end

### Why you trynna ADD on my docker containers!!?
docker.images.ids.each do |id|
  describe command("docker history #{id}| grep 'ADD'") do
    its('stdout') { should eq '' }
  end
end

# Reference: https://github.com/chef/inspec/blob/master/docs/resources/docker.md.erb