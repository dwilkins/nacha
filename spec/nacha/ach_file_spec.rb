# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'
require 'nacha/ach_file'

RSpec.describe Nacha::AchFile do
  let(:ach_file) { Nacha.parse('spec/fixtures/ccd-debit.ach').parse }

  describe '#initialize' do
    it 'assigns records' do
      expect(ach_file.records.count).to be 2
    end
  end

  describe 'urls' do
    let(:file_url) { 'http://example.com/ccd-debit.ach' }
    let(:ach_file) { Nacha::AchFile.new(file_url) }

    before do
      raw_records = File.read('spec/fixtures/ccd-debit.ach')
      stub_request(:get, file_url).
        with(
          headers: {
       	    'Accept'=>'*/*',
       	    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	    'User-Agent'=>'Ruby'
          }).to_return(status: 200, body: raw_records, headers: {})
    end

    it 'can be parsed' do
      expect(ach_file.parse).to be_a Nacha::AchFile
      expect(ach_file.records.count).to be 2
    end
  end

  describe 'stdin' do
    let(:ach_file) { Nacha::AchFile.new($stdin) }

    before do
      raw_records = File.read('spec/fixtures/ccd-debit.ach')
      allow($stdin).to receive(:read).and_return(raw_records)
    end

    it 'can be parsed' do
      expect(ach_file.parse).to be_a Nacha::AchFile
      expect(ach_file.records.count).to eq 2
    end
  end

  describe '#to_json' do
    it 'gets a json formatter and calls format' do
      formatter = double('json_formatter')
      expect(Nacha::Formatter::FormatterFactory).to receive(:get).with(:json, ach_file, anything).and_return(formatter)
      expect(formatter).to receive(:format)
      ach_file.to_json
    end
  end

  describe '#to_html' do
    it 'gets a html formatter and calls format' do
      formatter = double('html_formatter')
      expect(Nacha::Formatter::FormatterFactory).to receive(:get).with(:html, ach_file, anything).and_return(formatter)
      expect(formatter).to receive(:format)
      ach_file.to_html
    end
  end

  describe '#to_markdown' do
    it 'gets a markdown formatter and calls format' do
      formatter = double('markdown_formatter')
      expect(Nacha::Formatter::FormatterFactory).to receive(:get).with(:markdown, ach_file, anything).and_return(formatter)
      expect(formatter).to receive(:format)
      ach_file.to_markdown
    end
  end
end
