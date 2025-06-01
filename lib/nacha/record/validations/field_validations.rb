# coding: utf-8
# frozen_string_literal: true

module Nacha
  module Record
    module Validations
      module FieldValidations
        def self.included base
          base.extend ClassMethods
        end
        module ClassMethods
          def check_field_error(field, message = nil, condition = nil)
            (block_given? ? yield : condition) || (field.add_error("'#{field.data}' is invalid") && false)
          end

          def valid_service_class_code field
            check_field_error(field) { SERVICE_CLASS_CODES.include? field.to_s }
          end

          def valid_standard_entry_class_code field
            check_field_error(field) { STANDARD_ENTRY_CLASS_CODES.include? field.data }
          end

          def valid_transaction_code field
            check_field_error(field) { TRANSACTION_CODES.include? field.to_s }
          end

          def valid_receiving_dfi_identification field
            check_field_error(field) { field.valid? }
          end
        end
      end
    end
  end
end
