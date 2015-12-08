module Eb
  class Platform
    def initialize(opts)
      @eb = opts[:eb]
      @tag = opts[:tag]
    end

    def deploy!
      fail "Environment NOT READY!"     unless @eb.ready?
      fail "Environment switch failed." unless @eb.switch
      eb_deploy!
    end

    private

    def write_redeploy_notification
      puts "Elastic Beanstalk application #{@eb.application_name}"\
           " already has version #{@tag}"
      puts "Assuming you do mean to redeploy, perhaps to a new target."
    end

    def eb_deploy!
      if @eb.version_exists?(@tag)
        write_redeploy_notification
        system("eb deploy --version=#{@tag}")
      else
        system("eb deploy --label=#{@tag}")
      end
    end
  end
end
