FactoryBot.define do
  factory :batch_header, class: 'Nacha::Record::BatchHeader' do
    service_class_code { '200' }
    company_name { 'mega corp' }
    company_discretionary_data { '' }
    company_identification { 'BR549' }
    standard_entry_class_code { 'PPD' }
    company_entry_description { 'payment' }
    company_descriptive_date { 'Jan 11' }
    effective_entry_date { '190111' }
    settlement_date_julian { '11' }
    originator_status_code { '0' }
    originating_dfi_identification { '12345678' }
    batch_number { 1 }

    # Generate factories for stuff like:
    #   ppd_batch_header
    #   ctx_batch_header
    #   ...
    Nacha::STANDARD_ENTRY_CLASS_CODES.each do |sec|
      trait sec.downcase.to_sym do
        standard_entry_class_code { sec }
      end
      factory ("#{sec}_batch_header").downcase.to_sym, traits: [sec.downcase.to_sym]
    end
  end
end
