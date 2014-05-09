require "json"
require "fetching/fetching_array"
require "fetching/fetching_hash"

module Kernel

  def Fetching(arg)
    Fetching.from(arg)
  end

end

class Fetching

  WHITELIST = %w[ define_singleton_method class object_id
                  == instance_variables instance_eval
                  instance_variable_get ]

  all_methods = instance_methods.map(&:to_s).grep(/\A[^_]/)
  (all_methods - WHITELIST).each(&method(:undef_method))

  def self.from(value)
    case value
    when ->(v) { v.respond_to? :to_ary }
      FetchingArray.new(value.to_ary)
    when ->(v) { v.respond_to? :to_hash }
      FetchingHash.new(value.to_hash)
    else
      value
    end
  end

  def self.from_json json, closure
    from(JSON.parse json).__send__ closure
  end

  def initialize table
    @table = table
  end

  def ==(other)
    other.hash == hash
  end

  def hash
    self.class.hash ^ @table.hash
  end

  def to_s
    @table.to_s
  end

  def inspect
    "#<#{self.class.name}: @table=#{to_s}>"
  end

  private

  def no_method key
  end

end
