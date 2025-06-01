# frozen_string_literal: true

require 'date'
# A Date object to handle some of the Ach formatted dates

class Nacha::AchDate < Date
  def self.new(*args)
    year, month, day = nil

    case args[0]
    when String
      date_str = args[0]
      # Use Date.strptime to parse the string into a temporary Date object
      temp_date = Date.strptime(date_str, '%y%m%d')
      year, month, day = temp_date.year, temp_date.month, temp_date.day
    when Date
      original_date = args[0]
      year, month, day = original_date.year, original_date.month, original_date.day
    when Integer # If it's a year integer, assume (year, month, day) or single Julian day
      # If 3 arguments (year, month, day) are provided like Date.new(2023, 10, 26)
      if args.length == 3 && args.all? { |arg| arg.is_a?(Integer) }
        year, month, day = args[0], args[1], args[2]
      else
        # Fallback for other Date.new arguments like (jd) - let super handle directly
        return super(*args) # IMPORTANT: Call super to create the instance
      end
    else
      # If it's none of the above, pass arguments directly to Date.new.
      # This handles cases like Date.new(2459918) (Julian day) or other Date constructors.
      return super(*args)
    end

    # If year, month, day were successfully parsed, create a Nacha::AchDate instance
    # by calling the parent's `new` with the explicit components.
    # `super()` in this context will call `Date.new(year, month, day)` but for *your* class.
    # This works because `Date.new` is designed to be effectively `allocate.initialize`.
    super(year, month, day)

  rescue ArgumentError => e
    # Catch errors that might arise from strptime or invalid date components
    raise ArgumentError, "Invalid date format for Nacha::AchDate: #{args.inspect}. Original error: #{e.message}"
  end

  def to_s
    strftime('%y%m%d')
  end

  def valid?
    !nil?
  end
end
