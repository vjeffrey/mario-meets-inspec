# The include_controls keyword may be used in a profile to import all rules from the named profile.
include_controls 'my-linux-profile' do

  skip_control "package-01"
  skip_control "package-02"

  control "package-08" do
    impact 0.2
  end
end

# The require_controls keyword may be used to load only specific controls from the named profile.
require_controls 'ssh-baseline' do

  control "sshd-05"
  control "sshd-06"

end