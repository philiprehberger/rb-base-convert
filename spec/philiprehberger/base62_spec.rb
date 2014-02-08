# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::BaseConvert::Base62 do
  describe '.encode' do
    it 'encodes zero' do
      expect(described_class.encode(0)).to eq('0')
    end

    it 'encodes a small integer' do
      expect(described_class.encode(61)).to eq('z')
    end

    it 'encodes a larger integer' do
      expect(described_class.encode(62)).to eq('10')
    end

    it 'encodes a large number' do
      expect(described_class.encode(238_328)).to eq('1000')
    end

    it 'raises an error for negative integers' do
      expect { described_class.encode(-1) }.to raise_error(Philiprehberger::BaseConvert::Error)
    end

    it 'raises an error for non-integer input' do
      expect { described_class.encode('abc') }.to raise_error(Philiprehberger::BaseConvert::Error)
    end
  end

  describe '.decode' do
    it 'decodes a single character' do
      expect(described_class.decode('z')).to eq(61)
    end

    it 'decodes a multi-character string' do
      expect(described_class.decode('10')).to eq(62)
    end

    it 'decodes zero' do
      expect(described_class.decode('0')).to eq(0)
    end

    it 'raises an error for invalid characters' do
      expect { described_class.decode('!@#') }.to raise_error(Philiprehberger::BaseConvert::Error)
    end

    it 'raises an error for empty string' do
      expect { described_class.decode('') }.to raise_error(Philiprehberger::BaseConvert::Error)
    end
  end

  describe 'roundtrip' do
    it 'roundtrips small integers' do
      (0..100).each do |n|
        expect(described_class.decode(described_class.encode(n))).to eq(n)
      end
    end

    it 'roundtrips large integers' do
      large = 999_999_999_999
      expect(described_class.decode(described_class.encode(large))).to eq(large)
    end
  end

  describe 'module-level methods' do
    it 'delegates base62_encode' do
      expect(Philiprehberger::BaseConvert.base62_encode(100)).to eq(described_class.encode(100))
    end

    it 'delegates base62_decode' do
      encoded = described_class.encode(100)
      expect(Philiprehberger::BaseConvert.base62_decode(encoded)).to eq(100)
    end
  end
end
