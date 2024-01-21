# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ErrorPulse::Configuration do
  subject { ErrorPulse::Configuration.new }

  it 'allows reading and writing for :api_key' do
    subject.api_key = 'test_key'
    expect(subject.api_key).to eq('test_key')
  end

  it 'allows reading and writing for :api_endpoint' do
    subject.api_endpoint = 'http://example.com'
    expect(subject.api_endpoint).to eq('http://example.com')
  end

  describe '.configuration' do
    it 'returns a Configuration instance' do
      expect(ErrorPulse.configuration).to be_instance_of(ErrorPulse::Configuration)
    end

    it 'memoizes the Configuration instance' do
      first_call = ErrorPulse.configuration
      second_call = ErrorPulse.configuration
      expect(first_call).to be(second_call)
    end
  end

  describe '.configure' do
    it 'yields the configuration to a block' do
      expect { |b| ErrorPulse.configure(&b) }.to yield_with_args(ErrorPulse::Configuration)
    end
  end

  describe '#logger' do
    it 'defaults to a Logger instance that outputs to STDOUT' do
      expect(subject.logger).to be_a(Logger)
      expect(subject.logger.instance_variable_get(:@logdev).dev).to eq($stdout)
    end

    it 'allows setting a custom logger' do
      custom_logger = Logger.new($stderr)
      subject.logger = custom_logger
      expect(subject.logger).to eq(custom_logger)
    end
  end
end
