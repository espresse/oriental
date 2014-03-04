require_relative 'field'

module Oriental
  module Document
    extend ActiveSupport::Concern
    include Inspector

    included do
      include Fields
      attr_reader :fields
    end

    module ClassMethods
      def find(*args)
        Criteria.new(self).find(args)
      end
    end

    def initialize(**record)
      initialize_fields(record)
    end

    def new_record?
      !rid
    end
  end
end
