class Fetching
  class FetchingArray < Fetching

    include Enumerable

    def [](*args)
      if args.length == 1 && args.first.is_a?(Integer)
        Fetching.from @table.fetch(args.first)
      else
        values_at(*args)
      end
    end

    def each
      @table.each_index do |i|
        yield self[i]
      end
    end

    def first(num = 0)
      return self[0] if num.zero?

      Array.new(num) { |i| self[i] }
    end

    module ArrayMethods

      def empty?
        @table.empty?
      end

      def length
        @table.length
      end
      alias size length

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
        results = args.map { |arg| result_for_argument(arg) }.flatten

        Fetching.from(results)
      end

      private

      def result_for_argument(argument)
        case argument
        when Integer
          values_at_integer(argument)
        when Array
          values_at_array(argument)
        when Range
          values_at_range(argument)
        end
      end

      def values_at_integer(integer)
        self[integer]
      end

      def values_at_array(array)
        array.map { |a| values_at_integer(a) }
      end

      def values_at_range(range)
        values_at_array(range.to_a)
      end
    end

    include ArrayMethods

  end
end
