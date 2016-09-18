require 'rails_helper'

RSpec.describe StageDefaults do
  describe "defaults" do
    it "has four defaults" do
      expect(StageDefaults.defaults.count).to eq(4)
    end
  end
end
