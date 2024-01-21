# frozen_string_literal: true

module ErrorPulse
  ##
  # ErrorPulse::Service
  #
  # This class is responsible for sending the error to the ErrorPulse API.
  class Service
    ##
    # Send error to ErrorPulse
    # @param [Exception] exception
    # @param [Hash] request
    # @param [Hash] options
    def report_exception(exception, request = nil, options = {})
      response = send_report_error(error_for_exception(exception, request, options))
      puts response.body if response.code == 200
    rescue StandardError => e
      puts e.message
      configuration.logger.error e.message
    end

    private

    def configuration
      ErrorPulse.configuration
    end

    def error_for_exception(exception, request, _options)
      {
        message: exception.message,
        backtrace: exception.backtrace,
        request: http_headers(request)
      }
    end

    def send_report_error(error_report)
      HTTParty.post(
        configuration.api_endpoint,
        headers: request_headers,
        body: error_report
      )
    end

    def request_headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{configuration.api_key}"
      }
    end

    def http_headers(request)
      return {} unless request

      keys = request.headers.env.keys.select do |key|
        !key.starts_with?('rack') && !key.starts_with?('action_') && !key.starts_with?('puma')
      end
      keys.to_h { |key| [key, request.headers[key]] }
    end
  end
end
