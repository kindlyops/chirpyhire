require 'rails_helper'

RSpec.describe Bot::ChoiceAnswer do
  let(:follow_up) { create(:choice_follow_up, rank: rank) }
  let(:message) { create(:message, body: body) }

  subject { Bot::ChoiceAnswer.new(follow_up) }

  describe 'activated?' do
    context 'rank is 1' do
      let(:rank) { 1 }

      ['A', "A\nJazz", '  A', 'A  ', "A\n", 
        "\nA", 'A OK'].each do |body|
        context body do
          let(:message) { create(:message, body: body) }

          it 'is true' do
            expect(subject.activated?(message)).to eq(true)
          end
        end
      end

      ['Another one bites the dust'].each do |body|
        context body do
          let(:message) { create(:message, body: body) }

          it 'is false' do
            expect(subject.activated?(message)).to eq(false)
          end
        end
      end
    end

    context 'rank is 5' do
      let(:rank) { 5 }

      ['E', "E\nJazz", '  E', 'E  ', "E\n", 
        "\nE", 'E OK'].each do |body|
        context body do
          let(:message) { create(:message, body: body) }

          it 'is true' do
            expect(subject.activated?(message)).to eq(true)
          end
        end
      end

      ['Eewwwww'].each do |body|
        context body do
          let(:message) { create(:message, body: body) }

          it 'is false' do
            expect(subject.activated?(message)).to eq(false)
          end
        end
      end
    end
  end
end
