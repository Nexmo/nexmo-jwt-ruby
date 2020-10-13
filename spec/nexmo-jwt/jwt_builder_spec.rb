require_relative 'spec_helper'

describe Nexmo::JWTBuilder do
  context 'without custom configuration block' do
    before :each do
      @builder = Nexmo::JWTBuilder.new(application_id: '123456789', private_key: './spec/nexmo-jwt/private_key.txt')
      token = @builder.jwt.generate
      @decoded_token = JWT.decode(token, nil, nil, { algorithm: 'RS256' }).first
    end

    it 'instantiates an instance of Nexmo::JWTBuilder' do
      expect(@builder).to be_an_instance_of(Nexmo::JWTBuilder)
    end

    it 'includes an application_id method on the instantiated object' do
      expect(@builder.methods).to include(:application_id)
    end

    it 'includes a private_key method on the instantiated object' do
      expect(@builder.methods).to include(:private_key)
    end

    it 'has a private_key value set as an instance of OpenSSL::PKey::RSA' do
      expect(@builder.private_key).to be_an_instance_of(OpenSSL::PKey::RSA)
    end

    it 'generates a JWT string with the data provided' do
      expect(@decoded_token['application_id']).to eql('123456789')
    end

    it 'does not include optional configuration options not set' do
      expect(@decoded_token).to_not have_key(:nbf)
    end
  end

  context 'with custom configuration block' do
    before :each do
      @builder = Nexmo::JWTBuilder.new(
        application_id: '123456789',
        private_key: './spec/nexmo-jwt/private_key.txt',
        subject: 'ExampleApp',
        paths: {
          'acl' => {
            'paths' => {
              '/messages' => {
                'methods' => ['POST', 'GET'],
                'filters' => {
                  'from' => '447977271009'
                }
              }
            }
          }
        }
      )
      token = @builder.jwt.generate
      @decoded_token = JWT.decode(token, nil, nil, { algorithm: 'RS256' }).first
    end

    it 'instantiates an instance of Nexmo::JWTBuilder' do
      expect(@builder).to be_an_instance_of(Nexmo::JWTBuilder)
    end

    it 'includes an application_id method on the instantiated object' do
      expect(@builder.methods).to include(:application_id)
    end

    it 'includes a private_key method on the instantiated object' do
      expect(@builder.methods).to include(:private_key)
    end

    it 'includes a sub method on the instantiated object' do
      expect(@builder.methods).to include(:subject)
    end

    it 'includes a paths method on the instantiated object' do
      expect(@builder.methods).to include(:paths)
    end

    it 'has a private_key value set as an instance of OpenSSL::PKey::RSA' do
      expect(@builder.private_key).to be_an_instance_of(OpenSSL::PKey::RSA)
    end

    it 'generates a JWT string with the data provided' do
      expect(@decoded_token['paths']).to be_nil
      expect(@decoded_token['acl']).to eql("paths"=>{"/messages"=>{"methods"=>["POST", "GET"], "filters"=>{"from"=>"447977271009"}}})
      expect(@decoded_token['sub']).to eql('ExampleApp')
    end

    it 'generates a JWT with proper formation' do
      expect(@decoded_token).to match(
        hash_including(
          {
            "sub"=>"ExampleApp",
            "application_id"=>"123456789",
            "typ"=>"JWT",
            "acl"=> { "paths" => { "/messages" => { "methods" => ["POST", "GET"], "filters"=> {"from" => "447977271009" } } } }
          }
        )
      )
    end

    it 'generates a JWT without path key' do
      expect(@decoded_token.keys).not_to include("paths")
    end
  end

  context 'with exp parameter provided in custom configuration block' do
    before :each do
      @builder = Nexmo::JWTBuilder.new(
        application_id: '123456789',
        private_key: './spec/nexmo-jwt/private_key.txt',
        exp: 600
      )
    end

    it 'includes the custom defined exp parameter in the builder' do
      expect(@builder.exp).to eql(600)
    end
  end

  context 'without exp parameter provided in configuration block' do
    before :each do
      @builder = Nexmo::JWTBuilder.new(application_id: '123456789', private_key: './spec/nexmo-jwt/private_key.txt')
    end

    it 'sets exp parameter to equal nil' do
      expect(@builder.exp).to eql(nil)
    end

    it 'sets exp parameter in JWT class to equal the value of the ttl and iat parameters added together' do
      @builder.jwt.iat = 1595222754
      hash = @builder.jwt.to_payload
      expect(hash[:exp]).to eql(1595222754 + 900)
    end
   end

  context 'with incorrect data types for custom configuration block' do
    it 'raises an ArgumentError if nbf parameter is not an Integer' do
      expect {
        builder = Nexmo::JWTBuilder.new(
          application_id: '123456789',
          private_key: './spec/nexmo-jwt/private_key.txt',
          nbf: '123'
        )
      }.to raise_error(ArgumentError, "Expected Integer parameter type for NotBefore 'nbf' parameter")
    end

    it 'raises an ArgumentError if ttl parameter is not an Integer' do
      expect {
        builder = Nexmo::JWTBuilder.new(
          application_id: '123456789',
          private_key: './spec/nexmo-jwt/private_key.txt',
          ttl: '300'
        )
      }.to raise_error(ArgumentError, "Expected Integer parameter type for TimeToLive 'ttl' parameter")
    end

    it 'raises an ArgumentError if acl_paths parameter is not a Hash' do
      expect {
        builder = Nexmo::JWTBuilder.new(
          application_id: '123456789',
          private_key: './spec/nexmo-jwt/private_key.txt',
          paths: ['not', 'a', 'hash']
        )
      }.to raise_error(ArgumentError, "Expected Hash parameter type for Paths 'paths' parameter")
    end

    it 'raises an ArgumentError if sub parameter is not a String' do
      expect {
        builder = Nexmo::JWTBuilder.new(
          application_id: '123456789',
          private_key: './spec/nexmo-jwt/private_key.txt',
          subject: 123
        )
      }.to raise_error(ArgumentError, "Expected String parameter type for Subject 'subject' parameter")
    end
  end

  context 'with missing application_id parameter' do
    it 'raises a custom exception if Nil provided' do
      expect {
        builder = Nexmo::JWTBuilder.new(application_id: nil, private_key: './spec/nexmo-jwt/private_key.txt')
      }.to raise_error(ArgumentError, "Missing required 'application_id' parameter")
    end

    it 'raises an exception of wrong number of parameters if not specified at all' do
      expect {
        builder = Nexmo::JWTBuilder.new(private_key: './spec/nexmo-jwt/private_key.txt')
      }.to raise_error(KeyError, "key not found: :application_id")
    end
  end

  context 'with missing private_key parameter' do
    it 'raises a custom exception if Nil provided' do
      expect {
        builder = Nexmo::JWTBuilder.new(application_id: '123456789', private_key: nil)
      }.to raise_error(ArgumentError, "Missing required 'private_key' parameter")
    end

    it 'raises an exception of wrong number of parameters if not specified at all' do
      expect {
        builder = Nexmo::JWTBuilder.new(application_id: '123456789')
      }.to raise_error(KeyError, "key not found: :private_key")
    end
  end

  context 'with conflicting parameters' do
    it 'raises a custom exception if ttl and exp params both provided' do
      expect {
        builder = Nexmo::JWTBuilder.new(
          application_id: '123456789',
          private_key: './spec/nexmo-jwt/private_key.txt',
          ttl: 500,
          exp: 600
        )
      }.to raise_error(ArgumentError, "Expected either 'ttl' or 'exp' parameter, preference is to set 'ttl' parameter")
    end
  end
end
