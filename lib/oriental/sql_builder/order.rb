module Oriental
  module SqlBuilder
    include ActiveSupport::Concern

    def order(arg)
      arg.each do |key, val|
        param = {}
        param[key] = val
        criteria[:order] << param
      end
      self
    end
  end
end
