intelliment_session = intelliment.session(
  url: 'http://pocs.intelliment-labs.com',
  token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbnNwZWMiLCJqdGkiOiI3YmUzMDM2Yy0xNDcxLTQ2NjYtODM5YS1hZmVlZjJjMDY1OWMifQ.Zv3eSJLj8mQtNjzyoO97RK5_fIhN7rr6sb3n8v5mIvA',
)
itlm = intelliment_session.scenario(65)

control 'nw01' do
  title 'All PCI policies must have a description'
  desc  '
    Policies without descriptions lack explanations to share their context
    with users and administrators. It is hard to reason and change these
    without at a sufficient understanding or reference.
  '
  describe itlm.policies(tags: 'pci').descriptions('') do
    its('entries') { should be_empty }
  end
end

internet_connections = itlm.policies(tags: 'pci', action: 'allow', source: '1260-1-c-24')

control 'nw02' do
  title 'Do not use insecure connections from the internet'
  desc  '
    Make sure all connections to the internet are encrypted. Turn HTTP into
    HTTPS and prevent insecure services to be exposed publicly.
  '
  describe internet_connections.services('80/tcp') do
    it { should be_empty }
  end
end

control 'nw03' do
  title 'All internet connections must be terminated in the DMZ'

  describe(internet_connections.where { destination['network']['name'] !~ /dmz/i }) do
    its('entries') { should be_empty }
  end
end