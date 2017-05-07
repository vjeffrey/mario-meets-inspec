# Attributes
bowser_user = attribute('bowser-dude', default: 'bowser', description: 'An identification for the user')
bowser_password = attribute('sneakin-on-you', description: 'A value for the password')

describe bowser_user do
  it { should eq 'bowser-dude' }
end

describe bowser_password do
  it { should eq 'sneakinonyou' }
end

# For use with external attributes (princess-peach-attributes.yml).
describe princess_user do
  it { should eq 'princess-peach' }
end

describe princess_password do
  it { should eq 'yoshi4life' }
end