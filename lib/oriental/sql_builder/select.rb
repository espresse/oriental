module Oriental
  module SqlBuilder
    include ActiveSupport::Concern

    def select(*fields)
      criteria[:fields] |= fields
      self
    end
  end
end
