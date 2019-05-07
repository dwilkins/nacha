# coding: utf-8
module Nacha
  module Record
    module FieldValidations
      def self.included base
        base.extend ClassMethods
      end
      module ClassMethods
        def check_field_error field, message = nil, condition = nil
          (block_given? ? yield : condition) || field.add_error("#{field.data_element_name} = '#{field.data}' is invalid")
        end

        def valid_standard_entry_class_code field
          check_field_error(field) { STANDARD_ENTRY_CLASS_CODES.include? field.data }
        end
      end
    end
  end
end
