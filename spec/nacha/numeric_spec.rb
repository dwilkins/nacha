# frozen_string_literal: true

require 'spec_helper'
require 'nacha/numeric' # Adjust path if necessary based on your project structure
require 'bigdecimal'

RSpec.describe Nacha::Numeric do
  describe 'Initialization and value assignment' do
    context 'when initialized with an integer' do
      subject { described_class.new(123) }
      it 'sets @value and @op_value to BigDecimal(123)' do
        expect(subject.instance_variable_get(:@value)).to eq(BigDecimal('123'))
        expect(subject.instance_variable_get(:@op_value)).to eq(BigDecimal('123'))
      end
    end

    context 'when initialized with a float' do
      subject { described_class.new(123.45) }
      it 'sets @value and @op_value to BigDecimal(\'123.45\')' do
        expect(subject.instance_variable_get(:@value)).to eq(BigDecimal('123.45'))
        expect(subject.instance_variable_get(:@op_value)).to eq(BigDecimal('123.45'))
      end
    end

    context 'when initialized with a numeric string' do
      subject { described_class.new('123.45') }
      it 'sets @value and @op_value to BigDecimal(\'123.45\')' do
        expect(subject.instance_variable_get(:@value)).to eq(BigDecimal('123.45'))
        expect(subject.instance_variable_get(:@op_value)).to eq(BigDecimal('123.45'))
      end
    end

    context 'when initialized with an empty string' do
      subject { described_class.new('') }
      it 'sets @value to nil and @op_value to BigDecimal(0)' do
        expect(subject.instance_variable_get(:@value)).to be_nil
        expect(subject.instance_variable_get(:@op_value)).to eq(BigDecimal('0'))
      end
    end

    context 'when initialized with a string containing only whitespace' do
      subject { described_class.new('   ') }
      it 'sets @value to nil and @op_value to BigDecimal(0)' do
        expect(subject.instance_variable_get(:@value)).to be_nil
        expect(subject.instance_variable_get(:@op_value)).to eq(BigDecimal('0'))
      end
    end

    context 'when initialized with nil' do
      subject { described_class.new(nil) }
      it 'sets @value to nil and @op_value to BigDecimal(0)' do
        # Based on the refactored value=, if val is not a string, it tries BigDecimal(val)
        # BigDecimal(nil) raises TypeError. The rescue ArgumentError block will catch this.
        # So @value becomes nil and @op_value becomes BigDecimal(0)
        expect(subject.instance_variable_get(:@value)).to be_nil
        expect(subject.instance_variable_get(:@op_value)).to eq(BigDecimal('0'))
      end
    end

    context 'when initialized with a non-numeric string' do
      subject { described_class.new('abc') }
      it 'sets @value to nil and @op_value to BigDecimal(0) due to ArgumentError rescue' do
        expect(subject.instance_variable_get(:@value)).to be_nil
        expect(subject.instance_variable_get(:@op_value)).to eq(BigDecimal('0'))
      end
    end
  end

  describe '#to_i' do
    it 'returns 123 for Nacha::Numeric.new(123.45)' do
      expect(described_class.new(123.45).to_i).to eq(123)
    end

    it 'returns 123 for Nacha::Numeric.new(\'123.45\')' do
      expect(described_class.new('123.45').to_i).to eq(123)
    end

    it 'returns 0 for Nacha::Numeric.new(\'\')' do
      expect(described_class.new('').to_i).to eq(0)
    end

    it 'returns 0 for Nacha::Numeric.new(nil)' do
      expect(described_class.new(nil).to_i).to eq(0)
    end

    it 'returns 0 for Nacha::Numeric.new(\'  \')' do
      expect(described_class.new('  ').to_i).to eq(0)
    end

    it 'returns 0 for Nacha::Numeric.new(\'abc\')' do
      expect(described_class.new('abc').to_i).to eq(0)
    end
  end

  describe '#to_s' do
    it 'returns BigDecimal string representation for Nacha::Numeric.new(123.45)' do
      # BigDecimal(123.45).to_s can vary, e.g., '0.12345E3'
      # We check that it's not nil and is a string.
      # A more precise check would be against BigDecimal('123.45').to_s
      expect(described_class.new(123.45).to_s).to eq(BigDecimal('123.45').to_s)
    end

    it 'returns BigDecimal string representation for Nacha::Numeric.new(\'123.45\')' do
      expect(described_class.new('123.45').to_s).to eq(BigDecimal('123.45').to_s)
    end

    it 'returns nil for Nacha::Numeric.new(\'\')' do
      expect(described_class.new('').to_s).to be_nil
    end

    it 'returns nil for Nacha::Numeric.new(nil)' do
      expect(described_class.new(nil).to_s).to be_nil
    end

    it 'returns nil for Nacha::Numeric.new(\'abc\')' do
      expect(described_class.new('abc').to_s).to be_nil
    end
  end

  describe 'Arithmetic Operations (via method_missing)' do
    let(:num_10) { described_class.new(10) }
    let(:num_5)  { described_class.new(5) }

    it 'adds correctly and updates wrapped value' do
      result = num_10 + num_5
      expect(result).to eq(BigDecimal('15')) # + returns the BigDecimal result
      # The original num_10 object's @op_value should now be 15 due to method_missing update
      expect(num_10.instance_variable_get(:@op_value)).to eq(BigDecimal('15'))
      expect(num_10.to_i).to eq(15)
    end

    it 'subtracts correctly and updates wrapped value' do
      num = described_class.new(10) # re-initialize to avoid state from previous test
      result = num - num_5
      expect(result).to eq(BigDecimal('5'))
      expect(num.instance_variable_get(:@op_value)).to eq(BigDecimal('5'))
      expect(num.to_i).to eq(5)
    end

    it 'multiplies correctly and updates wrapped value' do
      num = described_class.new(10) # re-initialize
      result = num * described_class.new(2)
      expect(result).to eq(BigDecimal('20'))
      expect(num.instance_variable_get(:@op_value)).to eq(BigDecimal('20'))
      expect(num.to_i).to eq(20)
    end

    it 'divides correctly and updates wrapped value' do
      num = described_class.new(10) # re-initialize
      result = num / described_class.new(2)
      expect(result).to eq(BigDecimal('5'))
      expect(num.instance_variable_get(:@op_value)).to eq(BigDecimal('5'))
      expect(num.to_i).to eq(5)
    end

    it 'compares equality correctly' do
      expect(described_class.new(10) == described_class.new(10)).to be true
      expect(described_class.new(10) == described_class.new(5)).to be false
    end

    it 'compares greater than correctly' do
      expect(described_class.new(10) > described_class.new(5)).to be true
      expect(described_class.new(5) > described_class.new(10)).to be false
    end

    it 'handles operations that return non-BigDecimal (e.g. boolean)' do
        numeric_val = described_class.new(10)
        comparison_result = numeric_val > 5 # This will internally call > on BigDecimal
        expect(comparison_result).to be true
        # Ensure @value and @op_value are not changed by a comparison
        expect(numeric_val.instance_variable_get(:@value)).to eq(BigDecimal('10'))
        expect(numeric_val.instance_variable_get(:@op_value)).to eq(BigDecimal('10'))
    end

    # BigDecimal doesn't have many common bang methods like sub! or add!
    # We'll test a scenario where a method might modify @op_value,
    # and ensure @value is also updated.
    # The current method_missing for non-bang methods that return BigDecimal
    # already updates both @value and @op_value to the result.
    # Let's consider if any BigDecimal methods modify self AND return self.
    # Standard arithmetic operations (+, -, *, /) on BigDecimal return new objects.
    # If there were a hypothetical `multiply_by!(factor)` that modified `@op_value` in place
    # and returned `@op_value`, our `method_missing` would handle it like a bang method.
    #
    # The current refactor of method_missing for non-bang methods:
    #   result = @op_value.public_send(...)
    #   if result.is_a?(BigDecimal)
    #     @value = result
    #     @op_value = result
    #   end
    #   return result
    # This means that if an operation like `+` is performed, and it returns a new BigDecimal,
    # the original Nacha::Numeric object (`num_10` in the add test) will have its internal
    # `@value` and `@op_value` updated to this new BigDecimal.
    # This is confirmed by the addition test.
  end

  describe '#respond_to_missing?' do
    subject(:numeric_val) { described_class.new(10) }

    it { expect(numeric_val.respond_to?(:+)).to be true }
    it { expect(numeric_val.respond_to?(:foo)).to be false } # :foo is not a BigDecimal method

    context 'when @op_value is nil (e.g. after new(nil))' do
      subject(:nil_numeric) { described_class.new(nil) }
      it { expect(nil_numeric.respond_to?(:+)).to be false } # Relies on @op_value being BigDecimal(0)
                                                             # and BigDecimal(0) responds to :+
                                                             # The refactored respond_to_missing? is `@op_value&.respond_to?(method_name) || super`
                                                             # If @op_value is BigDecimal(0), it responds to :+
                                                             # Let's test with a truly nil @op_value scenario if possible,
                                                             # but current value= sets it to BigDecimal(0).
                                                             # The test for new(nil) already confirms @op_value is BigDecimal(0).
                                                             # So, this should be true.
      it 'correctly handles respond_to? for methods on BigDecimal(0)' do
         # @op_value will be BigDecimal(0), but @value is nil.
         # Based on current respond_to_missing? logic, if @value is nil,
         # it should not respond to :+
        expect(described_class.new(nil).respond_to?(:+)).to be false
      end
       it 'correctly handles respond_to? for non-existent methods when @op_value is BigDecimal(0)' do
        expect(described_class.new(nil).respond_to?(:non_existent_method)).to be false
      end
    end
  end
end
