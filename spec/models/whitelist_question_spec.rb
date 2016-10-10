require 'rails_helper'

RSpec.describe WhitelistQuestion, type: :model do
  it { should validate_presence_of(:whitelist_question_options) }

  describe '.extract' do
    let(:message) { create(:message, body: ' 30342 ') }
    let(:question) { create(:whitelist_question, whitelist_question_options_attributes: [{ text: '30327' }, { text: '30342' }, { text: '30305'} ]) }
    let(:inquiry) { create(:inquiry, question: question) }
    let(:expected_properties) do
      {
        whitelist_option: '30342',
        child_class: WhitelistQuestion.child_class_property
      }
    end

    it 'returns the stripped body properties' do
      expect(WhitelistQuestion.extract(message, inquiry)).to eq(expected_properties)
    end
  end
end
