require "spec_helper"

describe Fetching::FetchingArray do

  specify "#map" do
    ary = [1, 2]
    fetching_ary = Fetching(ary)
    expect(fetching_ary.map(&:to_s)).to eq(%w[1 2])
  end

  specify "Fetching should go deep" do
    Fetching([{one: 1}]).each do |element|
      expect(element.one).to eq(1)
    end
  end

  describe "array methods" do
    let(:array)    { [1, 2, 3] }
    let(:fetching) { Fetching(array) }

    describe "#empty?" do
      it("should be false"){ expect(fetching.empty?).to be_false }

      context "when empty" do
        let(:array) { [] }
        it("should be true"){ expect(fetching.empty?).to be_true }
      end
    end

    specify "#reverse" do
      reversed = Fetching(array.reverse)
      expect(fetching.reverse).to eq(reversed)
    end

    specify "#shuffle" do
      table = fetching.instance_variable_get(:@table)
      arg   = {random: 1}

      expect(table).to receive(:shuffle).with(arg)
      fetching.shuffle(arg)
    end

    specify "#size" do
      expect(fetching.size).to eq(array.size)
      expect(fetching.length).to eq(array.length)
    end

    specify "#sort" do
      sorted = Fetching(array.sort {|x, y| y <=> x})
      expect(fetching.sort {|x, y| y <=> x}).to eq(sorted)
    end

    specify "#sort_by" do
      sorter = ->(i){ 1/i.to_f }
      sorted = Fetching(array.sort_by(&sorter))
      expect(fetching.sort_by(&sorter)).to eq(sorted)
    end

    specify "#values_at" do
      at     = [0, 2]
      values = Fetching(array.values_at(*at))
      expect(fetching.values_at(*at)).to eq(values)
    end

  end

end
