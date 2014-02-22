module Oriental
  module Attributes
    module Timestamp
      extend ActiveSupport::Concern

      included do
        attribute :created_at, DateTime
        attribute :updated_at, DateTime
      end
    end
  end
end
