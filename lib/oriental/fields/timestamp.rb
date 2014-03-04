module Oriental
  module Fields
    module Timestamp
      extend ActiveSupport::Concern

      included do
        field :created_at, type: DateTime
        field :updated_at, type: DateTime

        before :create do
          self.created_at = DateTime.now
        end

        before :save do
          self.updated_at = DateTime.now
        end
      end
    end
  end
end
