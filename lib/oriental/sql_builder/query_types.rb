module Oriental
  module SqlBuilder
    include ActiveSupport::Concern

    private

    def select_query(*args)
      [
        { query:  "SELECT ?" },
        { target: "FROM ?"   },
        { let:    "LET ?"    },
        { where:  "WHERE ?"  },
        { group:  "GROUP ?"  },
        { order:  "ORDER ?"  },
        { skip:   "SKIP ?"   },
        { limit:  "LIMIT ?"  }
      ]
    end

    def criteria_query
      criteria[:fields].join(', ')
    end

    def criteria_target
      return @klass.to_s if criteria[:target].empty?
      list = criteria[:target].join(', ')
      list = "[#{list}]" if criteria[:target].length > 1
      list
    end

    def criteria_let
      res = []

      criteria[:let].each do |crit|
        crit.each do |key, val|
          if val.is_a? Proc
            res << "#{key} = " + Oriental::Relation.new(@klass).instance_eval(&value)
          else
            res << "#{key} = #{val}"
          end
        end
      end

      res.length > 0 ? "(" + res.join(', ') + ")" : nil
    end

    def criteria_where
      criteria[:conditions].join(' AND ')
    end

    def criteria_group
    end

    def criteria_order
    end

    def criteria_skip
    end

    def criteria_limit
    end
  end
end
