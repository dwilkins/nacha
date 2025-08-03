# frozen_string_literal: true

require 'spec_helper'
require 'nacha/formatter/markdown_formatter'
require 'nacha/parser'

RSpec.describe Nacha::Formatter::MarkdownFormatter do
  let(:records) { Nacha.parse('spec/fixtures/ccd-debit.ach') }
  let(:options) { { file_name: 'ccd-debit.ach' } }

  describe '#format' do
    context 'with CommonMark flavor' do
      let(:formatter) { described_class.new(records, options.merge(flavor: :common_mark)) }
      let(:markdown_output) { formatter.format }

      it 'includes file statistics' do
        expect(markdown_output).to include('# File Information')
        expect(markdown_output).to include('- **File Name:** ccd-debit.ach')
      end

      it 'includes records in CommonMark format' do
        expect(markdown_output).to include('## File Header')
        expect(markdown_output).to include('* **record_type_code:** 1')
      end
    end

    context 'with GitHub Flavored Markdown flavor' do
      let(:formatter) { described_class.new(records, options.merge(flavor: :github)) }
      let(:markdown_output) { formatter.format }

      it 'includes file statistics' do
        expect(markdown_output).to include('# File Information')
      end

      it 'includes records in GitHub Flavored Markdown format' do
        expect(markdown_output).to include('### File Header')
        expect(markdown_output).to include('| Field | Value |')
        expect(markdown_output).to include('| record_type_code | 1 |')
      end
    end
  end
end
