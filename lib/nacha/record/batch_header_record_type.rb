# frozen_string_literal: true

module Nacha
  module Record
    module BatchHeaderRecordType
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def child_record_types
          [
            'Nacha::Record::BatchControl'
          ]
        end
      end

      def child_record_types
        return self.class.child_record_types unless standard_entry_class_code.valid?

        sec = standard_entry_class_code.to_s.capitalize
        [
          "Nacha::Record::#{sec}EntryDetail"
        ] + self.class.child_record_types
      end
    end
  end
end
