RSpec.shared_examples "address won't be found" do
  describe "#found?" do
    it "is false" do
      expect(finder.found?).to eq(false)
    end
  end
end
