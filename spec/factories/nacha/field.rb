FactoryBot.define do
  factory :field, class: 'Nacha::Field' do
    optional
    alphameric
    position { 1..3 }

    trait :mandatory do
      inclusion { 'M' }
    end

    trait :required do
      inclusion { 'R' }
    end

    trait :optional do
      inclusion { 'O' }
    end

    trait :numeric do
      contents { 'Numeric' }
    end

    trait :alphameric do
      contents { 'Alphameric' }
    end

    factory :standard_entry_class_code do
      mandatory
      alphameric
      position { 51..53 }
      data { 'PPD' }
    end

    factory :service_class_code do
      mandatory
      numeric
      position { 2..4 }
      data { 200 }
    end

    factory :company_name do
      mandatory
      alphameric
      position { 5..20 }
      data { 'mega corp' }
    end

    factory :company_discretionary_data do
      mandatory
      alphameric
      position { 21..40 }
      data { 'discretionary data' }
    end

    factory :company_identification do
      mandatory
      alphameric
      position { 41..50 }
      data { 'compid' }
    end

    factory :company_entry_description do
      mandatory
      alphameric
      position { 54..63 }
      data { 'comp entd' }
    end

    factory :company_descriptive_date do
      optional
      alphameric
      position { 64..69 }
      data { 'Jan 11' }
    end

    factory :effective_entry_date do
      required
      contents { 'YYMMDD' }
      position { 70..75 }
      data { '190101' }
    end

    factory :settlement_date_julian do
      mandatory
      numeric
      position { 76..78 }
      data { '11' }
    end

    factory :originator_status_code do
      mandatory
      alphameric
      position { 79..79 }
      data { '0' }
    end

    factory :originating_dfi_identification do
      mandatory
      contents { 'TTTTAAAA' }
      position { 80..87 }
      data { '12345678' }
    end

    factory :batch_number do
      mandatory
      numeric
      position { 88..94 }
      data { '0' }
    end
  end
end
