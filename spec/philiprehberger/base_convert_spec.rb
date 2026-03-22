# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::BaseConvert do
  it 'has a version number' do
    expect(Philiprehberger::BaseConvert::VERSION).not_to be_nil
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
