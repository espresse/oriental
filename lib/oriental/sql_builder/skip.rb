module Oriental
  module SqlBuilder
    include ActiveSupport::Concern

    def skip(num)
      criteria[:skip] << num
      self
    end
  end
end
