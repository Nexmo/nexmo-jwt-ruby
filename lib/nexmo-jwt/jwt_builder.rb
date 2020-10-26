# frozen_string_literal: true

require 'openssl'
require 'securerandom'
require_relative 'jwt'

module Nexmo
  class JWTBuilder
    # Generate an encoded JSON Web Token.
    #
    # By default the Nexmo JWT generator creates a short lived (15 minutes) JWT per request.
    #
    # To generate a long lived JWT for multiple requests, specify a longer value in the `exp`
    # parameter during initialization.
    #
    # Example with no custom configuration:
    #
    # @example
    #   @builder = Nexmo::JWTBuilder.new(application_id: YOUR_APPLICATION_ID, private_key: YOUR_PRIVATE_KEY)
    #   @token = @builder.jwt.generate
    #
    # Example providing custom configuration options:
    #
    # @example
    #   @generator = Nexmo::JWTBuilder.new(
    #     application_id: YOUR_APPLICATION_ID,
    #     private_key: YOUR_PRIVATE_KEY,
    #     ttl: 500,
    #     subject: 'My_Custom_Subject'
    #   )
    #   @token = @builder.jwt.generate
    #
    # @param [String] application_id
    # @param [Integer] iat
    # @param [SecureRandom::UUIDv4] jti
    # @param [Integer] nbf
    # @param [Integer] exp
    # @param [Hash] paths
    # @param [String] sub
    # @param [String, OpenSSL::PKey::RSA] private_key
    #
    # @return [String]
    #
    attr_accessor :application_id, :private_key, :jti, :nbf, :ttl, :exp, :alg, :paths, :subject, :jwt

    def initialize(params = {})
      Nexmo::JWTBuilder.validate_parameters_not_conflicting(params)

      @application_id = set_application_id(params.fetch(:application_id))
      @private_key = set_private_key(params.fetch(:private_key))
      @jti = params.fetch(:jti, SecureRandom.uuid)
      @nbf = params.fetch(:nbf, nil)
      @ttl = params.fetch(:ttl, 900)
      @exp = params.fetch(:exp, nil)
      @alg = params.fetch(:alg, 'RS256')
      @paths = params.fetch(:paths, nil)
      @subject = params.fetch(:subject, 'Subject')
      @jwt = Nexmo::JWT.new(generator: self)

      after_initialize!(self)
    end

    def self.validate_parameters_not_conflicting(params)
      return unless params[:ttl] && params[:exp]

      raise ArgumentError, "Expected either 'ttl' or 'exp' parameter, preference is to set 'ttl' parameter"
    end

    def after_initialize!(builder)
      validate_not_before(builder.nbf) if builder.nbf
      validate_time_to_live(builder.ttl)
      validate_paths(builder.paths) if builder.paths
      validate_subject(builder.subject) if builder.subject
    end

    def set_application_id(application_id)
      validate_application_id(application_id)

      application_id
    end

    def set_private_key(private_key)
      validate_private_key(private_key)

      if File.exist?(private_key)
        OpenSSL::PKey::RSA.new(File.read(private_key))
      else
        OpenSSL::PKey::RSA.new(private_key)
      end
    end

    def set_exp
      Time.now.to_i
    end

    def validate_application_id(application_id)
      raise ArgumentError, "Missing required 'application_id' parameter" if application_id.nil?
    end

    def validate_private_key(private_key)
      raise ArgumentError, "Missing required 'private_key' parameter" if private_key.nil?
    end

    def validate_not_before(nbf)
      raise ArgumentError, "Expected Integer parameter type for NotBefore 'nbf' parameter" unless nbf.is_a?(Integer)
    end

    def validate_time_to_live(ttl)
      raise ArgumentError, "Expected Integer parameter type for TimeToLive 'ttl' parameter" unless ttl.is_a?(Integer)
    end

    def validate_paths(acl_paths)
      raise ArgumentError, "Expected Hash parameter type for Paths 'paths' parameter" unless acl_paths.is_a?(Hash)
    end

    def validate_subject(subject)
      raise ArgumentError, "Expected String parameter type for Subject 'subject' parameter" unless subject.is_a?(String)
    end
  end
end
