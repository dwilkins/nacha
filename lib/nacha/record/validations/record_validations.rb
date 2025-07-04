# coding: utf-8
# frozen_string_literal: true

module Nacha
  module Record
    module Validations
      module RecordValidations
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
        end
      end
    end
  end
end
