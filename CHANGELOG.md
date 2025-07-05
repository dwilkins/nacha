# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
