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

      # Encode a non-negative integer to Base58
      #
      # @param integer [Integer] the input integer (must be >= 0)
      # @return [String] the Base58-encoded string
      # @raise [ArgumentError] if the input is negative or not an integer
      def self.encode_int(integer)
        raise ArgumentError, 'input must be a non-negative integer' unless integer.is_a?(Integer) && integer >= 0

        return ALPHABET[0] if integer.zero?

        result = []
        num = integer
        while num.positive?
          num, remainder = num.divmod(BASE)
          result << ALPHABET[remainder]
        end

        result.reverse.join
      end

      # Decode a Base58 string to an integer
      #
      # @param string [String] the Base58-encoded string
      # @return [Integer] the decoded integer
      # @raise [ArgumentError] if the string is empty or contains invalid characters
      def self.decode_int(string)
        raise ArgumentError, 'input must be a non-empty string' if string.nil? || string.empty?

        num = 0
        string.each_char do |char|
          value = DECODE_MAP[char]
          raise ArgumentError, "invalid Base58 character: #{char}" if value.nil?

          num = (num * BASE) + value
        end

        num
      end
    end
  end
end
