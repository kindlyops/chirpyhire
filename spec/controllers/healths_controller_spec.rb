# frozen_string_literal: true
require 'rails_helper'

RSpec.describe HealthsController, type: :controller do
  describe '#show' do
    it 'is OK' do
      get :show
      expect(response).to be_ok
      expect(response.body).to eq('OK')
    end
  end
end
