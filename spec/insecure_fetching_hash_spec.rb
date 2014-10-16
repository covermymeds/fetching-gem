require 'spec_helper'

describe Fetching::InsecureFetchingHash do
  before(:all) { Fetching.use_insecure_hash! }
  after(:all) { Fetching.secure! }

  subject { described_class.new(data) }

  let(:data) do
    {
      :fruit => 'apple',
      "vegetable" => 'carrot',
    }
  end

  it 'references its keys by methods' do
    expect(subject).to respond_to(:fruit)
    expect(subject).to respond_to(:vegetable)
  end

  it 'can be initialized from described_class' do
    expect { described_class.new(subject) }.not_to raise_exception
  end

  it 'can be created from an empty hash' do
    expect { described_class.new({}) }.not_to raise_exception
  end

  describe '#===' do
    context 'when given an object with the same key-value pairs' do
      it 'is true' do
        dup = described_class.new(data)
        expect(subject === dup).to eq(true)
      end

      it 'is true regardless of object type' do
        expect(subject === data).to eq(true)
      end
    end

    context 'when given an object with different keys and/or values' do
      it 'is false' do
        expect(subject === { dessert: 'pie', fruit: 'apple' }).to eq(false)
      end
    end
  end

  context 'when initialized from nested hashes' do
    let(:hash) do
      {
        single: '1',
        nested: data
      }
    end

    let(:fetching_data) { described_class.new(hash) }

    context 'when accessing a key containing another hash' do
      it 'returns the value as a InsecureFetchingHash object' do
        expect(fetching_data.nested.class).to eq(described_class)
      end

      context 'when the key is optional (and populated)' do
        it 'returns the value as a InsecureFetchingHash object' do
          expect(fetching_data.nested?.class).to eq(described_class)
        end
      end
    end
  end

  context 'when accessing a key that does not exist' do
    context 'when told that the key is not required' do
      it 'returns nil' do
        expect(subject.protein?).to be_nil
      end
    end

    context 'when told that the key is required (default)' do
      it 'raises an exception' do
        expect { subject.protein }.to raise_exception(NoMethodError, /protein not found/)
      end
    end
  end

  context 'when one of the keys is an array' do
    let(:hash) do
      { list: [data] }
    end

    let(:fetching_data) { described_class.new(hash) }

    it 'maps each element of the array onto a new InsecureFetchingHash object' do
      expect(fetching_data.list.first.class).to eq(described_class)
    end
  end
end
