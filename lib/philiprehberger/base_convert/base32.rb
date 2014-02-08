# frozen_string_literal: true

module Philiprehberger
  module BaseConvert
    # Crockford Base32 encoding and decoding
    #
    # Alphabet: 0123456789ABCDEFGHJKMNPQRSTVWXYZ
    # Case-insensitive decoding, excludes I, L, O, U
    module Base32
      ALPHABET = '0123456789ABCDEFGHJKMNPQRSTVWXYZ'
      DECODE_MAP = ALPHABET.each_char.with_index.each_with_object({}) do |(char, idx), map|
        map[char] = idx
        map[char.downcase] = idx
      end.merge(
        'I' => 1, 'i' => 1,
        'L' => 1, 'l' => 1,
        'O' => 0, 'o' => 0
      ).freeze

      # Encode a string to Crockford Base32
      #
      # @param string [String] the input string
      # @return [String] the Base32-encoded string
      def self.encode(string)
        return '' if string.empty?

        bytes = string.bytes
        result = []
        buffer = 0
        bits_left = 0

        bytes.each do |byte|
          buffer = (buffer << 8) | byte
          bits_left += 8

          while bits_left >= 5
            bits_left -= 5
            result << ALPHABET[(buffer >> bits_left) & 0x1F]
          end
        end

        result << ALPHABET[(buffer << (5 - bits_left)) & 0x1F] if bits_left.positive?

        result.join
      end

      # Decode a Crockford Base32 string
      #
      # @param string [String] the Base32-encoded string
      # @return [String] the decoded string
      # @raise [Error] if the string contains invalid characters
      def self.decode(string)
        return '' if string.empty?

        string = string.delete('-')

        buffer = 0
        bits_left = 0
        result = []

        string.each_char do |char|
          value = DECODE_MAP[char]
          raise Error, "invalid Base32 character: #{char}" if value.nil?

          buffer = (buffer << 5) | value
          bits_left += 5

          if bits_left >= 8
            bits_left -= 8
            result << ((buffer >> bits_left) & 0xFF)
          end
        end

        result.pack('C*')
      end
    end
  end
end
