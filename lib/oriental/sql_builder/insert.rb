module Oriental
  module SqlBuilder
    include ActiveSupport::Concern

    def insert()
      @query_type = "INSERT"
      self
    end

    def set(*args)
      criteria[:set] |= args
      self
    end
  end
end
