class Nacha::Record
  attr_accessor :fields, :children


  def initialize opts = {}
    opts.each do |k,v|
      if(self.respond_to?("#{k}="))
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end



end
