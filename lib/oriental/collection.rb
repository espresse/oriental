module Oriental
  class Collection
    include Enumerable

    attr_accessor :data, :sql, :params, :prefetch, :query_type

    def initialize
      @data = Array.new
    end

    def each(*args, &block)
      return enum_for(__method__) if block.nil?

      fetch_data

      if data[:collection]
        data[:collection].each do |record|
          res = parse_record(record)

          name = res[:@class] || res[:class]

          constant = Object
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)

          block.call(constant.new(res))
        end
      end
    end

    def command?
      !(not @query_type or @query_type == 'SELECT')
    end

    private

    def fetch_data
      connection = Oriental::Connection.connect

      @data = command? ? connection.database.command(sql, params) : connection.database.query(sql, params, prefetch)

      if data[:exceptions]
        raise data[:exceptions].map {|exception| exception[:exception_message]}.join(', ')
      end
      self
    end

    def parse_record(record)
      res = OrientdbBinary::Parser::Deserializer.new.deserialize_document(record[:record_content])
      res[:@rid] = Oriental::RecordId.new "##{record[:cluster_id]}:#{record[:position]}"
      res
    end

  end
end
