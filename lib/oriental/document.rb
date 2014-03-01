module Oriental
  module Document
    extend ActiveSupport::Concern

    included do
      include Virtus::Model
      include Oriental::Attributes::Base
    end

    module ClassMethods
      def find(*args)
        Oriental::Criteria.new(self).find(args)
      end
    end

    def initialize(record = {})
      unless record.empty?
        record[:properties] = record.clone
          
        map = record.map do |k, v|
          k = k.to_s[1..-1].to_sym if k.to_s[0] == "@"
          k = :klass if k == :class
          [k, v]
        end
          
        record = Hash[map]
      end

      super record
    end

    def new?
      !rid
    end

  end
end
