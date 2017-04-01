class Nacha::Loader

  attr_accessor :record_defs_dir
  attr_accessor :record_defs

  RECORD_TYPE_MIXINS = {
    'C1' => Nacha::Record::HeaderRecordType,
    'C5' => Nacha::Record::HeaderRecordType,
    'C6' => Nacha::Record::DetailRecordType,
    'C7' => Nacha::Record::AddendaRecordType,
    'C8' => Nacha::Record::ControlRecordType,
    'C9' => Nacha::Record::ControlRecordType,
    'C' + '9' * 94 => Nacha::Record::FillerRecordType
  }

  def initialize opts = {}
    @record_defs = nil
    @record_defs_dir = File.expand_path("lib/config/definitions")
    opts.each do |k,v|
      setter = "#{k}="
      if(respond_to?(setter))
        send(setter, v) unless v.nil?
      end
    end
    load
  end


  def record_defs_dir= val
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
      record_class_name = record_name.split('_').collect(&:capitalize).join('')
      record_class = "Nacha::Record::#{record_class_name}".to_sym
      mixins << RECORD_TYPE_MIXINS[definition['fields']['record_type_code']['contents']]
      # add mixins depending on type
      # create the class
      record_class = nil
      begin
        record_class = Nacha::Record.const_get(record_class_name)
      rescue NameError => e
        record_class = nil
      end
      next if record_class
      record_class = Nacha::Record.const_set(record_class_name, Class.new(Nacha::Record::Base))
      # mixin any specific mixins for this record definition???
      mixins.each do |mixin|
        record_class.instance_eval do
          include mixin
        end
      end
      # set the RECORD_DEFINITION for the class
      if(definition['fields'])
        record_class.const_set('RECORD_DEFINITION',definition["fields"].dup)
      end
      # set the fields for this class, or allow the class to do it
    end
  end


end
