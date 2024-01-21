# frozen_string_literal: true

require 'spec_helper'
require 'httparty'

RSpec.describe ErrorPulse::Service do
  let(:service) { ErrorPulse::Service.new }
  let(:exception) { StandardError.new('Test error') }
  let(:request) { double('request', headers: double(env: {})) }
  let(:configuration) { double('configuration', api_key: 'test_api_key', api_endpoint: 'http://example.com', logger: Logger.new('/dev/null')) }

  before do
    allow(ErrorPulse).to receive(:configuration).and_return(configuration)
  end

  describe '#report_exception' do
    context 'when the request is successful' do
      let(:successful_response) { double('response', code: 200, body: 'Success') }

      before do
        allow(HTTParty).to receive(:post).and_return(successful_response)
      end

      it 'prints the response body' do
        expect { service.report_exception(exception, request) }.to output("Success\n").to_stdout
      end
    end

    context 'when an error occurs during the request' do
      let(:error_message) { 'HTTP request failed' }

      before do
        allow(HTTParty).to receive(:post).and_raise(StandardError.new(error_message))
      end

      it 'logs the error message' do
        expect(configuration.logger).to receive(:error).with(error_message)
        expect { service.report_exception(exception, request) }.to output("#{error_message}\n").to_stdout
      end
    end
  end
end
