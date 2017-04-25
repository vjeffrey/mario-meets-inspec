## Reference: https://tech.spaceapegames.com/2016/09/23/custom-inspec-resources/

class RedisConfig < Inspec.resource(1)
  name 'redis_config'

  desc '
    Check Redis on-disk configuration.
  '

  example '
    describe redis_config('dummy_service_6') do
      its('port') { should eq('6382') }
      its('slave-priority') { should eq('69') }
    end
  '

  def initialize(service)
    @service = service
    @path = "/etc/redis/#{service}"
    @file = inspec.file(@path)

    begin
      @params = Hash[*@file.content.split("\n")
                           .reject{ |l| l =~ /^#/ or l =~ /^save/ }
                           .collect { |v| [ v.chomp.split ] }
                      .flatten]
        rescue StandardError
          return skip_resource "#{@file}: #{$!}"
      end
    end
  end

  def exists?
    @file.file?
  end

  def method_missing(name)
    @params[name.to_s]
  end

end
