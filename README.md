# philiprehberger-base_convert

[![Tests](https://github.com/philiprehberger/rb-base-convert/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-base-convert/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-base_convert.svg)](https://rubygems.org/gems/philiprehberger-base_convert)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-base-convert)](https://github.com/philiprehberger/rb-base-convert/commits/main)

Multi-format base encoding with Base32, Base58, Base62, and Base85 support

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-base_convert"
```

Or install directly:

```bash
gem install philiprehberger-base_convert
```

## Usage

```ruby
require "philiprehberger/base_convert"

# Base58 (Bitcoin alphabet) — encode/decode strings
encoded = Philiprehberger::BaseConvert.base58_encode('Hello World')
decoded = Philiprehberger::BaseConvert.base58_decode(encoded)
```

### Base62

Encode and decode integers using the URL-safe `0-9A-Za-z` alphabet:

```ruby
Philiprehberger::BaseConvert.base62_encode(123_456)   # => "W7E"
Philiprehberger::BaseConvert.base62_decode('W7E')      # => 123456
```

### Base32 (Crockford)

Case-insensitive encoding that excludes I, L, O, U to avoid ambiguity:

```ruby
Philiprehberger::BaseConvert.base32_encode('Hello')  # => "91JPRV3F"
Philiprehberger::BaseConvert.base32_decode('91JPRV3F') # => "Hello"
```

### Base85 (ASCII85)

Compact binary-to-text encoding:

```ruby
Philiprehberger::BaseConvert.base85_encode('Hello')  # => "87cURDZ"
Philiprehberger::BaseConvert.base85_decode('87cURDZ') # => "Hello"
```

### Arbitrary Base

Encode and decode integers in any base from 2 to 62:

```ruby
Philiprehberger::BaseConvert.encode(255, base: 16)   # => "FF"
Philiprehberger::BaseConvert.decode('FF', base: 16)   # => 255
Philiprehberger::BaseConvert.encode(42, base: 2)      # => "101010"
```

## API

| Method | Description |
|--------|-------------|
| `BaseConvert.base58_encode(string)` | Encode a string to Base58 (Bitcoin alphabet) |
| `BaseConvert.base58_decode(string)` | Decode a Base58 string |
| `BaseConvert.base62_encode(integer)` | Encode an integer to Base62 |
| `BaseConvert.base62_decode(string)` | Decode a Base62 string to an integer |
| `BaseConvert.base32_encode(string)` | Encode a string to Crockford Base32 |
| `BaseConvert.base32_decode(string)` | Decode a Crockford Base32 string |
| `BaseConvert.base85_encode(string)` | Encode a string to ASCII85 |
| `BaseConvert.base85_decode(string)` | Decode an ASCII85 string |
| `BaseConvert.encode(integer, base:)` | Encode an integer in an arbitrary base (2-62) |
| `BaseConvert.decode(string, base:)` | Decode a string from an arbitrary base to an integer |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-base-convert)

🐛 [Report issues](https://github.com/philiprehberger/rb-base-convert/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-base-convert/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
