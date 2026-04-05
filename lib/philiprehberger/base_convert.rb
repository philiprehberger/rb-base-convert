# frozen_string_literal: true

require_relative 'base_convert/version'
require_relative 'base_convert/base32'
require_relative 'base_convert/base58'
require_relative 'base_convert/base62'
require_relative 'base_convert/base85'

module Philiprehberger
  module BaseConvert
    class Error < StandardError; end

    GENERIC_ALPHABET = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

    # Encode a string to Base58 (Bitcoin alphabet)
    #
    # @param string [String] the input string
    # @return [String] the Base58-encoded string
    def self.base58_encode(string)
      Base58.encode(string)
    end

    # Decode a Base58 string
    #
    # @param string [String] the Base58-encoded string
    # @return [String] the decoded string
    # @raise [Error] if the string contains invalid characters
    def self.base58_decode(string)
      Base58.decode(string)
    end

    # Encode an integer to Base62
    #
    # @param integer [Integer] the input integer (must be >= 0)
    # @return [String] the Base62-encoded string
    # @raise [Error] if the input is negative
    def self.base62_encode(integer)
      Base62.encode(integer)
    end

    # Decode a Base62 string to an integer
    #
    # @param string [String] the Base62-encoded string
    # @return [Integer] the decoded integer
    # @raise [Error] if the string contains invalid characters
    def self.base62_decode(string)
      Base62.decode(string)
    end

    # Encode a string to Crockford Base32
    #
    # @param string [String] the input string
    # @return [String] the Base32-encoded string
    def self.base32_encode(string)
      Base32.encode(string)
    end

    # Decode a Crockford Base32 string
    #
    # @param string [String] the Base32-encoded string
    # @return [String] the decoded string
    # @raise [Error] if the string contains invalid characters
    def self.base32_decode(string)
      Base32.decode(string)
    end

    # Encode a string to ASCII85
    #
    # @param string [String] the input string
    # @return [String] the ASCII85-encoded string
    def self.base85_encode(string)
      Base85.encode(string)
    end

    # Decode an ASCII85 string
    #
    # @param string [String] the ASCII85-encoded string
    # @return [String] the decoded string
    # @raise [Error] if the string contains invalid characters
    def self.base85_decode(string)
      Base85.decode(string)
    end

    # Encode a string to hexadecimal
    #
    # @param string [String] the input string
    # @return [String] the hex-encoded string
    # @raise [Error] if the input is nil
    def self.hex_encode(string)
      raise Error, 'input cannot be nil' if string.nil?

      string.unpack1('H*')
    end

    # Decode a hexadecimal string
    #
    # @param string [String] the hex-encoded string
    # @return [String] the decoded string
    # @raise [Error] if the input is nil, empty, odd-length, or contains invalid characters
    def self.hex_decode(string)
      raise Error, 'input cannot be nil' if string.nil?
      raise Error, 'input cannot be empty' if string.empty?
      raise Error, 'invalid hex string: odd length' if string.length.odd?
      raise Error, "invalid hex character in: #{string}" unless string.match?(/\A[0-9a-fA-F]+\z/)

      [string].pack('H*')
    end

    # Encode an integer in an arbitrary base (2-62)
    #
    # @param integer [Integer] the input integer (must be >= 0)
    # @param base [Integer] the target base (2-62)
    # @return [String] the encoded string
    # @raise [Error] if the base is out of range or input is negative
    def self.encode(integer, base:)
      raise Error, 'base must be between 2 and 62' unless base.between?(2, 62)
      raise Error, 'input must be a non-negative integer' unless integer.is_a?(Integer) && integer >= 0

      return GENERIC_ALPHABET[0] if integer.zero?

      alphabet = GENERIC_ALPHABET[0, base]
      result = []
      num = integer

      while num.positive?
        num, remainder = num.divmod(base)
        result << alphabet[remainder]
      end

      result.reverse.join
    end

    # Decode a string from an arbitrary base (2-62) to an integer
    #
    # @param string [String] the encoded string
    # @param base [Integer] the source base (2-62)
    # @return [Integer] the decoded integer
    # @raise [Error] if the base is out of range or string contains invalid characters
    def self.decode(string, base:)
      raise Error, 'base must be between 2 and 62' unless base.between?(2, 62)
      raise Error, 'input must be a non-empty string' if string.nil? || string.empty?

      alphabet = GENERIC_ALPHABET[0, base]
      num = 0

      string.each_char do |char|
        value = alphabet.index(char)
        raise Error, "invalid character for base #{base}: #{char}" if value.nil?

        num = (num * base) + value
      end

      num
    end
  end
end
