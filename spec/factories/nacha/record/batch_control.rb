FactoryBot.define do
  factory :batch_control, class: 'Nacha::Record::BatchControl' do
    service_class_code { '200' }
    company_identifiction { 'BR549' }
    originating_dfi_identification { '12345678' }
  end
end
