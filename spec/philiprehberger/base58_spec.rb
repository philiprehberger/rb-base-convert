# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::BaseConvert::Base58 do
  describe '.encode' do
    it 'encodes a simple string' do
      encoded = described_class.encode('Hello World')
      expect(encoded).to eq('JxF12TrwUP45BMd')
    end

    it 'returns an empty string for empty input' do
      expect(described_class.encode('')).to eq('')
    end

    it 'preserves leading zero bytes' do
      encoded = described_class.encode("\x00\x00Hello")
      expect(encoded).to start_with('11')
    end

    it 'encodes a single byte' do
      encoded = described_class.encode("\x01")
      expect(encoded).to eq('2')
    end
  end

  describe '.decode' do
    it 'decodes a Base58 string' do
      decoded = described_class.decode('JxF12TrwUP45BMd')
      expect(decoded).to eq('Hello World')
    end

    it 'returns an empty string for empty input' do
      expect(described_class.decode('')).to eq('')
    end

    it 'preserves leading zero bytes' do
      decoded = described_class.decode('11JxF12TrwUP45BMd')
      expect(decoded).to start_with("\x00\x00")
      expect(decoded[2..]).to eq('Hello World')
    end

    it 'raises an error for invalid characters' do
      expect { described_class.decode('0OlI') }.to raise_error(Philiprehberger::BaseConvert::Error)
    end
  end

  describe 'roundtrip' do
    it 'roundtrips a simple string' do
      original = 'Hello World'
      expect(described_class.decode(described_class.encode(original))).to eq(original)
    end

    it 'roundtrips binary data' do
      original = (0..255).to_a.pack('C*')
      expect(described_class.decode(described_class.encode(original))).to eq(original)
    end

    it 'roundtrips a string with leading zeros' do
      original = "\x00\x00\x00test"
      expect(described_class.decode(described_class.encode(original))).to eq(original)
    end
  end

  describe 'module-level methods' do
    it 'delegates base58_encode' do
      expect(Philiprehberger::BaseConvert.base58_encode('Hello')).to eq(described_class.encode('Hello'))
    end

    it 'delegates base58_decode' do
      encoded = described_class.encode('Hello')
      expect(Philiprehberger::BaseConvert.base58_decode(encoded)).to eq('Hello')
    end
  end

  describe '.encode_int' do
    it 'returns "1" for zero' do
      expect(described_class.encode_int(0)).to eq('1')
    end

    it 'encodes 57 as the last character of the alphabet' do
      expect(described_class.encode_int(57)).to eq('z')
    end

    it 'encodes 1 as "2"' do
      expect(described_class.encode_int(1)).to eq('2')
    end

    it 'encodes 123_456_789 as "BukQL"' do
      expect(described_class.encode_int(123_456_789)).to eq('BukQL')
    end

    it 'raises ArgumentError for negative integers' do
      expect { described_class.encode_int(-1) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError for non-integer input' do
      expect { described_class.encode_int('x') }.to raise_error(ArgumentError)
    end
  end

  describe '.decode_int' do
    it 'decodes "1" to 0' do
      expect(described_class.decode_int('1')).to eq(0)
    end

    it 'decodes "z" to 57' do
      expect(described_class.decode_int('z')).to eq(57)
    end

    it 'raises ArgumentError for empty input' do
      expect { described_class.decode_int('') }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError for characters outside the alphabet' do
      expect { described_class.decode_int('0') }.to raise_error(ArgumentError)
    end
  end

  describe 'integer roundtrip' do
    [0, 1, 57, 1000, 123_456_789, 123_456_789_012_345].each do |value|
      it "roundtrips #{value}" do
        expect(described_class.decode_int(described_class.encode_int(value))).to eq(value)
      end
    end
  end

  describe 'integer module-level methods' do
    it 'delegates base58_encode_int' do
      expect(Philiprehberger::BaseConvert.base58_encode_int(123_456_789)).to eq('BukQL')
    end

    it 'delegates base58_decode_int' do
      expect(Philiprehberger::BaseConvert.base58_decode_int('BukQL')).to eq(123_456_789)
    end
  end
end
