require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  context "not logged in" do
    describe "#index" do
      it "302s" do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end
end
