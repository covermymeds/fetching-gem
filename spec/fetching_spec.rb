require "spec_helper"

describe Fetching do

  let(:input)       { { one: 1, two: two, ary: ary, object_ary: object_ary } }
  let(:two)         { { "two"=>2 } }
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
      expected_message = "not_a_key not found\nyou have:\n{:one=>1, :two=>{\"two\"=>2}, :ary=>[1, 2], :object_ary=>[{}, {:three=>3}]}"

      expect{ subject.not_a_key }.to raise_error(NoMethodError, expected_message)
    end
  end

  describe "an unknown array index" do
    it "raises NoMethodError" do
      expected_message = "index 3 outside of array bounds: -2...2"
      expect{ subject.ary[ary.size + 1] }.to raise_error(IndexError, expected_message)
    end
  end

  describe "a bad closure" do
    it "raises the expected error" do
      expect { Fetching.from_json("{}", :not_a_key) }.to raise_error(NoMethodError)
    end
  end

  it "has a nice #to_s" do
    nice_to_s = "{:one=>1, :two=>{\"two\"=>2}, :ary=>[1, 2], :object_ary=>[{}, {:three=>3}]}"
    expect(subject.to_s).to eq(nice_to_s)
  end

  it "has a nice #inspect" do
    nice_inspect = "#<Fetching::FetchingHash: @table={:one=>1, :two=>{\"two\"=>2}, :ary=>[1, 2], :object_ary=>[{}, {:three=>3}]}>"
    expect(subject.inspect).to eq(nice_inspect)
  end

end
