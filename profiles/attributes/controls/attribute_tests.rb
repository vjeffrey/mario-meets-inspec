# Attributes
princess_user = attribute('user', default: 'bowser', description: 'An identification for the user')
princess_password = attribute('password', description: 'A value for the password')

# For use with external attributes (princess-peach-attributes.yml).
describe princess_user do
  it { should eq 'princess-peach' }
end

describe princess_password do
  it { should eq 'yoshi4life' }
end