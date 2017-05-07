class MarioResource < Inspec.resource(1)
  name 'mario'
  desc 'dummy inspec resource'

  def initialize(args)
    @args = args
  end

  def bowser?
    @args == 'why_so_mean?'
  end
end
