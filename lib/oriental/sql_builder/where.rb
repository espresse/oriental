module Oriental
  module SqlBuilder
    include ActiveSupport::Concern

    def where(*args)
      or_conditions = []

      args.each do |arg|
        or_conditions << arg if arg.is_a? String
        or_conditions << parse_hash_condition(arg) if arg.is_a? Hash
      end
      criteria[:conditions] << or_conditions.join(' OR ')
      self
    end

    private

    def parse_hash_condition(hash)
      and_conditions = []

      hash.each do |key, value|
        operator, key, value = parse_key_val(key, value)
        and_conditions << hash_condition(operator, key, value)
      end

      "(" + and_conditions.join(' AND ') + ")"
    end

    def parse_key_val(key, value)
      op = operator_for key
      key, value = value.shift if op
      _op, value = parse_value(key, value)

      op ||= _op
      return op, key, value
    end

    def operator_for(key)
        operators = [
          "$like", "$is", "=", ">", ">=", "<", "<=", "<>",
          "$between", "$in", "$instanceof", "$contains",
          "$containsall", "$containskey", "$containsvalue",
          "$containstext", "$matches"
        ]

        return key.to_s.gsub('$', '').upcase if operators.include?(key.to_s)
        nil
    end

    def parse_value(key, val)
        return '', nil unless val
        return "BETWEEN", val if val.is_a? Range
        return "MATCHES", val.source if val.is_a? Regexp
        return "IN", val if val.is_a? Array

        return "=", val
    end

    def unique_params_key
        (rand(36**8).to_s(36)).to_sym
    end

    def update_params_value(key, value)
        unless value == nil
          params_key = key.to_sym

          params_key = unique_params_key if key.to_s =~ /[.,\/()@]/

          params_key = unique_params_key if (criteria[:params][key.to_sym] and not criteria[:params][key.to_sym] == value)
          criteria[:params][params_key] = value
          key = params_key
        end
        return key
    end

    def hash_params_value(hash)
      params = []
      params_key = {}
      hash.each do |key, val|
        params_key = unique_params_key
        criteria[:params][params_key] = val
        params << "#{key} = :#{params_key}"
      end
      params
    end

    def range_params_value(range)
      range_begin_pk = unique_params_key
      range_end_pk = unique_params_key

      criteria[:params][range_begin_pk] = range.begin
      criteria[:params][range_end_pk] = range.end

      ":#{range_begin_pk} AND :#{range_end_pk}"
    end

    def hash_condition(operator, field, value=nil)
      if value.is_a? Range
        cond = "#{field} #{operator} :params"
        cond.gsub(/:params/, range_params_value(value))
      elsif value.is_a? Hash
        cond = "#{field} #{operator} (:params)"
        cond.gsub(/:params/, hash_params_value(value).join(', '))
      else
        params_key = update_params_value(field, value)

        cond = "#{field} #{operator} "
        cond += (value == nil) ? "null" : ":#{params_key}"
        cond
      end
    end


  end
end
