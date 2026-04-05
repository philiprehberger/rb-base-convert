# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::BaseConvert::Base85 do
  describe '.encode' do
    it 'encodes a known string' do
      result = described_class.encode('Hello')
      expect(result).to be_a(String)
      expect(result).not_to be_empty
    end

    it 'encodes empty string' do
      expect(described_class.encode('')).to eq('')
    end

    it 'uses z compression for zero groups' do
      zeros = "\x00\x00\x00\x00"
      result = described_class.encode(zeros)
      expect(result).to include('z')
    end

    it 'produces only ASCII characters' do
      result = described_class.encode('test data for encoding')
      result.each_char do |c|
        next if c == 'z'

        expect(c.ord).to be_between(33, 117)
      end
    end
  end

  describe '.decode' do
    it 'decodes a roundtripped value' do
      encoded = described_class.encode('Hello')
      expect(described_class.decode(encoded)).to eq('Hello')
    end

    it 'decodes empty string' do
      expect(described_class.decode('')).to eq('')
    end

    it 'expands z to zero group' do
      encoded = described_class.encode("\x00\x00\x00\x00")
      decoded = described_class.decode(encoded)
      expect(decoded).to eq("\x00\x00\x00\x00")
    end

    it 'raises for invalid characters' do
      expect { described_class.decode("\x01") }.to raise_error(Philiprehberger::BaseConvert::Error)
    end
  end

  describe 'roundtrip' do
    it 'roundtrips simple strings' do
      %w[hello world test data].each do |str|
        expect(described_class.decode(described_class.encode(str))).to eq(str)
      end
    end

    it 'roundtrips strings of various lengths' do
      (1..8).each do |len|
        str = 'x' * len
        expect(described_class.decode(described_class.encode(str))).to eq(str)
      end
    end

    it 'roundtrips binary data' do
      data = (0..255).map(&:chr).join
      expect(described_class.decode(described_class.encode(data))).to eq(data)
    end
  end

  describe 'module delegation' do
    it 'delegates base85_encode' do
      result = Philiprehberger::BaseConvert.base85_encode('Hello')
      expect(result).to eq(described_class.encode('Hello'))
    end

    it 'delegates base85_decode' do
      encoded = described_class.encode('Hello')
      expect(Philiprehberger::BaseConvert.base85_decode(encoded)).to eq('Hello')
    end
  end
end
