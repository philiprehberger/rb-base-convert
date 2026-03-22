# frozen_string_literal: true

module Philiprehberger
  module BaseConvert
    # Base62 encoding and decoding
    #
    # Alphabet: 0-9A-Za-z (URL-safe, no special characters)
    module Base62
      ALPHABET = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
      BASE = ALPHABET.length
      DECODE_MAP = ALPHABET.each_char.with_index.to_h.freeze

      # Encode an integer to Base62
      #
      # @param integer [Integer] the input integer (must be >= 0)
      # @return [String] the Base62-encoded string
      # @raise [Error] if the input is negative
      def self.encode(integer)
        raise Error, 'input must be a non-negative integer' unless integer.is_a?(Integer) && integer >= 0

        return ALPHABET[0] if integer.zero?

        result = []
        num = integer

        while num.positive?
          num, remainder = num.divmod(BASE)
          result << ALPHABET[remainder]
        end

        result.reverse.join
      end

      # Decode a Base62 string to an integer
      #
      # @param string [String] the Base62-encoded string
      # @return [Integer] the decoded integer
      # @raise [Error] if the string contains invalid characters
      def self.decode(string)
        raise Error, 'input must be a non-empty string' if string.nil? || string.empty?

        num = 0
        string.each_char do |char|
          value = DECODE_MAP[char]
          raise Error, "invalid Base62 character: #{char}" if value.nil?

          num = (num * BASE) + value
        end

        num
      end
    end
  end
end
