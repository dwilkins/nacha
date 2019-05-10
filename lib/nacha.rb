require 'nacha/version'
require 'yaml'
require 'nacha/aba_number'
require 'nacha/ach_date'
require 'nacha/field'
require 'nacha/numeric'

Dir["lib/nacha/record/*.rb"].each do |file|
  require File.expand_path(file)
end

Dir["lib/nacha/record/**/*.rb"].each do |file|
  require File.expand_path(file)
end

require 'nacha/parser'

module Nacha
  STANDARD_ENTRY_CLASS_CODES = %w( ACK ADV ARC ATX BOC CCD PPD CIE
                                   COR CTX DNE ENR IAT POP POS SHR
                                   MTE RCK TEL TRC TRX WEB XCK )

  SERVICE_CLASS_CODES = %w( 200 220 225 280 )
end
