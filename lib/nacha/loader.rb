require 'singleton'

class Nacha::Loader
  include Singleton

  attr_accessor :record_defs_dir
  attr_accessor :record_defs
  attr_accessor :loaded_classes

  RECORD_TYPE_MIXINS = {
    'C1' => Nacha::Record::FileHeaderRecordType,
    'C5' => Nacha::Record::BatchHeaderRecordType,
    'C6' => Nacha::Record::DetailRecordType,
    'C7' => Nacha::Record::AddendaRecordType,
    'C8' => Nacha::Record::BatchControlRecordType,
    'C9' => Nacha::Record::FileControlRecordType,
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
          new_yaml_data = YAML.load(File.read(f))
          if(new_yaml_data)
            yaml_data.merge!(new_yaml_data)
          end
        end
        yaml_data
      end
  end

  def load
    # get definitions
    @loaded_classes = record_defs.keys.collect do |record_name|
      mixins = []
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
      unless record_class
        record_class = Nacha::Record.const_set(record_class_name, Class.new(Nacha::Record::Base))
        # mixin any specific mixins for this record definition???
        mixins.each do |mixin|
          record_class.instance_eval do
            include mixin
          end
        end
        begin
          mixins << Nacha::Record.constantize("Nacha::Record::#{record_class_name}")
        rescue Exception => e
          # not all record types will have a specialization mixin - that's fine
        end

        # set the RECORD_DEFINITION for the class
        record_class.const_set('RECORD_NAME',record_name.dup)
        if(definition['fields'])
          record_class.const_set('RECORD_DEFINITION',definition["fields"].dup)
        end
        # set the fields for this class, or allow the class to do it
      end
      record_class
    end
  end

end
