# frozen_string_literal: true

require 'spec_helper'
require 'nacha/formatter/json_formatter'
require 'nacha/parser'

RSpec.describe Nacha::Formatter::JsonFormatter do
  let(:records) { Nacha.parse('spec/fixtures/ccd-debit.ach').parse }
  let(:options) { { file_name: 'ccd-debit.ach' } }
  let(:formatter) { described_class.new(records, options) }

  describe '#format' do
    let(:json_output) { JSON.parse(formatter.format) }

    it 'includes file statistics' do
      expect(json_output['file']['file_name']).to eq('ccd-debit.ach')
    end

    it 'includes an array of records' do
      expect(json_output['records']).to be_an(Array)
      expect(json_output['records'].size).to eq(records.records.size)
    end

    it 'includes metadata for each record' do
      expect(json_output['records'].first['metadata']['klass']).to eq('Nacha::Record::FileHeader')
    end
  end
end
