FactoryBot.define do
  factory :ppd_entry_detail, class: 'Nacha::Record::PpdEntryDetail' do
      credit_transaction_code
      receiving_dfi_identification { '124301025' }
      dfi_account_number { '012345678' }
      amount { '0000000100' }
      individual_name { 'MARY V HOPEFUL' }
      addenda_record_indicator { '0' }
      trace_number { '12345' }

      trait :credit_transaction_code do
        transaction_code { 22 }
      end

      trait :debit_transaction_code do
        transaction_code { 27 }
      end

      factory :credit_ppd_entry_detail do
        credit_transaction_code
      end

      factory :debit_ppd_entry_detail do
        debit_transaction_code
      end
  end
end
