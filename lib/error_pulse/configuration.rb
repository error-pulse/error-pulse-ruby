# frozen_string_literal: true

require 'logger'

## Module for ErrorPulse
module ErrorPulse
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

  ## Configuration class for ErrorPulse
  class Configuration
    attr_accessor(
      :api_key,
      :api_endpoint
    )

    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout)
    end
  end
end
