module Oriental
  module Attributes
    module Base
      extend ActiveSupport::Concern

      included do
        attribute :rid, Oriental::Rid
        attribute :klass, String
        attribute :type, String
      end
    end
  end
end
