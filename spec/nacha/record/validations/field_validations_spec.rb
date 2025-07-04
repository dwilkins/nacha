require 'spec_helper'

class DummyRecord
  include Nacha::Record::Validations::FieldValidations
end

RSpec.describe Nacha::Record::Validations::FieldValidations do
  subject(:dummy_class) { DummyRecord }

  describe 'valid_standard_entry_class_code' do
    let(:valid_fields) do
      Nacha::STANDARD_ENTRY_CLASS_CODES.map do |sec|
        build(:standard_entry_class_code, data: sec)
      end
    end

    let(:invalid_fields) do
      %w[XXX WWW].map do |sec|
        build(:standard_entry_class_code, data: sec)
      end
    end

    it 'recognizes valid standard_entry_class_codes' do
      valid_fields.each do |valid_field|
        expect(dummy_class.valid_standard_entry_class_code(valid_field)).to be_truthy
        expect(valid_field.errors).to be_empty
      end
    end

    it 'recognizes invalid standard_entry_class_codes' do
      invalid_fields.each do |invalid_field|
        expect(dummy_class.valid_standard_entry_class_code(invalid_field)).to be_falsy
        expect(invalid_field.errors.first).to match(/#{invalid_field}/)
        expect(invalid_field.errors.first).to match(/is invalid/)
      end
    end
  end

  describe 'valid_service_class_code' do
    let(:valid_fields) do
      Nacha::SERVICE_CLASS_CODES.map do |scc|
        build(:service_class_code, data: scc.to_i)
      end
    end

    let(:invalid_fields) do
      %w[999 888].map do |scc|
        build(:service_class_code, data: scc.to_i)
      end
    end

    it 'recognizes valid service_class_codes' do
      valid_fields.each do |valid_field|
        expect(dummy_class.valid_service_class_code(valid_field)).to be_truthy, valid_field.inspect
        expect(valid_field.errors).to be_empty
      end
    end

    it 'recognizes invalid service_class_codes' do
      invalid_fields.each do |invalid_field|
        expect(dummy_class.valid_service_class_code(invalid_field)).to be_falsy, invalid_field.inspect
        expect(invalid_field.errors.first).to match(/#{invalid_field}/)
        expect(invalid_field.errors.first).to match(/is invalid/)
      end
    end
  end

  describe 'valid_transaction_code' do
    let(:valid_fields) do
      Nacha::TRANSACTION_CODES.map do |scc|
        build(:transaction_code, data: scc.to_i)
      end
    end

    let(:invalid_fields) do
      %w[99 89].map do |scc|
        build(:transaction_code, data: scc.to_i)
      end
    end

    it 'recognizes valid transaction_codes' do
      valid_fields.each do |valid_field|
        expect(dummy_class.valid_transaction_code(valid_field)).to be_truthy, valid_field.inspect
        expect(valid_field.errors).to be_empty
      end
    end

    it 'recognizes invalid transaction_codes' do
      invalid_fields.each do |invalid_field|
        expect(dummy_class.valid_transaction_code(invalid_field)).to be_falsy, invalid_field.inspect
        expect(invalid_field.errors.first).to match(/#{invalid_field}/)
        expect(invalid_field.errors.first).to match(/is invalid/)
      end
    end
  end

  describe 'valid_receiving_dfi_identification' do
    let(:dfi_identification_numbers) do
      [
        ['1' * 8, 8].join,
        ['2' * 8, 6].join,
        ['3' * 8, 4].join,
        ['4' * 8, 2].join,
        ['5' * 8, 0].join,
        ['6' * 8, 8].join,
        ['7' * 8, 6].join,
        ['8' * 8, 4].join,
        ['9' * 8, 2].join
      ]
    end

    let(:valid_fields) do
      dfi_identification_numbers.map do |din|
        build(:receiving_dfi_identification, data: din)
      end
    end

    let(:invalid_fields) do
      dfi_identification_numbers.map do |din|
        temp = din.dup
        temp[2] = '0'
        build(:receiving_dfi_identification, data: temp)
      end
    end

    it 'recognizes valid receiving_identification' do
      valid_fields.each do |valid_field|
        expect(dummy_class.valid_receiving_dfi_identification(valid_field)).to be_truthy, valid_field.inspect
      end
    end

    it 'recognizes invalid receiving_identification' do
      invalid_fields.each do |valid_field|
        expect(dummy_class.valid_receiving_dfi_identification(valid_field)).to be_falsey, valid_field.inspect
      end
    end
  end
end
