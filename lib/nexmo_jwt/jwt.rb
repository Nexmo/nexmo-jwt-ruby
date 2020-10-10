# frozen_string_literal: true

require 'jwt'

module Nexmo
  class JWT
    attr_accessor :generator, :typ, :iat

    def initialize(params = {})
      @generator = params.fetch(:generator)
      @typ = params.fetch(:typ, 'JWT')
      @iat = params.fetch(:iat, Time.now.to_i)
    end

    def generate
      ::JWT.encode(to_payload, generator.private_key, generator.alg)
    end

    def to_payload
      hash = {
        iat: iat,
        jti: generator.jti,
        exp: generator.exp || iat + generator.ttl,
        sub: generator.subject,
        application_id: generator.application_id,
        typ: typ
      }
      hash.merge!(generator.paths) if generator.paths
      hash.merge!(nbf: generator.nbf) if generator.nbf
      hash
    end
  end
end
