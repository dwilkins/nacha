# coding: utf-8
# frozen_string_literal: true

require 'nacha/record/base'
require 'nacha/record/detail_record_type'

module Nacha
  module Record
    # @!attribute [rw] record_type_code
    #   @return [String] Identifies the record as an ACK Entry Detail record with a constant value of '6'.
    # @!attribute [rw] transaction_code
    #   @return [Nacha::Numeric] Identifies the transaction as an acknowledgment for a received credit entry.
    # @!attribute [rw] receiving_dfi_identification
    #   @return [Nacha::AbaNumber] The routing number of the financial institution that is to receive the acknowledgement.
    # @!attribute [rw] dfi_account_number
    #   @return [String] The DFI account number of the receiver from the original entry detail record.
    # @!attribute [rw] amount
    #   @return [Nacha::Numeric] The amount of the entry being acknowledged, which is always zero for ACK entries.
    # @!attribute [rw] originl_entry_trace_number
    #   @return [Nacha::Numeric] The trace number from the original Entry Detail Record to which this acknowledgment applies.
    # @!attribute [rw] receiving_company_name
    #   @return [String] The name of the receiver from the original entry detail record.
    # @!attribute [rw] discretionary_data
    #   @return [String] Optional data field which can be used by the ODFI or Originator for their own purposes.
    # @!attribute [rw] addenda_record_indicator
    #   @return [Nacha::Numeric] A code indicating whether an addenda record follows, '1' for yes and '0' for no.
    # @!attribute [rw] trace_number
    #   @return [Nacha::Numeric] A unique number assigned by the ODFI to this specific acknowledgement entry.
    class AckEntryDetail < Nacha::Record::Base
      include DetailRecordType

      nacha_field :record_type_code, inclusion: 'M', contents: 'C6', position: 1..1
      nacha_field :transaction_code, inclusion: 'M', contents: 'Numeric', position: 2..3
      nacha_field :receiving_dfi_identification,
        inclusion: 'M', contents: 'TTTTAAAAC', position: 4..12
      nacha_field :dfi_account_number,
        inclusion: 'R', contents: 'Alphameric', position: 13..29
      nacha_field :amount, inclusion: 'M', contents: '$$$$$$$$¢¢', position: 30..39
      nacha_field :originl_entry_trace_number,
        inclusion: 'M', contents: 'Numeric', position: 40..54
      nacha_field :receiving_company_name,
        inclusion: 'R', contents: 'Alphameric', position: 55..76
      nacha_field :discretionary_data,
        inclusion: 'O', contents: 'Alphameric', position: 77..78
      nacha_field :addenda_record_indicator,
        inclusion: 'M', contents: 'Numeric', position: 79..79
      nacha_field :trace_number, inclusion: 'M', contents: 'Numeric', position: 80..94
    end
  end
end
