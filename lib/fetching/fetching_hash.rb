class Fetching
  class FetchingHash < Fetching

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
          Fetching.from(v)
        end
      end
    end

    def method_missing key, *_args, &_block
      fail NoMethodError, "#{key} not found\nyou have:\n#{@table.inspect}"
    end

  end
end
