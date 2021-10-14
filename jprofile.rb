require 'json'

class ObjectParser

    def initialize()
        @type_rules = [
            [Float, Integer, NilClass],
            [String, NilClass],
        ]
    end

    def consolidate_item(memo, obj)
        return obj if memo == nil
        return memo if obj == nil
        # Now both memo and obj are not null.
        if memo.is_a?(Hash) && obj.is_a?(Hash)
            return consolidate_hash(memo, obj)
        elsif memo.is_a?(Array) && obj.is_a?(Array)
            # reduced_array = consolidate_array(obj)
            # todo: we may want to test if two arraies are homogeneous but
            # that's too much for now.
            return memo
        end
        return memo if memo.class == obj.class
        if memo.is_a?(Integer)
            raise "nonhomogeneous array items: #{memo} vs #{obj}" if !obj.is_a?(Float)
            return obj  # replace integer with a float
        elsif memo.is_a?(Float)
            raise "nonhomogeneous array items: #{memo} vs #{obj}" if !obj.is_a?(Integer)
            return memo
        elsif (memo.is_a?(TrueClass) && obj.is_a?(FalseClass)) || (memo.is_a?(FalseClass) && obj.is_a?(TrueClass))
            return memo
        else
            raise "nonhomogeneous array items: #{memo} vs #{obj}"
        end
    end

    def consolidate_array(arr)
        return arr if arr.length == 0
        memo = arr[0].is_a?(Array) ? consolidate_array(arr[0]) : arr[0]
        (1...arr.length).each {|idx|
            memo = consolidate_item(memo, arr[idx])
        }
        return [memo]
    end

    def consolidate_hash(consolidated_hash, hash)
        hash.each_pair {|key, value|
            consolidated_value = if value.is_a? Hash
                consolidate_hash({}, value)
                elsif value.is_a? Array
                    consolidate_array(value)
                else
                    # base types like string, number
                    value
                end
            if consolidated_hash.key?(key)
                consolidated_hash[key] = consolidate_item(consolidated_hash[key], consolidated_value)
            else
                consolidated_hash[key] = consolidated_value
            end
        }
        return consolidated_hash
    end
end

if __FILE__ == $0
    obj = JSON.load($<)

    parser = ObjectParser.new

    if obj.is_a? Hash
        hash = parser.consolidate_hash({}, obj)
        puts JSON.pretty_generate(hash)
    elsif obj.is_a? Array
        arr = parser.consolidate_array(item)
        puts JSON.pretty_generate(arr)
    end
end
