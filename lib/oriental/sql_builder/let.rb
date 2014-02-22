module Oriental
  module SqlBuilder
    include ActiveSupport::Concern

    def let(*args)
      criteria[:let] |= args if args.is_a? Array
      criteria[:let] << args unless args.is_a? Array
      self
    end
  end
end
