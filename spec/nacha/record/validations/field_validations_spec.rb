require 'spec_helper'

class DummyRecord
  include Nacha::Record::FieldValidations
end


RSpec.describe "Nacha::Record::FieldValidations" do
  let(:subject) { DummyRecord }

  describe 'standard_entry_class_code' do
    let(:valid_fields) do
      Nacha::STANDARD_ENTRY_CLASS_CODES.map do |sec|
        build(:standard_entry_class_code, data: sec)
      end
    end
    let(:invalid_fields) do
      %w(XXX WWW).map do |sec|
        build(:standard_entry_class_code, data: sec)
      end
    end

    it 'recognizes valid standard_entry_class_codes' do
      valid_fields.each do |valid_field|
        expect(subject.valid_standard_entry_class_code valid_field).to be_truthy
        expect(valid_field.errors).to be_empty
      end
    end
    it 'recognizes invalid standard_entry_class_codes' do
      invalid_fields.each do |invalid_field|
        expect(subject.valid_standard_entry_class_code invalid_field).to be_falsy
        expect(invalid_field.errors.first).to match(/#{invalid_field}/)
        expect(invalid_field.errors.first).to match(/is invalid/)
      end
    end
  end

  describe 'service_class_code' do
    let(:valid_fields) do
      Nacha::SERVICE_CLASS_CODES.map do |scc|
        build(:service_class_code, data: scc.to_i)
      end
    end

    let(:invalid_fields) do
      %w(999 888 ).map do |scc|
        build(:service_class_code, data: scc.to_i)
      end
    end

    it 'recognizes valid service_class_codes' do
      valid_fields.each do |valid_field|
        expect(subject.valid_service_class_code valid_field).to be_truthy, valid_field.inspect
        expect(valid_field.errors).to be_empty
      end
    end

    it 'recognizes invalid service_class_codes' do
      invalid_fields.each do |invalid_field|
        expect(subject.valid_service_class_code invalid_field).to be_falsy, invalid_field.inspect
        expect(invalid_field.errors.first).to match(/#{invalid_field}/)
        expect(invalid_field.errors.first).to match(/is invalid/)
      end
    end
  end

  describe 'transaction_code' do
    let(:valid_fields) do
      Nacha::TRANSACTION_CODES.map do |scc|
        build(:transaction_code, data: scc.to_i)
      end
    end

    let(:invalid_fields) do
      %w(99 89 ).map do |scc|
        build(:transaction_code, data: scc.to_i)
      end
    end

    it 'recognizes valid transaction_codes' do
      valid_fields.each do |valid_field|
        expect(subject.valid_transaction_code valid_field).to be_truthy, valid_field.inspect
        expect(valid_field.errors).to be_empty
      end
    end

    it 'recognizes invalid transaction_codes' do
      invalid_fields.each do |invalid_field|
        expect(subject.valid_transaction_code invalid_field).to be_falsy, invalid_field.inspect
        expect(invalid_field.errors.first).to match(/#{invalid_field}/)
        expect(invalid_field.errors.first).to match(/is invalid/)
      end
    end
  end
end
