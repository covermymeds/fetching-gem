require "spec_helper"

describe Fetching do

  let(:input)       { { one: 1, two: two, ary: ary, object_ary: object_ary } }
  let(:two)         { { "two" => 2 } }
  let(:ary)         { [1, 2] }
  let(:object_ary)  { [{}, last_object] }
  let(:last_object) { { three: 3 } }

  subject { Fetching(input) }
  specify("#one") { expect(subject.one).to eq(1) }
  specify("#two") { expect(subject.two).to eq(Fetching(two)) }
  specify("#ary") { expect(subject.ary).to eq(Fetching(ary)) }
  specify "objects in arrays" do
    expect(subject.object_ary[1].three).to eq(3)
  end

  describe "an unknown hash key" do
    it "raises NoMethodError" do
      expected_message = <<-EOM.gsub(/^ +/, "").strip
        not_a_key not found
        you have:
        {:one=>1, :two=>{\"two\"=>2}, :ary=>[1, 2], :object_ary=>[{}, {:three=>3}]}
      EOM

      expect { subject.not_a_key }.to raise_error(NoMethodError, expected_message)
    end
  end

  describe "an unknown array index" do
    it "raises NoMethodError" do
      expected_message = /\Aindex 3 out/
      expect { subject.ary[ary.size + 1] }.to raise_error(IndexError, expected_message)
    end
  end

  it "has a nice #to_s" do
    nice_to_s = "{:one=>1, :two=>{\"two\"=>2}, :ary=>[1, 2], :object_ary=>[{}, {:three=>3}]}"
    expect(subject.to_s).to eq(nice_to_s)
  end

  it "has a nice #inspect" do
    table = "{:one=>1, :two=>{\"two\"=>2}, :ary=>[1, 2], :object_ary=>[{}, {:three=>3}]}"
    nice_inspect = "#<Fetching::FetchingHash: @table=#{table}>"
    expect(subject.inspect).to eq(nice_inspect)
  end

  specify ".from_json" do
    json     = '{ "some_key": 1 }'
    expected = Fetching(JSON.parse(json))
    expect(described_class.from_json(json)).to eq(expected)
  end

  # some of these specs may seem redundant, but several cases
  #+ generated NoMethodErrors previously so I wanted to make sure
  #+ all use cases work now
  describe '#nil?' do
    it 'is true if the object is nil' do
      expect(Fetching(nil)).to be_nil
    end

    it 'is true if the value of a key in a FetchingHash is nil' do
      expect(Fetching(value: nil).value).to be_nil
    end

    it 'is true if the value of an index in a FetchingArray is nil' do
      expect(Fetching(['a', nil, 'b'])[1]).to be_nil
    end

    it 'is false if the object has a value' do
      expect(Fetching({})).not_to be_nil
    end

    it 'is false if the value of a key in a FetchingHash is non-nil' do
      expect(Fetching(value: 'not nil!').value).not_to be_nil
    end

    it 'is false if the value of an index in a FetchingArray is non-nil' do
      expect(Fetching(['a', 1, 'b'])[1]).not_to be_nil
    end
  end
end
