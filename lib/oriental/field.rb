require_relative 'fields/base'
require_relative 'fields/timestamp'
require_relative 'fields/versioning'

module Oriental
  module Fields
    extend ActiveSupport::Concern

    included do
      class_attribute :fields

      self.fields = {}
      include Base
    end

    module ClassMethods
      def field(name, *args)
        self.fields[name] = args.first
        define_field(name)
      end
    end

    def coerce(value, attrs)
      if attrs[:type] == Oriental::RecordId
        return Oriental::RecordId.new(value)
      else
        value
      end
    end

    def dynamic_field(name, value=nil)
      add_to_dynamic_fields(name, value)
      self.class.send(:define_field, name, true)
    end

    private

    def declare_field(field)
      name = field.shift
      attrs = field.first

      attrs[:type] ||= String

      object = attrs[:type].new
      object = attrs[:default]

      initialize_field(name, object)
    end

    def initialize_field(key, val)
      unless self.class.fields[key]
        dynamic_field(key, val)
      end
      self.send "#{key}=", val
    end

    def initialize_fields(record)
      self.class.fields.each { |field| declare_field field }
      record.each { |key, val| initialize_field(key, val) }
    end

    def add_to_dynamic_fields(name, value)
      _dynamic_fields[name] = {type: value ? value.class : String}
    end

    def _dynamic_fields
      @_dynamic_fields ||= {}
    end

  end
end
