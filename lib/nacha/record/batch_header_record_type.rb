# frozen_string_literal: true

module Nacha
  module Record
    module BatchHeaderRecordType
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def child_record_types
          []
        end
      end

      def child_record_types
        sec = standard_entry_class_code.to_s.capitalize
        [
          "Nacha::Record::#{sec}EntryDetail",
          'Nacha::Record::BatchControl'
        ]
      end
    end
  end
end
