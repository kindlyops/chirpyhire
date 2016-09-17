# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Constraint::Answer do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { described_class.new }
  let(:organization) { create(:organization) }

  before do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe '#matches?' do
    context 'with user present' do
      let(:user) { create(:user, organization: organization) }
      let(:message) { create(:message, user: user) }
      context 'with candidate present' do
        let(:candidate) { create(:candidate, user: user) }

        let(:parameters) { { 'From' => candidate.phone_number, 'To' => organization.phone_number } }
        context 'without outstanding inquiry present' do
          it 'is false' do
            expect(constraint.matches?(request)).to eq(false)
          end
        end

        context 'with outstanding inquiry' do
          let!(:inquiry) { create(:inquiry, message: message) }

          it 'is true' do
            expect(constraint.matches?(request)).to eq(true)
          end
        end
      end

      context 'without candidate present' do
        let(:parameters) { { 'From' => '+14041111111', 'To' => organization.phone_number } }

        it 'is false' do
          expect(constraint.matches?(request)).to eq(false)
        end
      end
    end

    context 'without user present' do
      let(:parameters) { { 'From' => '+14041111111', 'To' => organization.phone_number } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end
