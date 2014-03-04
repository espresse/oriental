module Oriental
  class RecordId < Orientdb::RecordId
    def to_s
      unless cluster && position
        "nil"
      else
        "##{cluster}:#{position}"
      end
    end
  end
end
