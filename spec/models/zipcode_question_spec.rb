require 'rails_helper'

RSpec.describe ZipcodeQuestion, type: :model do
  it { should validate_presence_of(:zipcode_question_options) }

  describe '.extract' do
    let(:message) { create(:message, body: ' 30342 ') }
    let(:question) { create(:zipcode_question, zipcode_question_options_attributes: [{ text: '30327' }, { text: '30342' }, { text: '30305' }]) }
    let(:inquiry) { create(:inquiry, question: question) }
    let(:expected_properties) do
      {
        option: '30342',
        child_class: ZipcodeQuestion.child_class_property
      }
    end

    it 'returns the stripped body properties' do
      expect(ZipcodeQuestion.extract(message, inquiry)).to eq(expected_properties)
    end
  end
end
