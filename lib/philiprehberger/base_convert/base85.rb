# frozen_string_literal: true

module Philiprehberger
  module BaseConvert
    # ASCII85 (Base85) encoding and decoding
    #
    # Uses the standard ASCII85 character set (chars 33-117)
    module Base85
      ENCODE_OFFSET = 33
      BASE = 85

      # Encode a string to ASCII85
      #
      # @param string [String] the input string
      # @return [String] the ASCII85-encoded string
      def self.encode(string)
        return '' if string.empty?

        padding = (4 - (string.bytesize % 4)) % 4
        padded = string + ("\x00" * padding)

        result = []
        padded.bytes.each_slice(4) do |group|
          value = (group[0] << 24) | (group[1] << 16) | (group[2] << 8) | group[3]

          if value.zero?
            result << 'z'
          else
            chunk = []
            5.times do
              chunk << ((value % BASE) + ENCODE_OFFSET).chr
              value /= BASE
            end
            result << chunk.reverse.join
          end
        end

        encoded = result.join
        encoded = encoded[0...(encoded.length - padding)] if padding.positive?
        encoded
      end

      # Decode an ASCII85 string
      #
      # @param string [String] the ASCII85-encoded string
      # @return [String] the decoded string
      # @raise [Error] if the string contains invalid characters
      def self.decode(string)
        return '' if string.empty?

        expanded = string.gsub('z', '!!!!!')
        padding = (5 - (expanded.length % 5)) % 5
        expanded += ('u' * padding)

        result = []
        expanded.each_char.each_slice(5) do |group|
          value = 0
          group.each do |char|
            code = char.ord - ENCODE_OFFSET
            raise Error, "invalid Base85 character: #{char}" if code.negative? || code >= BASE

            value = (value * BASE) + code
          end

          result << [(value >> 24) & 0xFF, (value >> 16) & 0xFF, (value >> 8) & 0xFF, value & 0xFF]
        end

        decoded = result.flatten.pack('C*')
        decoded = decoded[0...(decoded.length - padding)] if padding.positive?
        decoded
      end
    end
  end
end
