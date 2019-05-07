module Nacha
  module Record
    module BatchControlRecordType
      def self.included base
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
