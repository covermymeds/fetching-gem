RSpec.describe Fetching::FetchingHash do

  specify "a Fetching object as a value" do
    ary = Fetching([1, 2])
    hsh = Fetching(one: 1)
    [ary, hsh].each do |obj|
      fetching_ary = Fetching key: obj
      expect(fetching_ary.key).to equal(obj)
    end
  end

  specify "#to_hash" do
    hash = { one: 1, two: 2 }
    fetching_hash = Fetching(hash)
    expect(fetching_hash.to_hash).to eq(hash)
  end

  specify "#to_hash doesn't allow you to break fetching" do
    fetching_hash = Fetching(one: 1, two: 2)
    hash = fetching_hash.to_hash
    hash[:one] = ":)"
    expect(fetching_hash.to_hash[:one]).to eq(1)
  end

  specify "#to_hash does a deep copy" do
    hash = { one: 1, two: { three: 3 } }
    fetching_hash = Fetching(hash)
    expect(fetching_hash.to_hash).to eq(hash)
  end

end
