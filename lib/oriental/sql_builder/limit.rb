module Oriental
  module SqlBuilder
    include ActiveSupport::Concern

    def limit(num)
      criteria[:limit] << num
      self
    end
  end
end
