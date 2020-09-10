# Nexmo JWT Generator for Ruby

[![Gem Version](https://badge.fury.io/rb/nexmo-jwt.svg)](https://badge.fury.io/rb/nexmo-jwt)![Coverage Status](https://github.com/nexmo/nexmo-jwt-ruby/workflows/CI/badge.svg)[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

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
To generate a long lived JWT for multiple requests, specify a longer value in the `exp`
parameter during initialization. 

Example with no custom configuration:

```ruby
@builder = Nexmo::JWTBuilder.new(application_id: YOUR_APPLICATION_ID, private_key: YOUR_PRIVATE_KEY)
@token = @builder.jwt.generate
```

Example providing custom configuration options:

```ruby
@builder = Nexmo::JWTBuilder.new(
  application_id: YOUR_APPLICATION_ID,
  private_key: YOUR_PRIVATE_KEY,
  ttl: 500,
  paths: {
    "acl": {
      "paths": {
        "/messages": {
          "methods": ["POST", "GET"],
          "filters": {
            "from": "447977271009"  
          }     
        }  
      }   
    }
  },
  subject: 'My_Custom_Subject'
)
@token = @builder.jwt.generate
```

## Documentation

Nexmo Ruby JWT documentation: https://www.rubydoc.info/github/nexmo/nexmo-jwt

Nexmo Ruby code examples: https://github.com/Vonage/vonage-ruby-code-snippets

Nexmo API reference: https://developer.nexmo.com/api

## License

This library is released under the [MIT License][license]

[signup]: https://dashboard.nexmo.com/sign-up?utm_source=DEV_REL&utm_medium=github&utm_campaign=ruby-client-library
[license]: LICENSE.txt
