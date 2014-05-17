require "json"
require "fetching/fetching_array"
require "fetching/fetching_hash"

module Kernel

  def Fetching(arg) # rubocop:disable MethodName
    Fetching.from(arg)
  end

end

class Fetching

  WHITELIST = %w(
    class object_id == equal?
    define_singleton_method instance_eval
    respond_to?
    instance_variables instance_variable_get
  )

  all_methods = instance_methods.map(&:to_s).grep(/\A[^_]/)
  (all_methods - WHITELIST).each(&method(:undef_method))

  def self.from(value)
    return value.to_fetching               if value.respond_to? :to_fetching
    return FetchingArray.new(value.to_ary) if value.respond_to? :to_ary
    return FetchingHash.new(value.to_hash) if value.respond_to? :to_hash
    value
  end

  def self.from_json json
    from(JSON.parse json)
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

  def to_fetching
    self
  end

  def to_s
    @table.to_s
  end

  def inspect
    "#<#{self.class.name}: @table=#{@table}>"
  end

  private

  def respond_to_missing? _method_name, _include_private = false
    false
  end

end
