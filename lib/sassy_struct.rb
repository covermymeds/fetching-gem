require "json"

module Kernel

  def Sassy(arg)
    Sassy.from(arg)
  end

end

class Sassy

  WHITELIST = %w[ define_singleton_method class object_id
                  == inspect to_s instance_variables instance_eval
                  instance_variable_get ]
  all_methods = instance_methods.map(&:to_s).grep(/\A[^_]/)
  (all_methods - WHITELIST).each(&method(:undef_method))

  def self.from(value)
    case value
    when ->(v) { v.respond_to? :to_ary }
      SassyArray.new(value.to_ary)
    when ->(v) { v.respond_to? :to_hash }
      SassyHash.new(value.to_hash)
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

  private

  def no_method key
  end

end

class SassyArray < Sassy

  include Enumerable

  def [](index)
    Sassy.from @table.fetch(index)
  end

  def each
    @table.each_index do |i|
      yield self[i]
    end
  end

end

class SassyHash < Sassy

  def initialize *args
    super
    make_methods
  end

  def to_hash
    @table.dup
  end

  private

  def make_methods
    @table.each do |k, v|
      define_singleton_method(k) do
        Sassy.from(v)
      end
    end
  end

  def method_missing key, *args, &block
    fail NoMethodError, "#{key} not found\nyou have:\n#{@table.inspect}"
  end

end
