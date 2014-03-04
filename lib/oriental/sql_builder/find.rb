module Oriental
  module SqlBuilder
    include ActiveSupport::Concern

    def find(obj)
      from obj
      return take(1).first if obj.is_a? String or obj.is_a? RecordId
      return to_a if obj.is_a? Array
    end

    def find_by(*args)
      where(*args).take(1).first
    end

    def from(obj)
      if obj.is_a? String or obj.is_a? RecordId
        criteria[:target] << obj
      else
        criteria[:target] |= obj
      end
      self
    end
  end
end
