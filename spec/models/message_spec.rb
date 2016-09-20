require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#has_address?' do
    context 'without a body' do
      let(:message) { create(:message, body: nil) }

      it 'is false' do
        expect(message.has_address?).to eq(false)
      end
    end

    context 'with a body' do
      let(:message) { create(:message, body: 'Test Body') }

      before(:each) do
        allow(message).to receive(:address).and_return(OpenStruct.new(found?: true))
      end

      it 'is true' do
        expect(message.has_address?).to eq(true)
      end
    end
  end

  describe 'has_choice?' do
    let(:choices) { 'abc' }

    context 'without a body' do
      let(:message) { create(:message, body: nil) }

      it 'is false' do
        expect(message.has_choice?(choices)).to eq(false)
      end
    end

    context 'with a body' do
      context 'that just includes a choice letter' do
        it 'is true' do
          ['A', 'a', 'A)         ', 'a)'].each do |body|
            expect(create(:message, body: body).has_choice?(choices)).to eq(true)
          end
        end
      end

      context "that includes a letter that isn't a choice" do
        it 'is false' do
          ['Y', 'y', 'Y)     ', 'y)'].each do |body|
            expect(create(:message, body: body).has_choice?(choices)).to eq(false)
          end
        end
      end

      context 'that does not just include a choice letter' do
        let(:message) { create(:message, body: 'Test Body') }

        it 'is false' do
          expect(message.has_choice?(choices)).to eq(false)
        end
      end
    end
  end
end
