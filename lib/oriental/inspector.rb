module Oriental
  module Inspector
    def inspect
      string = "#<#{self.class.name}:#{self.object_id} "
      fields = self.class.fields.map{|field| "@#{field.first}: #{self.send(field.first) || 'nil'}"}
      fields |= _dynamic_fields.map {|field| "@#{field.first}: #{self.send(field.first) || 'nil'}"} if _dynamic_fields
      string << fields.join(", ") << ">"
    end

    def self.inspected
      @inspected ||= []
    end

  end
end
