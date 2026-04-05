# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::BaseConvert::Base32 do
  describe '.encode' do
    it 'encodes a known string' do
      expect(described_class.encode('Hello')).to eq('91JPRV3F')
    end

    it 'encodes an empty string' do
      expect(described_class.encode('')).to eq('')
    end

    it 'handles binary data' do
      data = [0xFF, 0x00, 0xAB].pack('C*')
      result = described_class.encode(data)
      expect(described_class.decode(result)).to eq(data)
    end

    it 'produces only valid Crockford characters' do
      result = described_class.encode('test data 123')
      expect(result).to match(/\A[0-9A-HJKMNP-TV-Z]*\z/)
    end
  end

  describe '.decode' do
    it 'decodes a known value' do
      expect(described_class.decode('91JPRV3F')).to eq('Hello')
    end

    it 'decodes case-insensitively' do
      expect(described_class.decode('91jprv3f')).to eq('Hello')
    end

    it 'maps I to 1' do
      described_class.decode('91JPRV3F')
      mapped = described_class.decode('9IJPRV3F')
      expect(mapped).to be_a(String)
    end

    it 'maps O to 0' do
      result = described_class.decode('O')
      expect(result).to be_a(String)
    end

    it 'strips dashes' do
      expect(described_class.decode('91JP-RV3F')).to eq('Hello')
    end

    it 'decodes empty string' do
      expect(described_class.decode('')).to eq('')
    end
  end

  describe 'roundtrip' do
    it 'roundtrips simple strings' do
      %w[hello world foo bar].each do |str|
        expect(described_class.decode(described_class.encode(str))).to eq(str)
      end
    end

    it 'roundtrips binary data' do
      data = (0..255).map(&:chr).join
      expect(described_class.decode(described_class.encode(data))).to eq(data)
    end
  end

  describe 'module delegation' do
    it 'delegates base32_encode' do
      expect(Philiprehberger::BaseConvert.base32_encode('Hello')).to eq('91JPRV3F')
    end

    it 'delegates base32_decode' do
      expect(Philiprehberger::BaseConvert.base32_decode('91JPRV3F')).to eq('Hello')
    end
  end
end
