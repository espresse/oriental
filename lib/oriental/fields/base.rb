module Oriental
  module Fields
    module Base
      extend ActiveSupport::Concern

      included do
        field :rid, type: Oriental::RecordId
        field :_klass, type: String
        field :_type, type: String
      end
    end
  end
end
