# Nacha

[![Coverage Status](https://coveralls.io/repos/github/badges/shields/badge.svg?branch=master)](https://coveralls.io/github/badges/shields?branch=master)

Validating Ruby ACH parser and generator

Format documentation here: http://achrulesonline.org/

Record Documentation here: https://nachaoperatingrulesonline.org/assets/attachments/25_basic_appendixes.pdf

The definition of the records in this gem exactly mirrors the NACHA
documentation so that development and business can use the same terminology.

Work in progress - contributors welcome.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nacha'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nacha

## Usage

API may change at any time.   Pull requests welcomed



```ruby
    ach_string = "101 124000054 1240000540907021214A094101ZIONS FIRST NATIONAL BAZIONS FIRST NATIONAL BA       1"
    ach_records = Nacha::Parser.parse_string(ach_string)
    ach_records[0].class  # => Nacha::Record::FileHeaderRecord

    ach_records[0].to_json
```
```json
{
  "record_type_code": "1",
  "priority_code": 1,
  "immediate_destination": "124000054",
  "immediate_origin": "124000054",
  "file_creation_date": "2009-07-02",
  "file_creation_time": "1214",
  "file_id_modifier": "A",
  "record_size": "094",
  "blocking_factor": "10",
  "format_code": "1",
  "immediate_destination_name": "ZIONS FIRST NATIONAL BA",
  "immediate_origin_name": "ZIONS FIRST NATIONAL BA",
  "reference_code": "       1"
}
```

## Parse an ach file into an HTML file

```
nacha parse ach_file.ach > ach_file.html`
```

## Discussion

* Nacha::Record::Base defines a class method `nacha_field`
* Each ACH record class defines its fields using `nacha_field`
* Based on the information provided by `nacha_field` a regex matcher
  for different record types can be built out of the constant parts
  of the ACH record.
* Each ACH record has a "RecordType" mixin that specifies the record
  types that can follow this record.

Parsing starts by looking for a default record type 'Nacha::Record::FileHeader'
When that is found, the valid child record types for 'Nacha::Record::FileHeader'
are gathered and the subsequent lines are parsed using only those types

When a record is created, the fields for the instance are created from
the field definitions.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dwilkins/nacha.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

