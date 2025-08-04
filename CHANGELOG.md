# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.1] - 2025-08-03

- Better interface to parsed records (Nacha::AchFile)

- Now Nacha::parse returns an AchFile


## [0.1.19] - 2025-07-27

- Accept stdin for command line parsing.

## [0.1.18] - 2025-07-26

- first build automatically pushed from Github Actions

## [0.1.17] - 2025-07-25

- lots of yard documentation for all the Ach record types.  Generating
  documentation so that the AI coders will have something to go by

## [0.1.16] - 2025-07-22

- `Nacha::Record::BatchHeader` would blissfully attempt to add a
  `child_record_type` that referenced `Nacha::Record::000EntryDetail` even though
  no such record type exists.  Now `standard_entry_class_code` must be valid to
  create a `child_record_type`

## [0.1.15] - 2025-07-21

- Added back `Nacha::Field#to_json_output` that got removed in some of the
  recent AI developemnt

## [0.1.14] - 2025-07-19

- Added markdown and github flavored markdown output

- Better architecture for output formatting

## [0.1.13] - 2025-07-16

- Fixed an issue with IatEntryDetail where there were multiple
  `reserved` fields.  Fixed the associated spec

- Fixed column positions for FirstIatAddenda#reserved

- Added `child_record_types` for DetailRecordType and AddendaRecordType
  so that parsing work right.  Probably need to start using
  `next_record_types` for some of the record types that are in
  `child_record_types` right now

- Sorted the fields by position.first when building the matcher and
  the unpack string.

- Split the `child_record_types` between the class method and the
  instance method.  Concatenated the class method types when the
  instance method is called.

## [0.1.12] - 2025-07-08

- Fixed a bug with parsing files with misshapen lines.  Now it
  _should_ handle lines that are shorter than 94 characters _and_ have
  (CR|CRLF|LF) as the terminating character.



## [0.1.11] - 2025-07-05

### Output formatting options
- use -f [html|json|ach] or --format [html|json|ach] to change

- use -o filename or --output filename to specify a file to output

- Aider and I fixed a bunch of rubocop offenses and refactored some code

## [0.1.10] - 2025-07-01

- Added ability to get a list of possible record types and
  the ability parse just 1 record

- Fixed a bug where AdvFileControl did not have the FileControlRecordType
  included

## [0.1.9] - 2025-06-25

- Fixed AdvFileHeaer definition to include constant `ADV FILE` mentioned in the
  NACHA documentation

- Added automatic debugger gem selection based on ruby version (ruby or jruby)

- Fixed Nacha.ach_record_types to have the correct list of record types by moving
  the Nacha.add_ach_record_type(...) call above a possible return

- Added contentEditable to the generate HTML

- Added AdvFileHeader as one of the first records that should be found

- Removed a bunch of versions from nacha.gemspec

## [0.1.8] - 2025-06-24

- Now parses filler records correctly (fixed definition)

- Add support for `ack_entry_detail` record type

- Tweaked the child record types for file_control and file_header

## [0.1.7] - 2025-06-23

- Better parsing.  Nacha::Record::FileControl had issues parsing if the reserved
  part of the record was stripped off.   Since the reserved part of the record is
  all spaces, it can safely be missing.


## [0.1.6] - 2025-06-20

- Better code coverage

- fixed an issue with jruby running tests

- Bump version to 0.1.6


## [0.1.5] - 2025-06-18

### Fixed
- Actual reporting of field errors now in the output html.
- Change Nacha::Record::BatchControl#reserved to optional
- Change Nacha::Record::BatchHeader#settlement_date_julian to optional
- bump version to 0.1.5

## [0.1.4] - 2025-06-14

### Added
- Store the original input line on parsed records for easier debugging.

### Changed
- Group metadata into a nested `metadata` object in `to_h` output for better organization.

### Fixed
- Resolved a module loading issue.

## [0.1.3] - 2025-06-14

### Added
- Introduced SimpleCov for tracking code coverage.
- Added comprehensive tests for `Nacha::Record::Filler`.

### Changed
- Improved parsing with stricter matching for numeric fields and better handling of records not 94 bytes long.
- Enhanced HTML output with better class handling.
- Refactored `Nacha::Numeric` for better clarity and added more tests.

### Fixed
- Improved error parsing and reporting.
- Corrected memoization for `Nacha::Record.matcher`.

## [0.1.2] - 2025-06-04

### Added
- Introduced a command-line interface (CLI) using Thor.
- The CLI includes a `parse` command to process ACH files and output a summary to the console or generate an HTML representation.

## [0.1.1] - 2025-05-31

### Fixed
- Corrected an issue with `Nacha::AchDate` parsing on JRuby.
- Fixed gem file loading in Rails environments.
- Replaced deprecated `BigDecimal.new` with `BigDecimal()`.

### Removed
- Removed `pry` as a dependency.

## [0.1.0] - 2017-03-06

### Added
- Initial release of the Nacha gem.
- Core functionality to define NACHA record types and their fields.
- Parser for processing NACHA files from strings.
- Ability to generate NACHA-formatted strings from record objects (`to_ach`).
- Ability to convert records to JSON (`to_json`) and Hashes (`to_h`).
- Initial implementation of field and record validations.
- Extensive test suite using RSpec and later FactoryBot.

### Changed
- Major architectural refactoring to define records in pure Ruby classes (`nacha_field`) instead of external YAML files.
