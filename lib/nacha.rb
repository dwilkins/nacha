require 'nacha/version'
require 'yaml'
require 'nacha/aba_number'
require 'nacha/ach_date'
require 'nacha/field'
require 'nacha/numeric'
require 'nacha/record/batch/batch_header.rb'


Dir["lib/nacha/record/*.rb"].each do |file|
  require File.expand_path(file)
end
require 'nacha/parser'
require 'nacha/loader'

module Nacha
  Nacha::Loader.instance
  # Your code goes here...
end
