# frozen_string_literal: true

module Nacha
  module Record
    module FileHeaderRecordType
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def child_record_types
          [
            'Nacha::Record::BatchHeader',
            'Nacha::Record::FileControl',
          ]
        end
      end

      def child_record_types
        ## returns the class method
        self.class.child_record_types
      end

      def next_record_types
        ## returns the class method
        self.class.next_record_types
      end
    end
  end
end
