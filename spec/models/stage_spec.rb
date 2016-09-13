require 'rails_helper'

RSpec.describe Stage, type: :model do
  describe "defaults" do
    it "has four defaults" do
      expect(Stage.defaults.count).to eq(4)
    end
  end
end
