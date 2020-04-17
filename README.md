# Nexmo JWT Generator for Ruby

[![Gem Version](https://badge.fury.io/rb/nexmo-jwt.svg)](https://badge.fury.io/rb/nexmo-jwt) [![Build Status](https://api.travis-ci.org/Nexmo/nexmo-jwt-ruby.svg?branch=master)](https://travis-ci.org/Nexmo/nexmo-jwt-ruby) [![Coverage Status](https://coveralls.io/repos/github/Nexmo/nexmo-jwt-ruby/badge.svg?branch=coveralls)](https://coveralls.io/github/Nexmo/nexmo-jwt-ruby?branch=master)[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

<img src="https://developer.nexmo.com/assets/images/Vonage_Nexmo.svg" height="48px" alt="Nexmo is now known as Vonage" />

This is the Ruby library to generate Nexmo JSON Web Tokens (JWTs). To use it you'll
need a Nexmo account. Sign up [for free at nexmo.com][signup].

* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Documentation](#documentation)
* [License](#license)

## Requirements

The JWT generator supports Ruby version 2.5 or newer.

## Installation

To install the Ruby client library using Rubygems:

    gem install nexmo-jwt

Alternatively you can clone the repository:

    git clone git@github.com:Nexmo/nexmo-jwt-ruby.git

## Usage

By default the Nexmo JWT generator creates a short lived JWT (15 minutes) per request.
To generate a long lived JWT for multiple requests, specify a longer value in the `iat`
parameter in the `claims` object.

```ruby
claims = {
  application_id: application_id,
  nbf: 1483315200,
  exp: 1514764800,
  iat: 1483228800
}

private_key = File.read('path/to/private.key')

token = NexmoJwt::Generator.generate(claims, private_key)
````

## Documentation

Nexmo Ruby JWT documentation: https://www.rubydoc.info/github/nexmo/nexmo-jwt

Nexmo Ruby code examples: https://github.com/Nexmo/nexmo-ruby-code-snippets

Nexmo API reference: https://developer.nexmo.com/api

## License

This library is released under the [MIT License][license]

[signup]: https://dashboard.nexmo.com/sign-up?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[license]: LICENSE.txt