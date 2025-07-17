# frozen_string_literal: true

module Nacha
  module Record
    module AddendaRecordType
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def child_record_types
          [
            "Nacha::Record::SecondIatAddenda",
            "Nacha::Record::ThirdIatAddenda",
            "Nacha::Record::FourthIatAddenda",
            "Nacha::Record::FifthIatAddenda",
            "Nacha::Record::SixthIatAddenda",
            "Nacha::Record::SeventhIatAddenda",
          ]
        end

        def self.next_record_types
          []
        end
      end

      def child_record_types
        self.class.child_record_types
      end

      def next_record_types
        self.class.next_record_types
      end
    end
  end
end
