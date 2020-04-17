require_relative './test'
require_relative '../../lib/nexmo-jwt/generator'

class NexmoJwt::GeneratorTest < Minitest::Test
  def private_key
    @private_key ||= OpenSSL::PKey::RSA.new(1024)
  end

  def application_id
    @application_id ||= SecureRandom.uuid
  end

  def uuid_pattern
    /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/
  end

  def decode(token)
    JWT.decode(token, private_key, _verify=true, {algorithm: 'RS256'}).first
  end

  def test_generate_method_returns_payload_encoded_with_private_key
    time = Time.now.to_i

    payload = {
      'application_id' => application_id,
      'iat' => time,
      'exp' => time + 3600,
      'jti' => 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    }

    token = NexmoJwt::Generator.generate(payload, private_key)

    assert_equal decode(token), payload
  end

  def test_generate_method_sets_default_value_for_iat_parameter
    token = NexmoJwt::Generator.generate({}, private_key)

    assert_kind_of Integer, decode(token).fetch('iat')
  end

  def test_generate_method_sets_default_value_for_exp_parameter
    token = NexmoJwt::Generator.generate({}, private_key)

    assert_kind_of Integer, decode(token).fetch('exp')
  end

  def test_generate_method_sets_default_value_for_jti_parameter
    token = NexmoJwt::Generator.generate({}, private_key)

    assert_match uuid_pattern, decode(token).fetch('jti')
  end
end
