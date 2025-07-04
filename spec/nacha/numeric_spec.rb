# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nacha::Numeric do
  it 'initializes with a value' do
    numeric = described_class.new("12345")
    expect(numeric.to_i).to eq 12345
  end

  it 'initializes with a nil' do
    numeric = described_class.new(nil)
    expect(numeric.to_i).to eq 0
  end

  it 'handles string values' do
    numeric = described_class.new("  67890  ")
    expect(numeric.to_i).to eq 67890
  end

  it 'handles BigDecimal values' do
    numeric = described_class.new(BigDecimal("12345.67"))
    expect(numeric.to_i).to eq 12345
  end

  it 'responds to precision' do
    numeric = described_class.new(BigDecimal('8'))
    expect(numeric.precision).to eq 1
  end

  it 'does not change spaces' do
    numeric = described_class.new("   ")
    expect(numeric.to_i).to eq "   "
  end
end
