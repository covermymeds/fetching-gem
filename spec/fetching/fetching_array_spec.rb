RSpec.describe Fetching::FetchingArray do

  specify 'a Fetching object as a value' do
    ary = Fetching([1, 2])
    hsh = Fetching(one: 1)
    [ary, hsh].each do |obj|
      fetching_ary = Fetching [obj]
      expect(fetching_ary.first).to equal(obj)
    end
  end

  specify '#map' do
    ary = [1, 2]
    fetching_ary = Fetching(ary)
    expect(fetching_ary.map(&:to_s)).to eq(%w(1 2))
  end

  specify 'Fetching goes deep' do
    Fetching([{ one: 1 }]).each do |element|
      expect(element.one).to eq(1)
    end
  end

  describe '#first' do
    it 'returns the first element in the array' do
      ary = []
      sassy_ary = Fetching(ary)
      expect { sassy_ary.first }.to raise_error(IndexError)
    end

    context 'when passed an amount to fetch the first of' do
      it 'returns the first n elements' do
        ary = [1, 2, 3]
        sassy_ary = Fetching(ary)
        expect(sassy_ary.first(2)).to eq([1, 2])
      end
    end
  end

  describe '#[]' do
    let(:array)    { [1, 2, 3] }
    let(:fetching) { Fetching(array) }

    it 'returns the specified index' do
      expect(fetching[0]).to eq(1)
      expect(fetching[1]).to eq(2)
      expect(fetching[2]).to eq(3)
    end

    it 'throws an error on an invalid index' do
      expect { fetching[5] }.to raise_error(IndexError)
    end

    context 'with multiple values' do
      it 'returns a fetching array of the results' do
        expected = Fetching([1, 2])
        expect(fetching[0, 1]).to eq(expected)
      end

      it 'raises error on invalid index' do
        expect { fetching[0, 5] }.to raise_error(IndexError)
      end
    end

    context 'with a Range' do
      it 'returns a fetching array of the results' do
        expected = Fetching([1, 2])
        expect(fetching[0..1]).to eq(expected)
      end

      it 'raises error on invalid index' do
        expect { fetching[0..5] }.to raise_error(IndexError)
      end
    end

    context 'with multiple ranges' do
      it 'returns a fetching array of the results' do
        expected = Fetching([1, 2, 3, 3])
        expect(fetching[0..2, 2..2]).to eq(expected)
      end

      it 'raises error on invalid index' do
        expect { fetching[0..1, 5..5] }.to raise_error(IndexError)
      end
    end
  end

  describe 'array methods' do
    let(:array)    { [1, 2, 3] }
    let(:fetching) { Fetching(array) }

    describe '#empty?' do
      it('is false') { expect(fetching.empty?).to be_falsy }

      context 'when empty' do
        let(:array) { [] }
        it('is true') { expect(fetching.empty?).to be_truthy }
      end
    end

    specify '#length' do
      expect(fetching.length).to eq(array.length)
      expect(fetching.size).to eq(array.size)
    end

    specify '#reverse' do
      reversed = Fetching(array.reverse)
      expect(fetching.reverse).to eq(reversed)
    end

    specify '#shuffle' do
      seed = 1
      shuffled = Fetching(array.shuffle(random: Random.new(seed)))
      expect(fetching.shuffle(random: Random.new(seed))).to eq(shuffled)
    end

    specify '#sort' do
      sorter = ->(x, y) { y <=> x }
      sorted = Fetching(array.sort(&sorter))
      expect(fetching.sort(&sorter)).to eq(sorted)
    end

    specify '#sort_by' do
      sorter = ->(i) { 1.0 / i }
      sorted = Fetching(array.sort_by(&sorter))
      expect(fetching.sort_by(&sorter)).to eq(sorted)
    end

    describe '#values_at' do
      specify 'happy path' do
        at     = [0, 2]
        values = Fetching(array.values_at(*at))
        expect(fetching.values_at(*at)).to eq(values)
      end

      specify 'out of bounds' do
        at = 5
        expected_message = /\Aindex #{at} out/
        expect { fetching.values_at(at) }.to raise_error(IndexError, expected_message)
      end

      context 'with a range' do
        it 'returns the expected values' do
          range = (0..2)
          values = Fetching(array.values_at(range))
          expect(fetching.values_at(range)).to eq(values)
        end

        it 'correctly throws when range exceeds array' do
          range = (0..5)
          values = Fetching(array.values_at(range))
          expect { fetching.values_at(range) }.to raise_error(IndexError)
        end
      end

      context 'with multiple ranges' do
        let(:array)    { [1, 2, 3, 4, 5] }

        it 'returns the proper values' do
          range_1 = (0..2)
          range_2 = (2..4)
          expected = Fetching([1, 2, 3, 3, 4, 5])
          values = Fetching(array.values_at(range_1, range_2))
          expect(values).to eq(expected)
        end

        it 'correctly throws when range exceeds array' do
          range_1 = (0..2)
          range_2 = (2..7)
          values = Fetching(array.values_at(range_1, range_2))
          expect { fetching.values_at(range_1, range_2) }.to raise_error(IndexError)
        end
      end
    end
  end
end
