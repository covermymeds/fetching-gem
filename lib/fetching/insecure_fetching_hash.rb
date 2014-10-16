# an InsecureFetchingHash is so-called because the user can turn off error checking
#+ by specifying that the "key" (method) they are asking for is not required
#+ which makes the actual fetching insecure -- there is no guarantee you will get a value back
class Fetching
  class InsecureFetchingHash < Fetching::FetchingHash
    NIL_ALLOWED_SUFFIX = '\?'    # going in a regexp -- escape the ?

    def initialize(data)
      return data if data.is_a? InsecureFetchingHash
      super
    end

    def ===(other)
      self.to_hash == other.to_hash
    end

    def method_missing(method, *_args, &_block)
      if method =~ /^(.*)#{NIL_ALLOWED_SUFFIX}$/
        key = $1
        value_for(key)
      else
        super
      end
    end

    private

    def make_methods
      @table.each do |k, v|
        define_singleton_method(k) do
          Fetching.from(v, secure = false)
        end
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      !value_for(method_name).nil?
    end

    def value_for(key)
      value = @table[key.to_s] || @table[key.to_sym]
      Fetching.from(value, secure = false)
    end
  end
end
