module Oriental
  module Document
    extend ActiveSupport::Concern

    included do
      include Virtus::Model
      include Oriental::Attributes::Base
    end
  end
end
