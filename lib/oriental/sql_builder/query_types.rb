require 'json'

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
        { group:  "GROUP BY ?"  },
        { order:  "ORDER BY ?"  },
        { skip:   "SKIP ?"   },
        { limit:  "LIMIT ?"  }
      ]
    end

    def insert_query(*args)
      [
        { query:  "INSERT" },
        { target: "INTO ?"   },
        { set:    "SET ?"    }
      ]
    end

    # needs refactoring
    # proposal:
    # relation.select('*').count(:name)
    # relation.expand(:roles)
    # relation.func(first: {params: [], return: []})
    # relation.in(:roles).out(:other) => select in(roles), out(other)
    # relation.chain(-> {in(:roles)}, -> {out(:other)}) => select in(roles).out(other)
    def criteria_query
      fields = []
      criteria[:fields].each do |field|
        if field.is_a? String or field.is_a? Symbol
          fields << field
        elsif field.is_a? Hash
          field.each do |key, val|
            unless [:out, :in, :expand, :min, :max, :sum, :first].include? key
              val.each { |k, v| fields << exclude_or_include_fields(k, key, v) } if val.is_a? Hash
            else
              fields << "#{key}(#{val})" if [String, Symbol].include? val.class
              if val.is_a? Hash
                fld = "#{key}(#{val.keys.join(', ')})"
                val.each do |_field, field_actions|
                  if field_actions.is_a? Array
                    fld += "[" + field_actions.map {|n| "'#{n}'"}.join(', ') + "]"
                  else
                    field_actions.each { |action, flds| fld += "." + exclude_or_include_fields(action, nil, flds) }
                  end
                end
                fields << fld
              end
            end
          end
        end
      end
      fields.join(', ')
    end

    def exclude_or_include_fields(action, base, fields)
      flds = fields.map {|f| "'#{f}'"}
      base = "#{base}." if base
      "#{base}#{action}(#{flds.join(', ')})"
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
      criteria[:group].first.to_s
    end

    def criteria_order
      criteria[:order].map {|entity| entity.map {|name, ord| "#{name} #{ord}"}}.join(', ')
    end

    def criteria_skip
      criteria[:skip].first.to_s
    end

    def criteria_limit
      criteria[:limit].first.to_s
    end

    def criteria_set
      criteria[:set].map {|entity| entity.map {|name, val| "#{name} = #{process_val(val)}"}}.join(', ')
    end

    def process_val(val)
      val = val.to_s if val.is_a? Symbol or val.is_a? DateTime
      # it'd be better if single quote (') was used iso double quote (")
      return "\"#{val}\"" if val.is_a? String
      if val.is_a? Array
        res = []
        res = val.map {|v| process_val(v)}
        return "[" + res.join(', ') + "]"
      end
      if val.is_a? Set
        res = []
        res = val.map {|v| process_val(v)}
        return "Set(" + res.join(', ') + ")"
      end
      if val.is_a? Hash
        val = val.map {|k,v| "'#{k}':#{process_val(v)}"}
        return "{" + val.join(', ') + "}"
      end
      return val
    end
  end
end
