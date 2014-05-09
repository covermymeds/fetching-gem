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

    module ArrayMethods

      def empty?
        @table.empty?
      end

      def reverse
        Fetching.from @table.reverse
      end

      def shuffle *args
        Fetching.from @table.shuffle(*args)
      end

      def size
        @table.size
      end
      alias length size

      def sort &block
        Fetching.from @table.sort(&block)
      end

      def sort_by &block
        Fetching.from @table.sort_by(&block)
      end

      def values_at *args
        Fetching.from @table.values_at(*args)
      end

    end

    include ArrayMethods

  end
end
