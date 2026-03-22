# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::BaseConvert do
  it 'has a version number' do
    expect(Philiprehberger::BaseConvert::VERSION).not_to be_nil
  end

  describe 'Base58' do
    describe '.base58_encode / .base58_decode' do
      it 'roundtrips a simple string' do
        encoded = described_class.base58_encode('Hello World')
        expect(described_class.base58_decode(encoded)).to eq('Hello World')
      end

      it 'roundtrips a single byte' do
        encoded = described_class.base58_encode('A')
        expect(described_class.base58_decode(encoded)).to eq('A')
      end

      it 'preserves leading zero bytes' do
        input = "\x00\x00hello"
        encoded = described_class.base58_encode(input)
        expect(encoded).to start_with('11')
        expect(described_class.base58_decode(encoded)).to eq(input)
      end

      it 'handles empty string' do
        expect(described_class.base58_encode('')).to eq('')
        expect(described_class.base58_decode('')).to eq('')
      end

      it 'produces known encoding for "Hello"' do
        encoded = described_class.base58_encode('Hello')
        decoded = described_class.base58_decode(encoded)
        expect(decoded).to eq('Hello')
      end

      it 'raises error for invalid Base58 characters' do
        expect { described_class.base58_decode('0OIl') }.to raise_error(Philiprehberger::BaseConvert::Error)
      end
    end
  end

  describe 'Base62' do
    describe '.base62_encode / .base62_decode' do
      it 'encodes and decodes zero' do
        expect(described_class.base62_encode(0)).to eq('0')
        expect(described_class.base62_decode('0')).to eq(0)
      end

      it 'roundtrips a small integer' do
        encoded = described_class.base62_encode(123_456)
        expect(described_class.base62_decode(encoded)).to eq(123_456)
      end

      it 'roundtrips a large integer' do
        value = 10**18
        encoded = described_class.base62_encode(value)
        expect(described_class.base62_decode(encoded)).to eq(value)
      end

      it 'raises error for negative input' do
        expect { described_class.base62_encode(-1) }.to raise_error(Philiprehberger::BaseConvert::Error)
      end

      it 'raises error for empty string decode' do
        expect { described_class.base62_decode('') }.to raise_error(Philiprehberger::BaseConvert::Error)
      end
    end
  end

  describe 'Base32 (Crockford)' do
    describe '.base32_encode / .base32_decode' do
      it 'roundtrips a string' do
        encoded = described_class.base32_encode('Hello')
        expect(described_class.base32_decode(encoded)).to eq('Hello')
      end

      it 'is case insensitive on decode' do
        encoded = described_class.base32_encode('Hello')
        expect(described_class.base32_decode(encoded.downcase)).to eq('Hello')
      end

      it 'handles empty string' do
        expect(described_class.base32_encode('')).to eq('')
        expect(described_class.base32_decode('')).to eq('')
      end

      it 'roundtrips binary data' do
        input = "\x01\x02\x03\x04"
        encoded = described_class.base32_encode(input)
        expect(described_class.base32_decode(encoded)).to eq(input)
      end

      it 'raises error for invalid characters' do
        expect { described_class.base32_decode('!!!') }.to raise_error(Philiprehberger::BaseConvert::Error)
      end
    end
  end

  describe '.encode' do
    it 'encodes an integer in binary (base 2)' do
      expect(described_class.encode(10, base: 2)).to eq('1010')
    end

    it 'encodes an integer in hexadecimal (base 16)' do
      expect(described_class.encode(255, base: 16)).to eq('FF')
    end

    it 'encodes an integer in base 36' do
      expect(described_class.encode(35, base: 36)).to eq('Z')
    end

    it 'encodes zero' do
      expect(described_class.encode(0, base: 10)).to eq('0')
    end

    it 'raises an error for negative integers' do
      expect { described_class.encode(-1, base: 10) }.to raise_error(Philiprehberger::BaseConvert::Error)
    end

    it 'raises an error for base below 2' do
      expect { described_class.encode(10, base: 1) }.to raise_error(Philiprehberger::BaseConvert::Error)
    end

    it 'raises an error for base above 62' do
      expect { described_class.encode(10, base: 63) }.to raise_error(Philiprehberger::BaseConvert::Error)
    end
  end

  describe '.decode' do
    it 'decodes a binary string (base 2)' do
      expect(described_class.decode('1010', base: 2)).to eq(10)
    end

    it 'decodes a hexadecimal string (base 16)' do
      expect(described_class.decode('FF', base: 16)).to eq(255)
    end

    it 'decodes a base 36 string' do
      expect(described_class.decode('Z', base: 36)).to eq(35)
    end

    it 'raises an error for invalid characters' do
      expect { described_class.decode('G', base: 16) }.to raise_error(Philiprehberger::BaseConvert::Error)
    end

    it 'raises an error for empty string' do
      expect { described_class.decode('', base: 10) }.to raise_error(Philiprehberger::BaseConvert::Error)
    end

    it 'roundtrips with encode' do
      value = 123_456_789
      encoded = described_class.encode(value, base: 36)
      expect(described_class.decode(encoded, base: 36)).to eq(value)
    end
  end
end
