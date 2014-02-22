module Oriental
  class RecordId < Orientdb::RecordId; end

  class Rid < Virtus::Attribute
    def coerce(value)
      value.is_a?(::Orientdb::RecordId) ? Oriental::RecordId.new(value) : value
      value.is_a?(::String) ? Oriental::RecordId.new(value) : value
    end
  end
end
