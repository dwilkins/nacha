module Nacha
  module Record
    module DetailRecordType
      def self.included base
        base.extend ClassMethods
      end

      module ClassMethods
        def self.child_record_types
          []
        end
      end

      def child_record_types
        self.class.child_record_types
      end
    end
  end
end

