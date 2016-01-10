class Fetching
  class FetchingArray < Fetching

    include Enumerable

    def [](index)
      Fetching.from @table.fetch(index)
    end

    def each
      @table.each_index do |i|
        yield self[i]
      end
    end

    def first(num = 0)
      return self[0] if num.zero?

      num.times.map { |i| self[i] }
    end

    module ArrayMethods

      def empty?
        @table.empty?
      end

      def length
        @table.length
      end
      alias_method :size, :length

      def reverse
        Fetching.from @table.reverse
      end

      def shuffle(*args)
        Fetching.from @table.shuffle(*args)
      end

      def sort(&block)
        Fetching.from @table.sort(&block)
      end

      def sort_by(&block)
        Fetching.from @table.sort_by(&block)
      end

      def values_at(*args)
        Fetching.from(args.map { |i| self[i] })
      end

    end

    include ArrayMethods

  end
end
