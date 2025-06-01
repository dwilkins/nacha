# Nacha

Validating Ruby ACH parser and generator

Format documentation here: http://achrulesonline.org/

The definition of the records exactly mirrors the NACHA documentation so that
development and business can use the same terminology.

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

## Command Line Interface (CLI)

This gem now includes a command-line interface for convenient parsing of NACHA files.

### Usage

```bash
nacha --help
```

### Parsing a NACHA file

To parse an existing NACHA file and view json output:

```bash
nacha parse your_nacha_file.ach
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dwilkins/nacha.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

