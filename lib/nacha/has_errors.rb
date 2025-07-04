# frozen_string_literal: true

module Nacha
  module HasErrors
    attr_reader :errors

    def add_error(message)
      @errors ||= []
      @errors << message
    end

    def has_errors?
      !@errors.nil? && !@errors.empty?
    end
  end
end
