require 'json'

class ObjectParser

    def initialize()
    end

    def consolidate_item(consolidated_array, item)
        # consolidated_array contains all possible data types the items of an
        # array can have except for hash - there will be only one consolidated
        # hash type, assuming all hash items are homogeneous.
        idx = consolidated_array.find_index{|i|i.class == item.class}
        if idx.nil?
            if item.is_a? Hash
                consolidated_array << consolidate_hash({}, item)
            elsif item.is_a? NilClass
                # Null in an array is probably by mistake, if not by bad design.
                # We will just ignore them. If we do want to see them as a
                # alternative data type, enable the following statement to add
                # Null into the type array.
                # consolidated_array << item
            else
                abort "not handled type for first item: #{item.class.name}"
            end
        else
            # if already existed...
            if item.is_a? Hash
                consolidate_hash(consolidated_array[idx], item)
            elsif %w[String]
                # sample types, do nothing
            else
                abort "not handled type: #{item.class.name}"
            end
        end
        return consolidated_array
    end

    def consolidate_array(consolidated_array, arr)
        arr.each {|item|consolidate_item(consolidated_array, item)}
        return consolidated_array
    end

    def consolidate_hash(consolidated_hash, hash)
        hash.each_pair {|key, value|
            consolidated_value = if value.is_a? Hash
                consolidate_hash({}, value)
                elsif value.is_a? Array
                    consolidate_array([], value)
                else
                    # base types like string, number
                    value
                end
            if consolidated_hash.key?(key)
                existed_value = consolidated_hash[key]
                if existed_value.class != consolidated_value.class
                    abort "nonhomogeneous property '#{key}'"
                end
            else
                consolidated_hash[key] = consolidated_value
            end
        }
        return consolidated_hash
    end
end


obj = JSON.load($<)

parser = ObjectParser.new

if obj.is_a? Hash
    hash = parser.consolidate_hash({}, obj)
    puts JSON.pretty_generate(hash)
elsif obj.is_a? Array
    arr = []
    obj.each {|item|parser.consolidated_array(arr, item)}
    puts JSON.pretty_generate(arr)
end
