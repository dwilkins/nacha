require 'date'
# A Date object to handle some of the Ach formatted dates

class Nacha::AchDate < Date

  def self.new date_str
    if(date_str.is_a? String)
      strptime(date_str,'%y%m%d')
    elsif (date_str.is_a? Date)
      date_str.dup
    else
      super(date_str)
    end
  end

  def to_s
    strftime('%y%m%d')
  end

  def valid?
    !nil?
  end

end
