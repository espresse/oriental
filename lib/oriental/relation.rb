require_relative './sql_builder/where'
require_relative './sql_builder/find'
require_relative './sql_builder/let'
require_relative './sql_builder/order'
require_relative './sql_builder/group'
require_relative './sql_builder/skip'
require_relative './sql_builder/limit'
require_relative './sql_builder/select'
require_relative './sql_builder/insert'
require_relative './sql_builder/query_types'

module Oriental
  class Relation
    include Enumerable
    include SqlBuilder

    attr_accessor :criteria, :klass, :collection

    def initialize(klass, crit=nil)
      @klass = klass
      @criteria = crit
      @criteria ||= {
        conditions: [],
        target: [],
        let: [],
        order: [],
        group: [],
        limit: [],
        skip: [],
        fields: [],
        set: [],
        params: {}
      }
      @collection = Collection.new
    end

    def to_sql
      add_params build_sql
    end

    def inspect
      execute!
    end

    def each(*args, &block)
      execute!
      collection.each(*args, &block)
    end

    private

    def execute!
      collection.sql = build_sql
      collection.params = criteria[:params]
      collection.prefetch = "*:0"
      collection.query_type = query_type
      self
    end

    def build_sql
      result = ""
      query = self.send "#{query_type.downcase}_query"
      result = query.shift[:query].gsub('?', criteria_query.to_s).strip
      query.each do |q|
        key, val = q.shift
        ckey = self.send("criteria_#{key}")
        result += " " + val.gsub('?', ckey) if ckey and not ckey.empty?
      end
      sql_cleanup(result)
    end

    def query_type(query_type = nil)
      @query_type ||= "SELECT"
    end

    def sql_cleanup(sql)
      sql.gsub(/"(?<rid>#?-?\d+:\d+)"/, '\k<rid>')
    end

    def add_params(sql)
      criteria[:params].each do |key, val|
        if val.is_a? String
          val = "'#{val}'"
        end
        sql = sql.gsub(":#{key.to_s}", val.to_s)
      end
      sql
    end
  end
end
