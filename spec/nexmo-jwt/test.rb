# typed: ignore
require 'simplecov'

SimpleCov.start do
  add_filter 'spec/nexmo-jwt'
end

require 'minitest/autorun'
require_relative '../../lib/nexmo-jwt'

module NexmoJwt
  class Test < Minitest::Test
    def setup
      super

      @request_stubs = []
    end

    def stub_request(*args)
      super.tap do |stub|
        @request_stubs << stub
      end
    end

    def teardown
      @request_stubs.each do |stub|
        assert_requested(stub, at_least_times: 1)
      end

      super
    end

    def application_id
      'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    end

    def private_key
      File.read(File.expand_path(File.join(File.dirname(__FILE__), '..', 'private_key.txt')))
    end
  end
end
