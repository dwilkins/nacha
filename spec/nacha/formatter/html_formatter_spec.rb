# frozen_string_literal: true

require 'spec_helper'
require 'nacha/formatter/html_formatter'
require 'nacha/parser'

RSpec.describe Nacha::Formatter::HtmlFormatter do
  let(:records) { Nacha.parse('spec/fixtures/ccd-debit.ach').parse }
  let(:options) { { file_name: 'ccd-debit.ach' } }
  let(:formatter) { described_class.new(records, options) }

  describe '#format' do
    let(:html_output) { formatter.format }

    it 'includes an HTML preamble' do
      expect(html_output).to include('<!DOCTYPE html>')
    end

    it 'includes file statistics' do
      expect(html_output).to include('<h2>File Information</h2>')
      expect(html_output).to include('<strong>File Name:</strong> ccd-debit.ach')
    end

    it 'includes HTML representations of records' do
      expect(html_output).to include('<div class="nacha-record')
    end

    it 'includes an HTML postamble' do
      expect(html_output).to include('</body>')
    end
  end
end
