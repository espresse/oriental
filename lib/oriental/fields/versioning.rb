module Oriental
  module Fields
    extend ActiveSupport::Concern

    module ClassMethods

      private

      def define_field_changed(field)
        define_method "#{field}_changed?" do
          (_field_history && _field_history[field] && _field_history[field].length > 0) ? true : false
        end
      end

      def define_field_was(field)
        define_method "#{field}_was" do
          _field_history[field][-2] if _field_history && _field_history[field]
        end
      end

      def define_field_changes(field)
        define_method "#{field}_changes" do
          _field_history[field] if _field_history
        end
      end

      def define_field_dynamic(field, is_dynamic_field)
        define_method "is_#{field}_dynamic?" do
          is_dynamic_field
        end
      end

      def define_field_getter(field)
        define_method field do
          instance_variable_get "@#{field}"
        end
      end

      def define_field_setter(field)
        define_method("#{field}=") do |val|
          fld = self.class.fields[field] ? self.class.fields[field] : @_dynamic_fields[field]

          val = coerce(val, fld)

          add_to_field_history field, val

          instance_variable_set "@#{field}", val
        end
      end

      def define_field(field, is_dynamic_field = false)
        define_field_changed field
        define_field_was field
        define_field_changes field
        define_field_dynamic field, is_dynamic_field

        define_field_getter field
        define_field_setter field
      end
    end

    private

    def add_to_field_history(field, value)
      @_field_history ||= {}
      @_field_history[field] ||= []
      @_field_history[field] << value
    end

    def _field_history
      @_field_history ||= {}
    end

  end
end
