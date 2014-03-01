module Oriental
  module SqlBuilder
    include ActiveSupport::Concern

    def group(arg)
      criteria[:group] << arg
      self
    end
  end
end
