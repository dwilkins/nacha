require 'spec_helper'

class DummyRecord
  include Nacha::Record::FieldValidations
end


RSpec.describe "Nacha::Record::FieldValidations" do

  let(:subject) { DummyRecord }
  let(:standard_entry_class_code) do
  end

  describe 'standard_entry_class_code' do
    let(:valid_fields) do
      Nacha::STANDARD_ENTRY_CLASS_CODES.map do |sec|
        Nacha::Field.new(inclusion: 'M',
                         contents: 'Alphameric',
                         position: 51..53,
                         data: sec)
      end
    end
    let(:invalid_fields) do
      %w(XXX WWW).map do |sec|
        Nacha::Field.new(inclusion: 'M',
                         contents: 'Alphameric',
                         position: 51..53,
                         data: sec)
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
end
