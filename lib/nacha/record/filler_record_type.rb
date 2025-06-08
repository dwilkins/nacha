# frozen_string_literal: true

module Nacha
  module Record
    module FillerRecordType
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def child_record_types
          []
        end
      end

      def child_record_types
        self.class.child_record_types
      end
    end
  end
end
