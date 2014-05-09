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

  specify "#first" do
    ary = []
    sassy_ary = Fetching(ary)
    expect{ sassy_ary.first }.to raise_error(IndexError)
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

    specify "#length" do
      expect(fetching.length).to eq(array.length)
      expect(fetching.size).to eq(array.size)
    end

    specify "#reverse" do
      reversed = Fetching(array.reverse)
      expect(fetching.reverse).to eq(reversed)
    end

    specify "#shuffle" do
      seed = 1
      shuffled = Fetching(array.shuffle(random: Random.new(seed)))
      expect(fetching.shuffle(random: Random.new(seed))).to eq(shuffled)
    end

    specify "#sort" do
      sorter = ->(x, y){ y <=> x }
      sorted = Fetching(array.sort(&sorter))
      expect(fetching.sort(&sorter)).to eq(sorted)
    end

    specify "#sort_by" do
      sorter = ->(i){ 1/i.to_f }
      sorted = Fetching(array.sort_by(&sorter))
      expect(fetching.sort_by(&sorter)).to eq(sorted)
    end

    describe "#values_at" do
      specify "happy path" do
        at     = [0, 2]
        values = Fetching(array.values_at(*at))
        expect(fetching.values_at(*at)).to eq(values)
      end
      specify "out of bounds" do
        at = 5
        expected_message = "index #{at} outside of array bounds: -3...3"
        expect{ fetching.values_at(at) }.to raise_error(IndexError, expected_message)
      end
    end

  end

end
