# frozen_string_literal: true

module Philiprehberger
  module BaseConvert
    # Base58 encoding and decoding using the Bitcoin alphabet
    #
    # Alphabet: 123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz
    module Base58
      ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
      BASE = ALPHABET.length
      DECODE_MAP = ALPHABET.each_char.with_index.to_h.freeze

      # Encode a string to Base58
      #
      # @param string [String] the input string
      # @return [String] the Base58-encoded string
      def self.encode(string)
        return '' if string.empty?

        bytes = string.bytes
        leading_zeros = bytes.take_while(&:zero?).length

        num = bytes.inject(0) { |acc, byte| (acc << 8) | byte }

        result = []
        while num.positive?
          num, remainder = num.divmod(BASE)
          result << ALPHABET[remainder]
        end

        (ALPHABET[0] * leading_zeros) + result.reverse.join
      end

      # Decode a Base58 string
      #
      # @param string [String] the Base58-encoded string
      # @return [String] the decoded string
      # @raise [Error] if the string contains invalid characters
      def self.decode(string)
        return '' if string.empty?

        leading_ones = string.each_char.take_while { |c| c == ALPHABET[0] }.length

        num = 0
        string.each_char do |char|
          value = DECODE_MAP[char]
          raise Error, "invalid Base58 character: #{char}" if value.nil?

          num = (num * BASE) + value
        end

        result = []
        while num.positive?
          num, byte = num.divmod(256)
          result << byte
        end

        ("\x00" * leading_ones) + result.reverse.pack('C*')
      end
    end
  end
end
