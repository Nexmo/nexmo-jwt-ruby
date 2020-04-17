require 'securerandom'
require 'openssl'
require 'jwt'

module NexmoJwt
  class Generator
    # Generate an encoded JSON Web Token.
    #
    # By default the Nexmo JWT generator creates a short lived (15 minutes) JWT per request.
    #
    # To generate a long lived JWT for multiple requests, specify a longer value in the `iat`
    # parameter in the `claims` object. 
    #
    # @example
    #   claims = {
    #     application_id: application_id,
    #     nbf: 1483315200,
    #     exp: 1514764800,
    #     iat: 1483228800
    #   }
    #
    #   private_key = File.read('path/to/private.key')
    #
    #   token = NexmoJWT::Generator.generate(claims, private_key)
    #
    # @param [Hash] payload
    # @param [String, OpenSSL::PKey::RSA] private_key
    #
    # @return [String]
    #
    def self.generate(payload, private_key)
      payload[:iat] = iat = Time.now.to_i unless payload.key?(:iat) || payload.key?('iat')
      payload[:exp] = iat + 60 unless payload.key?(:exp) || payload.key?('exp')
      payload[:jti] = SecureRandom.uuid unless payload.key?(:jti) || payload.key?('jti')

      private_key = OpenSSL::PKey::RSA.new(private_key) unless private_key.respond_to?(:sign)

      ::JWT.encode(payload, private_key, 'RS256')
    end
  end
end