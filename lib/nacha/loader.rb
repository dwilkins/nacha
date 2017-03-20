class Nacha::Loader

  attr_accessor :record_defs_dir
  attr_accessor :record_defs

  def initialize opts = {}
    @record_defs = nil
    @record_defs_dir = File.expand_path("lib/config/definitions")
    opts.each do |k,v|
      setter = "#{k}="
      if(respond_to?(setter))
        send(setter, v) unless v.nil?
      end
    end
  end


  def record_defs_dir= val
    binding.pry
    dir = Dir.open(val)  # check for existance, access, etc

    if(dir)
      dir.close
      @record_defs_dir = val
    end
  end


  def record_defs
    @record_defs ||=
      begin
        yaml_data = {}
        Dir.glob(File.join(@record_defs_dir,'*.yml')) do |f|
          yaml_data.merge!(YAML.load(File.read(f)))
        end
        yaml_data
      end
  end


  def load

    # get definitions
    mixins = []
    classes = record_defs.keys.collect do |record_name|
      # determine type (header, detail, control, addenda, filler)
      definition = record_defs[record_name]
      record_class_name = record_name.split('_').capitalize.join('')
      record_class = Nacha::RecordFactory.constantize("Nacha::Record::#{record_class_name}")
      case definition['fields']['record_type_code']['contents']
      when 'C6'
        mixins << Nacha::Record::DetailRecordType
      when 'C7'
        mixins << Nacha::Record::AddendaRecordType
      when 'C8'
        mixins << Nacha::Record::ControlRecordType
      when 'C9'
        mixins << Nacha::Record::ControlRecordType
      when 'C1'
        mixins << Nacha::Record::HeaderRecordType
      when 'C5'
        mixins << Nacha::Record::HeaderRecordType
      when ('C' + '9' * 94)
        mixins << Nacha::Record::FillerRecordType
      end
      # add mixins depending on type
      # create the class
      record_class = Nacha::Record.const_set(record_class_name, Class.new(Nacha::Record::BaseRecord))
      # mixin any specific mixins for this record definition???
      mixins.each do |mixin|
        record_class.instance_eval do
          include mixin
        end
      end
      # set the RECORD_DEFINITION for the class
      record_class.const_set('RECORD_DEFINITION',definition.dup)
      # set the fields for this class, or allow the class to do it
    end
  end


end
